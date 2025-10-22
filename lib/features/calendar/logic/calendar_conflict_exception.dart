import '../../../core/models/calendar_event.dart';

class CalendarConflictException implements Exception {
  final ConflictResult conflict;

  const CalendarConflictException(this.conflict);

  @override
  String toString() {
    final code = conflict.code;
    final message = conflict.message;
    return 'CalendarConflictException(code: $code, message: $message)';
  }
}
