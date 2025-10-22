import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/calendar_event.dart';
import '../../../core/config/environment.dart';
import '../../../core/utils/debug_logger.dart';

class CalendarRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CalendarRepository(this._firestore, this._functions);

  // Create a new calendar event
  Future<CalendarEvent?> createEvent(CalendarEvent event) async {
    try {
      final now = DateTime.now();
      final eventData = event
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef =
          await _firestore.collection('calendarEvents').add(eventData);
      final doc = await docRef.get();
      return CalendarEvent.fromFirestore(doc);
    } catch (e) {
      DebugLogger.error('Error creating calendar event: $e');
      return null;
    }
  }

  // Update an existing calendar event
  Future<CalendarEvent?> updateEvent(CalendarEvent event) async {
    try {
      if (event.id == null) return null;

      final now = DateTime.now();
      final eventData = event.copyWith(updatedAt: now).toFirestore();

      await _firestore
          .collection('calendarEvents')
          .doc(event.id)
          .update(eventData);

      final doc =
          await _firestore.collection('calendarEvents').doc(event.id).get();
      return CalendarEvent.fromFirestore(doc);
    } catch (e) {
      DebugLogger.error('Error updating calendar event: $e');
      return null;
    }
  }

  // Delete a calendar event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('calendarEvents').doc(eventId).delete();
      return true;
    } catch (e) {
      DebugLogger.error('Error deleting calendar event: $e');
      return false;
    }
  }

  // Get events in a date range for a specific user
  Future<List<CalendarEvent>> listEventsRange(
    String ownerUid,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final query = await _firestore
          .collection('calendarEvents')
          .where('ownerUid', isEqualTo: ownerUid)
          .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where('start', isLessThan: Timestamp.fromDate(to))
          .orderBy('start')
          .get();

      return query.docs.map((doc) => CalendarEvent.fromFirestore(doc)).toList();
    } catch (e) {
      DebugLogger.log('Error listing events: $e');
      return [];
    }
  }

  // Stream events for real-time updates
  Stream<List<CalendarEvent>> streamEventsRange(
    String ownerUid,
    DateTime from,
    DateTime to,
  ) {
    return _firestore
        .collection('calendarEvents')
        .where('ownerUid', isEqualTo: ownerUid)
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('start', isLessThan: Timestamp.fromDate(to))
        .orderBy('start')
        .snapshots()
        .map((snapshot) {
      final events = snapshot.docs
          .map((doc) {
            try {
              final eventData = {...doc.data(), 'id': doc.id};
              final event = CalendarEvent.fromFirestore(doc);

              // In development mode, include mock data for relevant users
              if (Environment.isDevelopment) {
                // Include mock events if the owner matches any mock pro/customer
                final mockUsers = [
                  'mock_pro_001',
                  'mock_pro_002',
                  'mock_pro_003',
                  'mock_customer_001',
                  'mock_customer_002',
                  'mock_customer_003'
                ];

                if (eventData['isMockData'] == true &&
                    (mockUsers.contains(ownerUid) ||
                        eventData['customerUid'] == ownerUid ||
                        eventData['proUid'] == ownerUid)) {
                  DebugLogger.debug(
                      '🎭 Development mode: including mock calendar event',
                      {'eventId': event.id, 'title': event.title});
                  return event;
                }
              }

              // In production, exclude mock data
              if (eventData['isMockData'] == true) {
                DebugLogger.debug(
                    '🚫 Excluding mock calendar event in production',
                    {'eventId': event.id});
                return null;
              }

              return event;
            } catch (e) {
              DebugLogger.error('❌ Error parsing calendar event document', e);
              return null;
            }
          })
          .whereType<CalendarEvent>()
          .toList();

      return events;
    });
  }

  // Compute ETA between two locations using OSRM
  Future<EtaResult?> computeEta(
    CalendarLocation origin,
    CalendarLocation destination,
  ) async {
    try {
      final callable = _functions.httpsCallable('eta');
      final result = await callable.call({
        'origin': origin.toJson(),
        'destination': destination.toJson(),
      });

      return EtaResult.fromJson(result.data as Map<String, dynamic>);
    } catch (e) {
      DebugLogger.log('Error computing ETA: $e');
      return null;
    }
  }

  // Get or create ICS token for calendar export
  Future<String?> getOrCreateIcsToken() async {
    try {
      final callable = _functions.httpsCallable('ensureIcsToken');
      final result = await callable.call();
      return result.data['token'] as String?;
    } catch (e) {
      DebugLogger.log('Error getting ICS token: $e');
      return null;
    }
  }

  // Get ICS export URL
  String getIcsUrl(String token) {
    final baseUrl = Environment.apiBaseUrl;
    return '$baseUrl/calendarIcs?token=$token';
  }

  // Get events by type for filtering
  Future<List<CalendarEvent>> getEventsByType(
    String ownerUid,
    EventType type,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final query = await _firestore
          .collection('calendarEvents')
          .where('ownerUid', isEqualTo: ownerUid)
          .where('type', isEqualTo: type.name)
          .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where('start', isLessThan: Timestamp.fromDate(to))
          .orderBy('start')
          .get();

      return query.docs.map((doc) => CalendarEvent.fromFirestore(doc)).toList();
    } catch (e) {
      DebugLogger.log('Error getting events by type: $e');
      return [];
    }
  }

  // Check for conflicts in a time slot
  Future<List<CalendarEvent>> getConflictingEvents(
    String ownerUid,
    DateTime start,
    DateTime end, {
    String? excludeEventId,
  }) async {
    try {
      final query = await _firestore
          .collection('calendarEvents')
          .where('ownerUid', isEqualTo: ownerUid)
          .where('start', isLessThan: Timestamp.fromDate(end))
          .get();

      final conflictingEvents = <CalendarEvent>[];

      for (final doc in query.docs) {
        final event = CalendarEvent.fromFirestore(doc);

        // Skip the event being edited
        if (excludeEventId != null && event.id == excludeEventId) continue;

        // Check for time overlap: event.end > start && event.start < end
        if (event.end.isAfter(start) && event.start.isBefore(end)) {
          conflictingEvents.add(event);
        }
      }

      return conflictingEvents;
    } catch (e) {
      DebugLogger.log('Error checking conflicts: $e');
      return [];
    }
  }
}

// Riverpod providers
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(
    FirebaseFirestore.instance,
    FirebaseFunctions.instance,
  );
});

// Provider for events in current date range
final calendarEventsProvider = StreamProvider.family<List<CalendarEvent>,
    ({String ownerUid, DateTime from, DateTime to})>((ref, params) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.streamEventsRange(params.ownerUid, params.from, params.to);
});

// Provider for events by type
final eventsByTypeProvider = FutureProvider.family<
    List<CalendarEvent>,
    ({
      String ownerUid,
      EventType type,
      DateTime from,
      DateTime to
    })>((ref, params) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.getEventsByType(
      params.ownerUid, params.type, params.from, params.to);
});
