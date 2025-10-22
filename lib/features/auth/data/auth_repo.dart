import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/debug_logger.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  // Get current user
  User? get currentUser {
    final user = _auth.currentUser;
    DebugLogger.debug('🔍 Getting current user', {
      'hasUser': user != null,
      'uid': user?.uid,
      'email': user?.email,
      'isEmailVerified': user?.emailVerified
    });
    return user;
  }

  // Stream of auth state changes
  Stream<User?> get authStateChanges {
    DebugLogger.debug('📡 Creating auth state changes stream');
    return _auth.authStateChanges();
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    DebugLogger.enter('signUpWithEmailAndPassword', {
      'email': email,
      'passwordLength': password.length,
      'timestamp': DateTime.now().toIso8601String()
    });

    DebugLogger.startTimer('signup_duration');

    try {
      DebugLogger.debug('🔐 Starting Firebase Auth sign up process',
          {'email': email, 'authInstance': _auth.app.name});

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DebugLogger.debug('✅ User account created successfully', {
        'uid': result.user?.uid,
        'email': result.user?.email,
        'isEmailVerified': result.user?.emailVerified,
        'creationTime': result.user?.metadata.creationTime?.toIso8601String(),
        'isNewUser': result.additionalUserInfo?.isNewUser
      });

      // Send email verification
      DebugLogger.debug('📧 Sending email verification');
      await result.user?.sendEmailVerification();
      DebugLogger.debug('✅ Email verification sent successfully');

      final duration =
          DebugLogger.stopTimer('signup_duration', 'complete sign up process');
      DebugLogger.debug('⏱️ Complete sign up process completed', {
        'duration': duration?.inMilliseconds,
        'uid': result.user?.uid,
        'emailVerificationSent': true
      });

      DebugLogger.exit('signUpWithEmailAndPassword',
          {'success': true, 'uid': result.user?.uid});

      return result;
    } on FirebaseAuthException catch (e) {
      final duration =
          DebugLogger.stopTimer('signup_duration', 'failed sign up process');
      DebugLogger.debug('❌ Sign up failed', {
        'duration': duration?.inMilliseconds,
        'errorCode': e.code,
        'errorMessage': e.message,
        'email': email
      });

      DebugLogger.error('Firebase Auth sign up error', e, null);

      DebugLogger.exit('signUpWithEmailAndPassword',
          {'success': false, 'errorCode': e.code});

      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    DebugLogger.enter('signInWithEmailAndPassword', {
      'email': email,
      'passwordLength': password.length,
      'timestamp': DateTime.now().toIso8601String()
    });

    DebugLogger.startTimer('signin_duration');

    try {
      DebugLogger.debug('🔐 Starting Firebase Auth sign in process',
          {'email': email, 'authInstance': _auth.app.name});

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final duration =
          DebugLogger.stopTimer('signin_duration', 'sign in process');
      DebugLogger.debug('✅ Sign in successful', {
        'duration': duration?.inMilliseconds,
        'uid': result.user?.uid,
        'email': result.user?.email,
        'isEmailVerified': result.user?.emailVerified,
        'lastSignInTime':
            result.user?.metadata.lastSignInTime?.toIso8601String(),
        'creationTime': result.user?.metadata.creationTime?.toIso8601String()
      });

      DebugLogger.exit('signInWithEmailAndPassword', {
        'success': true,
        'uid': result.user?.uid,
        'isEmailVerified': result.user?.emailVerified
      });

      return result;
    } on FirebaseAuthException catch (e) {
      final duration =
          DebugLogger.stopTimer('signin_duration', 'failed sign in process');
      DebugLogger.debug('❌ Sign in failed', {
        'duration': duration?.inMilliseconds,
        'errorCode': e.code,
        'errorMessage': e.message,
        'email': email
      });

      DebugLogger.error('Firebase Auth sign in error', e, null);

      DebugLogger.exit('signInWithEmailAndPassword',
          {'success': false, 'errorCode': e.code});

      throw _handleAuthException(e);
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    DebugLogger.enter('sendEmailVerification');

    DebugLogger.startTimer('email_verification_duration');

    try {
      final user = _auth.currentUser;

      DebugLogger.debug('📧 Checking current user for email verification', {
        'hasUser': user != null,
        'uid': user?.uid,
        'email': user?.email,
        'isEmailVerified': user?.emailVerified
      });

      if (user != null && !user.emailVerified) {
        DebugLogger.debug('📨 Sending email verification to user');
        await user.sendEmailVerification();

        final duration = DebugLogger.stopTimer(
            'email_verification_duration', 'email verification sent');
        DebugLogger.debug('✅ Email verification sent successfully', {
          'duration': duration?.inMilliseconds,
          'email': user.email,
          'uid': user.uid
        });

        DebugLogger.exit('sendEmailVerification', {'success': true});
      } else {
        final duration = DebugLogger.stopTimer(
            'email_verification_duration', 'email verification skipped');
        DebugLogger.debug('⚠️ Email verification skipped', {
          'duration': duration?.inMilliseconds,
          'reason': user == null ? 'no_user' : 'already_verified',
          'isEmailVerified': user?.emailVerified
        });

        DebugLogger.exit(
            'sendEmailVerification', {'success': false, 'reason': 'skipped'});
      }
    } catch (e) {
      final duration = DebugLogger.stopTimer(
          'email_verification_duration', 'email verification failed');
      DebugLogger.debug('❌ Email verification failed',
          {'duration': duration?.inMilliseconds, 'error': e.toString()});

      DebugLogger.error('Email verification error', e, null);

      DebugLogger.exit(
          'sendEmailVerification', {'success': false, 'error': e.toString()});
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    DebugLogger.enter('signOut');

    DebugLogger.startTimer('signout_duration');

    try {
      final user = _auth.currentUser;

      DebugLogger.debug('🚪 Starting sign out process',
          {'hasUser': user != null, 'uid': user?.uid, 'email': user?.email});

      await _auth.signOut();

      final duration =
          DebugLogger.stopTimer('signout_duration', 'sign out process');
      DebugLogger.debug('✅ Sign out successful',
          {'duration': duration?.inMilliseconds, 'previousUid': user?.uid});

      DebugLogger.exit('signOut', {'success': true});
    } catch (e) {
      final duration =
          DebugLogger.stopTimer('signout_duration', 'failed sign out process');
      DebugLogger.debug('❌ Sign out failed',
          {'duration': duration?.inMilliseconds, 'error': e.toString()});

      DebugLogger.error('Sign out error', e, null);

      DebugLogger.exit('signOut', {'success': false, 'error': e.toString()});
      rethrow;
    }
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    DebugLogger.enter('_handleAuthException', {
      'errorCode': e.code,
      'errorMessage': e.message,
      'credential': e.credential?.toString()
    });

    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      default:
        message = 'An error occurred: ${e.message}';
        break;
    }

    DebugLogger.debug('🔄 Auth exception mapped to user message', {
      'originalCode': e.code,
      'originalMessage': e.message,
      'userMessage': message
    });

    DebugLogger.exit('_handleAuthException', {'userMessage': message});

    return message;
  }
}
