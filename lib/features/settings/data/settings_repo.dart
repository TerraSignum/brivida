import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brivida_app/core/exceptions/app_exceptions.dart';
import 'package:brivida_app/core/models/app_user.dart';
import 'package:brivida_app/core/providers/firebase_providers.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider wiring for [SettingsRepository].
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(authProvider),
    functions: ref.watch(functionsProvider),
    storage: ref.watch(firebaseStorageProvider),
  );
});

class SettingsRepository {
  SettingsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseFunctions? functions,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1'),
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  static final _usernameRegExp = RegExp(
    r'^[a-z0-9_.]{3,20}$',
    caseSensitive: false,
  );
  static const _usernameBlacklist = {
    'admin',
    'support',
    'brivida',
    'moderator',
    'help',
    'contact',
  };

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  User? get _currentUser => _auth.currentUser;

  /// Stream the authenticated user's profile document.
  Stream<AppUser?> watchCurrentUser() async* {
    final user = _currentUser;
    if (user == null) {
      yield null;
      return;
    }

    final docRef = _usersCollection.doc(user.uid);
    await _ensureUserDocument(user);

    yield* docRef.snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) {
        DebugLogger.warning(
          '⚠️ SETTINGS: User document missing, creating default profile',
          {'uid': user.uid},
        );
        await _ensureUserDocument(user, force: true);
        return _fallbackUser(user);
      }

