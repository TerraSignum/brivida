import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ErrorHandler {
  /// Extract user-friendly error message from various error types
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getFirebaseAuthErrorMessage(error);
    }

    if (error is FirebaseFunctionsException) {
      return _getFirebaseFunctionsErrorMessage(error);
    }

    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }

    return error.toString();
  }

  static String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  static String _getFirebaseFunctionsErrorMessage(
      FirebaseFunctionsException e) {
    switch (e.code) {
      case 'unauthenticated':
        return 'You must be signed in to perform this action.';
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'The resource already exists.';
      case 'resource-exhausted':
        return 'Resource quota exceeded. Please try again later.';
      case 'failed-precondition':
        return 'The operation failed due to a precondition.';
      case 'aborted':
        return 'The operation was aborted.';
      case 'out-of-range':
        return 'The operation was attempted past the valid range.';
      case 'unimplemented':
        return 'This operation is not implemented.';
      case 'internal':
        return 'An internal error occurred. Please try again.';
      case 'unavailable':
        return 'The service is currently unavailable.';
      case 'data-loss':
        return 'Data loss occurred.';
      case 'invalid-argument':
        return 'Invalid arguments provided.';
      case 'deadline-exceeded':
        return 'The operation timed out.';
      case 'cancelled':
        return 'The operation was cancelled.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }
}
