import 'package:cloud_firestore/cloud_firestore.dart';

/// Base application exception class
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  const factory AppException.notAuthenticated({
    String message,
  }) = NotAuthenticatedException;

  const factory AppException.forbidden({
    String message,
  }) = ForbiddenException;

  const factory AppException.notFound({
    String message,
    String? resource,
  }) = NotFoundException;

  const factory AppException.validation({
    String message,
    List<String>? details,
  }) = ValidationException;

  const factory AppException.network({
    String message,
    String? code,
  }) = NetworkException;

  const factory AppException.firestore({
    String message,
    String? code,
  }) = FirestoreException;

  const factory AppException.unknown({
    String message,
  }) = UnknownException;

  /// Create AppException from FirebaseException
  factory AppException.fromFirestore(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const AppException.forbidden(
          message: 'Keine Berechtigung für diese Aktion',
        );
      case 'not-found':
        return const AppException.notFound(
          message: 'Dokument nicht gefunden',
        );
      case 'unauthenticated':
        return const AppException.notAuthenticated(
          message: 'Benutzer ist nicht authentifiziert',
        );
      case 'unavailable':
        return const AppException.network(
          message: 'Service nicht verfügbar',
        );
      default:
        return AppException.firestore(
          message: e.message ?? 'Firestore-Fehler',
          code: e.code,
        );
    }
  }

  @override
  String toString() => 'AppException: $message';
}

class NotAuthenticatedException extends AppException {
  const NotAuthenticatedException({
    String message = 'Benutzer ist nicht authentifiziert',
  }) : super(message);
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    String message = 'Zugriff verweigert',
  }) : super(message);
}

class NotFoundException extends AppException {
  final String? resource;

  const NotFoundException({
    String message = 'Ressource nicht gefunden',
    this.resource,
  }) : super(message);
}

class ValidationException extends AppException {
  final List<String>? details;

  const ValidationException({
    String message = 'Validierungsfehler',
    this.details,
  }) : super(message);
}

class NetworkException extends AppException {
  final String? code;

  const NetworkException({
    String message = 'Netzwerkfehler',
    this.code,
  }) : super(message);
}

class FirestoreException extends AppException {
  final String? code;

  const FirestoreException({
    String message = 'Firestore-Fehler',
    this.code,
  }) : super(message);
}

class UnknownException extends AppException {
  const UnknownException({
    String message = 'Unbekannter Fehler',
  }) : super(message);
}
