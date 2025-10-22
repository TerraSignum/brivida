import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/calendar_event.dart';
import '../data/calendar_repo.dart';
import 'calendar_conflict_exception.dart';

// Calendar view modes
enum CalendarViewMode { month, week, day }

// Event filter options
enum EventFilter { all, job, private, availability }

// Calendar UI state
class CalendarState {
  final CalendarViewMode viewMode;
  final DateTime focusedDate;
  final DateTime selectedDate;
  final Set<EventFilter> activeFilters;
  final bool isLoading;
  final String? error;

  const CalendarState({
    this.viewMode = CalendarViewMode.month,
    required this.focusedDate,
    required this.selectedDate,
    this.activeFilters = const {EventFilter.all},
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    CalendarViewMode? viewMode,
    DateTime? focusedDate,
    DateTime? selectedDate,
    Set<EventFilter>? activeFilters,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      viewMode: viewMode ?? this.viewMode,
      focusedDate: focusedDate ?? this.focusedDate,
      selectedDate: selectedDate ?? this.selectedDate,
      activeFilters: activeFilters ?? this.activeFilters,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CalendarController extends StateNotifier<CalendarState> {
  final CalendarRepository _repo;
  final String _ownerUid;

  CalendarController(this._repo, this._ownerUid)
    : super(
        CalendarState(
          focusedDate: DateTime.now(),
          selectedDate: DateTime.now(),
        ),
      );

  // Update view mode
  void setViewMode(CalendarViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  // Update focused date
  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }

  // Update selected date
  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  // Toggle event filter
  void toggleFilter(EventFilter filter) {
    final newFilters = Set<EventFilter>.from(state.activeFilters);

    if (filter == EventFilter.all) {
      // If "all" is selected, clear other filters
      newFilters.clear();
      newFilters.add(EventFilter.all);
    } else {
      // Remove "all" if present, toggle the specific filter
      newFilters.remove(EventFilter.all);
      if (newFilters.contains(filter)) {
        newFilters.remove(filter);
      } else {
        newFilters.add(filter);
      }

      // If no specific filters are active, add "all"
      if (newFilters.isEmpty) {
        newFilters.add(EventFilter.all);
      }
    }

    state = state.copyWith(activeFilters: newFilters);
  }

  // Get date range for current view
  ({DateTime from, DateTime to}) getDateRange() {
    switch (state.viewMode) {
      case CalendarViewMode.day:
        final start = DateTime(
          state.focusedDate.year,
          state.focusedDate.month,
          state.focusedDate.day,
        );
        final end = start.add(const Duration(days: 1));
        return (from: start, to: end);

      case CalendarViewMode.week:
        final start = state.focusedDate.subtract(
          Duration(days: state.focusedDate.weekday - 1),
        );
        final startOfWeek = DateTime(start.year, start.month, start.day);
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return (from: startOfWeek, to: endOfWeek);

      case CalendarViewMode.month:
        final start = DateTime(
          state.focusedDate.year,
          state.focusedDate.month,
          1,
        );
        final end = DateTime(
          state.focusedDate.year,
          state.focusedDate.month + 1,
          1,
        );
        return (from: start, to: end);
    }
  }

  // Filter events based on active filters
  List<CalendarEvent> filterEvents(List<CalendarEvent> events) {
    if (state.activeFilters.contains(EventFilter.all)) {
      return events;
    }

    return events.where((event) {
      if (state.activeFilters.contains(EventFilter.job) &&
          event.type == EventType.job) {
        return true;
      }
      if (state.activeFilters.contains(EventFilter.private) &&
          event.type == EventType.private) {
        return true;
      }
      if (state.activeFilters.contains(EventFilter.availability) &&
          event.type == EventType.availability) {
        return true;
      }
      return false;
    }).toList();
  }

  // Validate time slot for conflicts
  Future<ConflictResult> validateSlot(
    CalendarEvent newEvent, {
    String? excludeEventId,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Get conflicting events
      final conflictingEvents = await _repo.getConflictingEvents(
        _ownerUid,
        newEvent.start,
        newEvent.end,
        excludeEventId: excludeEventId,
      );

      if (conflictingEvents.isEmpty) {
        return const ConflictResult(hasConflict: false, isHard: false);
      }

      // Check for hard conflicts (time overlaps)
      for (final existing in conflictingEvents) {
        // Direct time overlap
        if (newEvent.start.isBefore(existing.end) &&
            newEvent.end.isAfter(existing.start)) {
          return ConflictResult(
            hasConflict: true,
            isHard: true,
            message: 'Direct time overlap with existing event',
            code: CalendarConflictCode.directOverlap,
            conflictingEvent: existing,
          );
        }

        // Check buffer and travel time conflicts
        final conflictResult = await _checkBufferAndTravelConflicts(
          newEvent,
          existing,
        );
        if (conflictResult.hasConflict && conflictResult.isHard) {
          return conflictResult;
        }
      }

      // Check for soft conflicts (tight scheduling)
      final softConflict = await _checkSoftConflicts(
        newEvent,
        conflictingEvents,
      );
      return softConflict;
    } catch (e) {
      return ConflictResult(
        hasConflict: true,
        isHard: true,
        message: 'Error validating time slot: $e',
        code: CalendarConflictCode.validationError,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Check buffer and travel time conflicts
  Future<ConflictResult> _checkBufferAndTravelConflicts(
    CalendarEvent newEvent,
    CalendarEvent existing,
  ) async {
    // Calculate required time between events
    int requiredGap = 0;

    // Determine which event comes first
    CalendarEvent? earlierEvent;
    CalendarEvent? laterEvent;

    if (existing.end.isBefore(newEvent.start) ||
        existing.end.isAtSameMomentAs(newEvent.start)) {
      earlierEvent = existing;
      laterEvent = newEvent;
    } else if (newEvent.end.isBefore(existing.start) ||
        newEvent.end.isAtSameMomentAs(existing.start)) {
      earlierEvent = newEvent;
      laterEvent = existing;
    } else {
      // Events overlap, already handled above
      return const ConflictResult(hasConflict: false, isHard: false);
    }

    // Calculate required gap: bufferAfter(earlier) + travelTime + bufferBefore(later)
    requiredGap += earlierEvent.bufferAfter;
    requiredGap += laterEvent.bufferBefore;

    // Add travel time if both events have locations
    if (earlierEvent.location != null && laterEvent.location != null) {
      final etaResult = await _repo.computeEta(
        earlierEvent.location!,
        laterEvent.location!,
      );
      if (etaResult != null) {
        requiredGap += etaResult.minutes;
      } else {
        // If ETA calculation fails, assume 15 minutes travel time as fallback
        requiredGap += 15;
      }
    }

    // Calculate actual gap
    final actualGap = laterEvent.start.difference(earlierEvent.end).inMinutes;

    if (actualGap < requiredGap) {
      final missingMinutes = requiredGap - actualGap;
      return ConflictResult(
        hasConflict: true,
        isHard: true,
        message:
            'Insufficient time between events. Need $requiredGap minutes, have $actualGap minutes.',
        code: CalendarConflictCode.insufficientGap,
        conflictingEvent: existing,
        missingMinutes: missingMinutes,
        actualGapMinutes: actualGap,
        requiredGapMinutes: requiredGap,
      );
    }

    return const ConflictResult(hasConflict: false, isHard: false);
  }

  // Check for soft conflicts (warnings)
  Future<ConflictResult> _checkSoftConflicts(
    CalendarEvent newEvent,
    List<CalendarEvent> conflictingEvents,
  ) async {
    const warningThreshold = 10; // minutes

    for (final existing in conflictingEvents) {
      int actualGap = 0;

      if (existing.end.isBefore(newEvent.start)) {
        actualGap = newEvent.start.difference(existing.end).inMinutes;
      } else if (newEvent.end.isBefore(existing.start)) {
        actualGap = existing.start.difference(newEvent.end).inMinutes;
      } else {
        continue; // Events overlap, should be caught by hard conflict check
      }

      if (actualGap <= warningThreshold) {
        return ConflictResult(
          hasConflict: true,
          isHard: false,
          message:
              'Events are scheduled very close together ($actualGap minutes gap)',
          code: CalendarConflictCode.softGap,
          conflictingEvent: existing,
          actualGapMinutes: actualGap,
        );
      }
    }

    return const ConflictResult(hasConflict: false, isHard: false);
  }

  // Create event with validation
  Future<CalendarEvent?> createEvent(CalendarEvent event) async {
    final validation = await validateSlot(event);

    if (validation.hasConflict) {
      throw CalendarConflictException(validation);
    }

    return await _repo.createEvent(event);
  }

  // Update event with validation
  Future<CalendarEvent?> updateEvent(CalendarEvent event) async {
    final validation = await validateSlot(event, excludeEventId: event.id);

    if (validation.hasConflict) {
      throw CalendarConflictException(validation);
    }

    return await _repo.updateEvent(event);
  }

  // Delete event
  Future<bool> deleteEvent(String eventId) async {
    return await _repo.deleteEvent(eventId);
  }

  // Get ICS export URL
  Future<String?> getIcsExportUrl() async {
    final token = await _repo.getOrCreateIcsToken();
    if (token != null) {
      return _repo.getIcsUrl(token);
    }
    return null;
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Riverpod providers
final calendarControllerProvider =
    StateNotifierProvider.family<CalendarController, CalendarState, String>((
      ref,
      ownerUid,
    ) {
      final repo = ref.watch(calendarRepositoryProvider);
      return CalendarController(repo, ownerUid);
    });

// Provider for current date range events
final currentRangeEventsProvider =
    StreamProvider.family<List<CalendarEvent>, String>((ref, ownerUid) {
      final controller = ref.watch(
        calendarControllerProvider(ownerUid).notifier,
      );
      final range = controller.getDateRange();

      final eventsProvider = ref.watch(
        calendarEventsProvider((
          ownerUid: ownerUid,
          from: range.from,
          to: range.to,
        )),
      );

      return eventsProvider.when(
        data: (events) {
          final filteredEvents = controller.filterEvents(events);
          return Stream.value(filteredEvents);
        },
        loading: () => Stream.value(<CalendarEvent>[]),
        error: (error, stack) => Stream.error(error, stack),
      );
    });

// Provider for events on selected date
final selectedDateEventsProvider = Provider.family<List<CalendarEvent>, String>(
  (ref, ownerUid) {
    final state = ref.watch(calendarControllerProvider(ownerUid));
    final eventsAsync = ref.watch(currentRangeEventsProvider(ownerUid));

    return eventsAsync.when(
      data: (events) {
        final selectedDate = state.selectedDate;
        return events.where((event) {
          return event.start.year == selectedDate.year &&
              event.start.month == selectedDate.month &&
              event.start.day == selectedDate.day;
        }).toList();
      },
      loading: () => [],
      error: (error, stack) => [],
    );
  },
);
