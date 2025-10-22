import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/models/calendar_event.dart';
import '../logic/calendar_controller.dart';
import 'event_editor_sheet.dart';
import '../../auth/logic/auth_controller.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  String? _ownerUid;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final uid = userAsync.asData?.value?.uid;
    _ownerUid = uid;
    final eventsAsync = uid != null
        ? ref.watch(currentRangeEventsProvider(uid))
        : const AsyncValue<List<CalendarEvent>>.loading();

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('calendar.title'.tr()),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'week':
                  setState(() {
                    _calendarFormat = CalendarFormat.week;
                  });
                  break;
                case 'month':
                  setState(() {
                    _calendarFormat = CalendarFormat.month;
                  });
                  break;
                case 'export':
                  _exportCalendar();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'week',
                child: Text('calendar.weekView'.tr()),
              ),
              PopupMenuItem(
                value: 'month',
                child: Text('calendar.monthView'.tr()),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'export',
                child: Text('calendar.export'.tr()),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (uid == null) ...[
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ] else ...[
            TableCalendar<CalendarEvent>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return eventsAsync.when(
                  data: (events) => events
                      .where((event) => isSameDay(event.start, day))
                      .toList(),
                  loading: () => [],
                  error: (error, stack) => [],
                );
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.red),
                holidayTextStyle: const TextStyle(color: Colors.red),
                todayDecoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                // The events will be automatically reloaded by the provider
                // when the focused date changes
              },
            ),
          ],
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay != null
                ? _buildEventsList(_selectedDay!)
                : Center(child: Text('calendar.selectDay'.tr())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventEditor(context),
        child: const Icon(Icons.add),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.calendar, child: scaffold);
  }

  Widget _buildEventsList(DateTime day) {
    if (_ownerUid == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final eventsAsync = ref.watch(currentRangeEventsProvider(_ownerUid!));

    return eventsAsync.when(
      data: (events) {
        final dayEvents = events
            .where((event) => isSameDay(event.start, day))
            .toList();

        dayEvents.sort((a, b) => a.start.compareTo(b.start));

        if (dayEvents.isEmpty) {
          return Center(child: Text('calendar.noEventsToday'.tr()));
        }

        final bottomInset = MediaQuery.of(context).viewPadding.bottom;

        return ListView.builder(
          padding: EdgeInsets.only(bottom: bottomInset + 16),
          itemCount: dayEvents.length,
          itemBuilder: (context, index) {
            final event = dayEvents[index];
            return _buildEventCard(event);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'calendar.loadError'.tr(namedArgs: {'error': error.toString()}),
        ),
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(event.start);
    final endTime = timeFormat.format(event.end);

    Color cardColor;
    IconData iconData;

    switch (event.type) {
      case EventType.job:
        cardColor = Colors.blue.shade100;
        iconData = Icons.work;
        break;
      case EventType.private:
        cardColor = Colors.green.shade100;
        iconData = Icons.event;
        break;
      case EventType.availability:
        cardColor = Colors.orange.shade100;
        iconData = Icons.schedule;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: cardColor,
      child: ListTile(
        leading: Icon(iconData),
        title: Text(
          _getDefaultTitle(event),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$startTime - $endTime'),
            if (event.description != null && event.description!.isNotEmpty)
              Text(
                event.description!,
                style: TextStyle(color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (event.location != null)
              Text(
                event.location!.address,
                style: TextStyle(color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEventEditor(context, event: event);
                break;
              case 'delete':
                _deleteEvent(event);
                break;
            }
          },
          itemBuilder: (context) => [
            if (event.type != EventType.job) ...[
              PopupMenuItem(value: 'edit', child: Text('calendar.edit'.tr())),
              PopupMenuItem(
                value: 'delete',
                child: Text('calendar.delete'.tr()),
              ),
            ] else ...[
              PopupMenuItem(
                value: 'edit',
                child: Text('calendar.eventDetails'.tr()),
              ),
            ],
          ],
        ),
        onTap: () => _showEventEditor(context, event: event),
      ),
    );
  }

  String _getDefaultTitle(CalendarEvent event) {
    // Use the event's title if available, otherwise fall back to type-based default
    if (event.title.isNotEmpty) {
      return event.title;
    }

    switch (event.type) {
      case EventType.job:
        return 'calendar.eventTypes.job'.tr();
      case EventType.private:
        return 'calendar.eventTypes.private'.tr();
      case EventType.availability:
        return 'calendar.eventTypes.availability'.tr();
    }
  }

  void _showEventEditor(BuildContext context, {CalendarEvent? event}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EventEditorSheet(
        event: event,
        initialDate: _selectedDay ?? DateTime.now(),
      ),
    );
  }

  void _deleteEvent(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('calendar.deleteConfirmTitle'.tr()),
        content: Text('calendar.deleteConfirmMessage'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('calendar.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              final uid = _ownerUid;
              if (uid == null) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('calendar.deleteNotSignedIn'.tr())),
                );
                return;
              }
              ref
                  .read(calendarControllerProvider(uid).notifier)
                  .deleteEvent(event.id!);
              Navigator.of(context).pop();
            },
            child: Text('calendar.delete'.tr()),
          ),
        ],
      ),
    );
  }

  void _exportCalendar() async {
    final uid = _ownerUid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('calendar.signInToExport'.tr())));
      return;
    }
    final calendarController = ref.read(
      calendarControllerProvider(uid).notifier,
    );

    try {
      final url = await calendarController.getIcsExportUrl();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('calendar.exportTitle'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('calendar.exportDescription'.tr()),
              const SizedBox(height: 16),
              SelectableText(
                url ?? '',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('calendar.close'.tr()),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'calendar.exportError'.tr(namedArgs: {'error': e.toString()}),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
