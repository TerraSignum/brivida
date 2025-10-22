import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/config/admin_whitelist.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/services/crashlytics_service.dart';
import '../../../core/services/app_initialization_service.dart';
import '../data/auth_repo.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../legal/data/legal_repo.dart';
import '../../../core/models/legal.dart';

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  try {
    DebugLogger.debug('🔐 Creating AuthRepository provider');
    final repo = AuthRepository();
    DebugLogger.debug('✅ AuthRepository provider created successfully');
    return repo;
  } catch (e, stackTrace) {
    DebugLogger.error('❌ Error creating AuthRepository', e, stackTrace);
    rethrow;
  }
});

// Current user provider
final authStateProvider = StreamProvider<User?>((ref) {
  try {
    DebugLogger.debug('🔐 Creating auth state provider');
    final authRepo = ref.watch(authRepositoryProvider);

    // Listen to auth state changes with detailed logging
    return authRepo.authStateChanges.map((user) {
      if (user != null) {
        DebugLogger.stateChange('AuthState', 'null', 'authenticated', {
          'uid': user.uid,
          'email': user.email,
          'isEmailVerified': user.emailVerified,
          'isAnonymous': user.isAnonymous,
        });
      } else {
        DebugLogger.stateChange('AuthState', 'authenticated', 'null');
      }
      return user;
    });
  } catch (e, stackTrace) {
    DebugLogger.error('❌ Error creating auth state provider', e, stackTrace);
    rethrow;
  }
});