      try {
        return AppUser.fromDocument(snapshot);
      } catch (error, stackTrace) {
        DebugLogger.error(
          '❌ SETTINGS: Failed to parse user document, attempting repair',
          error,
          stackTrace,
        );
        await _repairUserDocument(user, snapshot.data());

        try {
          final refreshed = await docRef.get();
          if (refreshed.exists) {
            return AppUser.fromDocument(refreshed);
          }
        } catch (secondaryError, secondaryStack) {
          DebugLogger.error(
            '❌ SETTINGS: Failed to reload user document after repair',
            secondaryError,
            secondaryStack,
          );
        }

        return _fallbackUser(user);
      }
    });
  }

  Future<void> updateDisplayName(String name) async {
    await _updateHandle(name);
  }

  Future<void> updateLocale(String? localeCode) async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    if (localeCode == null || localeCode == 'system') {
      await _usersCollection.doc(user.uid).update({
        'locale': FieldValue.delete(),
        'localeUpdatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    final code = localeCode.toLowerCase();
    if (!['de', 'en', 'pt', 'es', 'fr'].contains(code)) {
      throw const AppException.validation(
        message: 'Die gewählte Sprache wird noch nicht unterstützt.',
      );
    }

    await _usersCollection.doc(user.uid).update({
      'locale': code,
      'localeUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMarketingOptIn(bool value) async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    await _usersCollection.doc(user.uid).update({
      'marketingOptIn': value,
      'marketingOptInUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePhoneNumber(String? rawValue) async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    final docRef = _usersCollection.doc(user.uid);
    final trimmed = rawValue?.trim() ?? '';
    if (trimmed.isEmpty) {
      await docRef.update({
        'phoneNumber': FieldValue.delete(),
        'phoneNumberUpdatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    final normalized = _normalizePhoneNumber(trimmed);
    if (normalized == null) {
      throw const AppException.validation(
        message:
            'Bitte gib eine gültige Telefonnummer mit Ländercode an (z. B. +351123456789).',
      );
    }

    await docRef.update({
      'phoneNumber': normalized,
      'phoneNumberUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePhoto(File imageFile) async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    final length = await imageFile.length();
    if (length > 1024 * 1024) {
      throw const AppException.validation(
        message: 'Das Profilbild darf maximal 1 MB groß sein.',
      );
    }

    final extension = imageFile.path.toLowerCase();
    final isPng = extension.endsWith('.png');
    final isJpeg = extension.endsWith('.jpg') || extension.endsWith('.jpeg');
    if (!isPng && !isJpeg) {
      throw const AppException.validation(
        message: 'Bitte wähle ein JPG- oder PNG-Bild aus.',
      );
    }

    final storageRef = _storage.ref().child(
      'users/${user.uid}/avatar.${isPng ? 'png' : 'jpg'}',
    );

    final metadata = SettableMetadata(
      contentType: isPng ? 'image/png' : 'image/jpeg',
      cacheControl: 'public,max-age=3600',
    );

    await storageRef.putFile(imageFile, metadata);
    final url = await storageRef.getDownloadURL();

    await _usersCollection.doc(user.uid).update({
      'photoUrl': url,
      'photoUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> reserveUsername(String desired) async {
    await _updateHandle(desired);
  }

  Future<void> _updateHandle(String raw) async {
    final normalized = _normalizeHandle(raw);

    if (!_usernameRegExp.hasMatch(normalized)) {
      throw const AppException.validation(
        message:
            'Der Benutzername muss 3–20 Zeichen (a–z, 0–9, _ .) enthalten.',
      );
    }
    if (_usernameBlacklist.contains(normalized)) {
      throw const AppException.validation(
        message: 'Dieser Benutzername ist nicht verfügbar.',
      );
    }

    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    final docRef = _usersCollection.doc(user.uid);
    final currentData = await docRef.get();
    final currentUsername = currentData.data()?['username'] as String?;
    if (currentUsername == normalized) {
      await docRef.update({
        'displayName': normalized,
        'usernameLower': normalized,
        'displayNameUpdatedAt': FieldValue.serverTimestamp(),
        'usernameUpdatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    try {
      final callable = _functions.httpsCallable('reserveUsername');
      await callable.call({'desired': normalized});
    } on FirebaseFunctionsException catch (e) {
      DebugLogger.error('reserveUsername failed', e, null);
      throw _mapFunctionsException(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }

    await docRef.update({
      'displayName': normalized,
      'username': normalized,
      'usernameLower': normalized,
      'displayNameUpdatedAt': FieldValue.serverTimestamp(),
      'usernameUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _normalizeHandle(String value) {
    final trimmed = value.trim().toLowerCase();
    final sanitized = trimmed.replaceAll(RegExp(r'[^a-z0-9_.]'), '');
    if (sanitized.length > 20) {
      return sanitized.substring(0, 20);
    }
    return sanitized;
  }

  Future<void> deleteAccount() async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    await _ensureUserDocument(user);

    try {
      final callable = _functions.httpsCallable('deleteAccount');
      await callable.call();
    } on FirebaseFunctionsException catch (e) {
      DebugLogger.error('deleteAccount callable failed', e, null);
      throw _mapFunctionsException(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  Future<void> _ensureUserDocument(User user, {bool force = false}) async {
    final docRef = _usersCollection.doc(user.uid);

    if (!force) {
      final existing = await docRef.get();
      if (existing.exists) {
        await _repairUserDocument(user, existing.data());
        return;
      }
    }

    final now = FieldValue.serverTimestamp();
    final initialPayload = <String, dynamic>{
      'email': user.email ?? '${user.uid}@users.local',
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'marketingOptIn': false,
      'isVerified': user.emailVerified,
      'createdAt': now,
      'status': 'active',
      'deleted': false,
    };

    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      final normalized = _normalizePhoneNumber(user.phoneNumber!);
      if (normalized != null) {
        initialPayload['phoneNumber'] = normalized;
      }
    }

    await docRef.set(initialPayload, SetOptions(merge: true));
    DebugLogger.debug('✅ SETTINGS: Ensured user document exists', {
      'uid': user.uid,
      'email': user.email,
    });
  }

  Future<void> _repairUserDocument(
    User user,
    Map<String, dynamic>? data,
  ) async {
    final docRef = _usersCollection.doc(user.uid);
    final updates = <String, dynamic>{};

    final storedEmail = data?['email'] as String?;
    if ((storedEmail == null || storedEmail.isEmpty) && user.email != null) {
      updates['email'] = user.email;
    }

    if (data?['marketingOptIn'] == null) {
      updates['marketingOptIn'] = false;
    }

    if (data?['isVerified'] == null) {
      updates['isVerified'] = user.emailVerified;
    }

    if (data?['deleted'] == null) {
      updates['deleted'] = false;
    }

    if (data?['status'] == null) {
      updates['status'] = 'active';
    }

    if ((data?['phoneNumber'] == null ||
            (data?['phoneNumber'] as String?)?.isEmpty == true) &&
        user.phoneNumber != null &&
        user.phoneNumber!.isNotEmpty) {
      final normalized = _normalizePhoneNumber(user.phoneNumber!);
      if (normalized != null) {
        updates['phoneNumber'] = normalized;
      }
    }

    if (data?['createdAt'] == null) {
      updates['createdAt'] = FieldValue.serverTimestamp();
    }

    if (updates.isEmpty) {
      return;
    }

    updates['lastSyncedAt'] = FieldValue.serverTimestamp();

    await docRef.set(updates, SetOptions(merge: true));
    DebugLogger.debug('🛠️ SETTINGS: Repaired missing user fields', {
      'uid': user.uid,
      'updatedFields': updates.keys.join(','),
    });
  }

  AppUser _fallbackUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '${user.uid}@users.local',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: _normalizePhoneNumber(user.phoneNumber ?? ''),
      marketingOptIn: false,
      isVerified: user.emailVerified,
      role: null,
      username: null,
      usernameLower: null,
      locale: null,
      createdAt: DateTime.now(),
    );
  }

  String? _normalizePhoneNumber(String? raw) {
    if (raw == null) {
      return null;
    }

    var value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    value = value.replaceAll(RegExp(r'[\s()-]'), '');
    if (value.startsWith('00')) {
      value = '+${value.substring(2)}';
    }

    if (!value.startsWith('+')) {
      value = '+$value';
    }

    final digits = value.substring(1);
    if (!RegExp(r'^\d{6,15}$', multiLine: false).hasMatch(digits)) {
      return null;
    }

    return '+$digits';
  }

  AppException _mapFunctionsException(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'already-exists':
      case 'failed-precondition':
        final details = e.details;
        if (details is Map && details['code'] == 'ALREADY_TAKEN') {
          return const AppException.validation(
            message: 'Dieser Benutzername ist bereits vergeben.',
          );
        }
        if (details is Map && details['code'] == 'BLACKLISTED') {
          return const AppException.validation(
            message: 'Dieser Benutzername ist nicht erlaubt.',
          );
        }
        if (details is Map && details['code'] == 'BLOCKED_ACTIVE_OPERATIONS') {
          return const AppException.validation(
            message:
                'Bitte schließe offene Zahlungen oder Disputes, bevor du den Account löschst.',
          );
        }
        return AppException.validation(
          message: e.message ?? 'Aktion konnte nicht durchgeführt werden.',
        );
      case 'invalid-argument':
        final details = e.details;
        if (details is Map && details['code'] == 'INVALID_FORMAT') {
          return const AppException.validation(
            message:
                'Der Benutzername muss 3–20 Zeichen (a–z, 0–9, _ .) enthalten.',
          );
        }
        return AppException.validation(
          message: e.message ?? 'Die Eingaben sind ungültig.',
        );
      case 'permission-denied':
        return const AppException.forbidden();
      case 'unauthenticated':
        return const AppException.notAuthenticated();
      default:
        return AppException.unknown(
          message: e.message ?? 'Ein unbekannter Fehler ist aufgetreten.',
        );
    }
  }
}
