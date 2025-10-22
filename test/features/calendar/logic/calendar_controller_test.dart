import 'package:brivida_app/core/models/calendar_event.dart';
import 'package:brivida_app/features/calendar/data/calendar_repo.dart';
import 'package:brivida_app/features/calendar/logic/calendar_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCalendarRepository extends Mock implements CalendarRepository {}

CalendarEvent _event({
  required DateTime start,
  required DateTime end,
  int bufferBefore = 15,
  int bufferAfter = 15,
  CalendarLocation? location,
  String? id,
}) {
  return CalendarEvent(
    id: id,
    ownerUid: 'pro-123',
    type: EventType.job,
    title: 'Test Event',
    description: 'Generated for tests',
    start: start,
    end: end,
    bufferBefore: bufferBefore,
    bufferAfter: bufferAfter,
    visibility: EventVisibility.busy,
    jobId: 'job-1',
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
    location: location,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CalendarController.validateSlot', () {
    late MockCalendarRepository repo;
    late CalendarController controller;
    const ownerUid = 'pro-123';

    setUp(() {
      repo = MockCalendarRepository();
      controller = CalendarController(repo, ownerUid);
    });

    test(
      'returns direct overlap conflict when events overlap in time',
      () async {
        final existing = _event(
          id: 'existing',
          start: DateTime(2025, 1, 1, 10, 0),
          end: DateTime(2025, 1, 1, 11, 0),
        );
        final newEvent = _event(
          id: 'new',
          start: DateTime(2025, 1, 1, 10, 30),
          end: DateTime(2025, 1, 1, 11, 30),
        );

        when(
          () => repo.getConflictingEvents(
            ownerUid,
            newEvent.start,
            newEvent.end,
            excludeEventId: null,
          ),
        ).thenAnswer((_) async => [existing]);

        final result = await controller.validateSlot(newEvent);

        expect(result.hasConflict, isTrue);
        expect(result.isHard, isTrue);
        expect(result.code, CalendarConflictCode.directOverlap);
        expect(result.conflictingEvent?.id, equals(existing.id));
        expect(controller.state.isLoading, isFalse);
      },
    );

    test(
      'detects insufficient gap when buffers and ETA exceed available time',
      () async {
        final existing = _event(
          id: 'existing',
          start: DateTime(2025, 1, 1, 9, 0),
          end: DateTime(2025, 1, 1, 10, 0),
          bufferAfter: 20,
          location: const CalendarLocation(
            lat: 52.52,
            lng: 13.405,
            address: 'Existing address',
          ),
        );
        final newEvent = _event(
          id: 'new',
          start: DateTime(2025, 1, 1, 10, 20),
          end: DateTime(2025, 1, 1, 11, 0),
          bufferBefore: 20,
          location: const CalendarLocation(
            lat: 48.8566,
            lng: 2.3522,
            address: 'New address',
          ),
        );

        when(
          () => repo.getConflictingEvents(
            ownerUid,
            newEvent.start,
            newEvent.end,
            excludeEventId: null,
          ),
        ).thenAnswer((_) async => [existing]);

        when(
          () => repo.computeEta(existing.location!, newEvent.location!),
        ).thenAnswer((_) async => const EtaResult(minutes: 25));

        final result = await controller.validateSlot(newEvent);

        expect(result.hasConflict, isTrue);
        expect(result.isHard, isTrue);
        expect(result.code, CalendarConflictCode.insufficientGap);
        expect(result.missingMinutes, 45);
        expect(result.actualGapMinutes, 20);
        expect(result.requiredGapMinutes, 65);
        expect(result.conflictingEvent?.id, equals(existing.id));
        expect(controller.state.isLoading, isFalse);

        verify(
          () => repo.computeEta(existing.location!, newEvent.location!),
        ).called(1);
      },
    );

    test('flags soft conflict when gap is tight but not blocking', () async {
      final existing = _event(
        id: 'existing',
        start: DateTime(2025, 1, 2, 8, 0),
        end: DateTime(2025, 1, 2, 9, 0),
        bufferAfter: 0,
      );
      final newEvent = _event(
        id: 'new',
        start: DateTime(2025, 1, 2, 9, 5),
        end: DateTime(2025, 1, 2, 10, 0),
        bufferBefore: 0,
      );

      when(
        () => repo.getConflictingEvents(
          ownerUid,
          newEvent.start,
          newEvent.end,
          excludeEventId: null,
        ),
      ).thenAnswer((_) async => [existing]);

      final result = await controller.validateSlot(newEvent);

      expect(result.hasConflict, isTrue);
      expect(result.isHard, isFalse);
      expect(result.code, CalendarConflictCode.softGap);
      expect(result.actualGapMinutes, 5);
      expect(result.conflictingEvent?.id, equals(existing.id));
      expect(controller.state.isLoading, isFalse);
    });

    test(
      'returns no conflict when repository finds no overlapping events',
      () async {
        final newEvent = _event(
          id: 'new',
          start: DateTime(2025, 1, 3, 14, 0),
          end: DateTime(2025, 1, 3, 15, 0),
        );

        when(
          () => repo.getConflictingEvents(
            ownerUid,
            newEvent.start,
            newEvent.end,
            excludeEventId: null,
          ),
        ).thenAnswer((_) async => []);

        final result = await controller.validateSlot(newEvent);

        expect(result.hasConflict, isFalse);
        expect(result.isHard, isFalse);
        expect(result.code, CalendarConflictCode.unknown);
        expect(result.conflictingEvent, isNull);
        expect(controller.state.isLoading, isFalse);
      },
    );
  });
}