// Auth controller for business logic
class AuthController extends StateNotifier<AsyncValue<void>>
    with CrashlyticsErrorHandler {
  AuthController(this._ref, this._authRepo)
    : super(const AsyncValue.data(null)) {
    DebugLogger.lifecycle('AuthController', 'constructor');
  }

  final Ref _ref;
  final AuthRepository _authRepo;

  Future<void> signUp({
    required String email,
    required String password,
    required SupportedLanguage consentLanguage,
  }) async {
    DebugLogger.enter('AuthController.signUp', {
      'email': email,
      'passwordLength': password.length,
    });
    DebugLogger.startTimer('signUp');

    try {
      DebugLogger.debug('🔐 Starting sign up process');
      state = const AsyncValue.loading();
      DebugLogger.stateChange('AuthController', 'idle', 'loading');

      await _authRepo.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _recordInitialLegalConsent(consentLanguage);

      DebugLogger.debug('✅ Sign up successful');
      state = const AsyncValue.data(null);
      DebugLogger.stateChange('AuthController', 'loading', 'success');
      DebugLogger.performance('signUp', DebugLogger.stopTimer('signUp')!);
      DebugLogger.exit('AuthController.signUp', 'success');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Sign up failed', e, stackTrace);

      // Report to Crashlytics
      await handleError(
        e,
        stackTrace,
        operation: 'signUp',
        context: {'email': email},
      );

      state = AsyncValue.error(e, stackTrace);
      DebugLogger.stateChange('AuthController', 'loading', 'error');
      DebugLogger.stopTimer('signUp');
      DebugLogger.exit('AuthController.signUp', 'error');
    }
  }

  Future<void> _recordInitialLegalConsent(
    SupportedLanguage consentLanguage,
  ) async {
    DebugLogger.enter('AuthController._recordInitialLegalConsent', {
      'language': consentLanguage.name,
    });

    final legalRepo = _ref.read(legalRepositoryProvider);
    final versions = await legalRepo.getCurrentVersions();

    final tosVersion = versions[LegalDocType.tos] ?? 'v1.0';
    final privacyVersion = versions[LegalDocType.privacy] ?? 'v1.0';

    await legalRepo.saveConsentSecure(
      tosVersion: tosVersion,
      privacyVersion: privacyVersion,
      consentedLang: consentLanguage,
    );

    DebugLogger.exit('AuthController._recordInitialLegalConsent', 'success');
  }

  Future<bool> signIn({required String email, required String password}) async {
    DebugLogger.enter('AuthController.signIn', {
      'email': email,
      'passwordLength': password.length,
    });
    DebugLogger.startTimer('signIn');

    try {
      DebugLogger.debug('🔐 Starting sign in process');
      state = const AsyncValue.loading();
      DebugLogger.stateChange('AuthController', 'idle', 'loading');

      await _authRepo.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DebugLogger.debug('✅ Sign in successful');
      state = const AsyncValue.data(null);
      DebugLogger.stateChange('AuthController', 'loading', 'success');
      DebugLogger.performance('signIn', DebugLogger.stopTimer('signIn')!);
      DebugLogger.exit('AuthController.signIn', 'success');

      // Set user context in Crashlytics
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.setCrashlyticsContext();
        }
      } catch (e) {
        DebugLogger.warning('Failed to set Crashlytics context: $e');
      }

      // Ensure FCM is initialized and token is saved post sign-in
      try {
        final repo = NotificationsRepository();
        await repo.initializeFCM();
        DebugLogger.debug('🔔 Notifications initialized after sign-in');
      } catch (e, st) {
        DebugLogger.warning(
          '🔔 Failed to initialize notifications after sign-in: $e',
        );
        DebugLogger.error('🔔 Notifications init error', e, st);
      }

      // Initialize mock data after authentication (development only)
      try {
        await AppInitializationService.initializeMockDataAfterAuth();
      } catch (e) {
        DebugLogger.warning(
          '🎭 Failed to initialize mock data after sign-in: $e',
        );
      }

      return true; // Success
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Sign in failed', error, stackTrace);

      // Report to Crashlytics
      await handleError(
        error,
        stackTrace,
        operation: 'signIn',
        context: {'email': email},
      );

      state = AsyncValue.error(error, stackTrace);
      DebugLogger.stateChange('AuthController', 'loading', 'error');
      DebugLogger.stopTimer('signIn');
      DebugLogger.exit('AuthController.signIn', 'error');
      return false; // Failed
    }
  }

  Future<void> sendEmailVerification() async {
    DebugLogger.enter('AuthController.sendEmailVerification');
    DebugLogger.startTimer('sendEmailVerification');

    state = const AsyncValue.loading();
    DebugLogger.stateChange('AuthController', 'idle', 'loading');

    try {
      DebugLogger.debug('📧 Sending email verification');
      await _authRepo.sendEmailVerification();
      DebugLogger.debug('✅ Email verification sent successfully');
      state = const AsyncValue.data(null);
      DebugLogger.stateChange('AuthController', 'loading', 'success');
      DebugLogger.performance(
        'sendEmailVerification',
        DebugLogger.stopTimer('sendEmailVerification')!,
      );
      DebugLogger.exit('AuthController.sendEmailVerification', 'success');
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Email verification failed', error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
      DebugLogger.stateChange('AuthController', 'loading', 'error');
      DebugLogger.stopTimer('sendEmailVerification');
      DebugLogger.exit('AuthController.sendEmailVerification', 'error');
    }
  }

  Future<void> signOut() async {
    DebugLogger.enter('AuthController.signOut');
    DebugLogger.startTimer('signOut');

    state = const AsyncValue.loading();
    DebugLogger.stateChange('AuthController', 'idle', 'loading');

    try {
      DebugLogger.debug('🚪 Signing out user');
      await _authRepo.signOut();
      DebugLogger.debug('✅ Sign out successful');
      state = const AsyncValue.data(null);
      DebugLogger.stateChange('AuthController', 'loading', 'success');
      DebugLogger.performance('signOut', DebugLogger.stopTimer('signOut')!);
      DebugLogger.exit('AuthController.signOut', 'success');
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Sign out failed', error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
      DebugLogger.stateChange('AuthController', 'loading', 'error');
      DebugLogger.stopTimer('signOut');
      DebugLogger.exit('AuthController.signOut', 'error');
    }
  }

  // Check if current user has admin role
  Future<bool> isCurrentUserAdmin() async {
    DebugLogger.enter('AuthController.isCurrentUserAdmin');
    DebugLogger.startTimer('isCurrentUserAdmin');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        DebugLogger.warning('🔒 No user logged in for admin check');
        DebugLogger.performance(
          'isCurrentUserAdmin',
          DebugLogger.stopTimer('isCurrentUserAdmin')!,
        );
        DebugLogger.exit('AuthController.isCurrentUserAdmin', false);
        return false;
      }

      DebugLogger.debug('🔍 Checking admin status for user: ${user.email}');

      // Get user's custom claims (Firebase Auth custom claims contain role info)
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims;

      DebugLogger.debug('🔑 User claims retrieved', claims);

      final role = claims?['role'];
      final isWhitelisted = AdminWhitelist.contains(user.email);
      final isAdmin = role == 'admin' || isWhitelisted;

      DebugLogger.debug('👤 User role determination', {
        'role': role,
        'isAdmin': isAdmin,
        'uid': user.uid,
        'email': user.email,
      });

      DebugLogger.performance(
        'isCurrentUserAdmin',
        DebugLogger.stopTimer('isCurrentUserAdmin')!,
      );
      DebugLogger.exit('AuthController.isCurrentUserAdmin', isAdmin);
      return isAdmin;
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Error checking admin status', e, stackTrace);
      DebugLogger.stopTimer('isCurrentUserAdmin');
      DebugLogger.exit('AuthController.isCurrentUserAdmin', 'error');
      return false;
    }
  }
}

// Auth controller provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final authRepo = ref.watch(authRepositoryProvider);
      return AuthController(ref, authRepo);
    });

// Admin check provider
final isAdminProvider = FutureProvider<bool>((ref) async {
  try {
    DebugLogger.debug('🔍 Checking admin status via provider');
    final authController = ref.read(authControllerProvider.notifier);
    final result = await authController.isCurrentUserAdmin();
    DebugLogger.debug('✅ Admin check result', {'isAdmin': result});
    return result;
  } catch (e, stackTrace) {
    DebugLogger.error('❌ Error in isAdminProvider', e, stackTrace);
    return false; // Safe fallback
  }
});
