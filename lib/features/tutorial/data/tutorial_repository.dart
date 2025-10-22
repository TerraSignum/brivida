import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/debug_logger.dart';
import '../models/tutorial_state.dart';

/// Provider wiring for the tutorial repository.
final tutorialRepositoryProvider = Provider<TutorialRepository>((ref) {
  return TutorialRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(authProvider),
  );
});

/// Handles persistence of tutorial progress in Firestore.
class TutorialRepository {
  TutorialRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  static const _tutorialField = 'tutorialFlags';

  /// Fetches the current tutorial state for the authenticated user.
  Future<TutorialState> loadState() async {
    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.debug('🎓 TutorialRepository.loadState skipped (no user)');
      return TutorialState.disabled();
    }

    try {
      final snapshot = await _usersCollection.doc(user.uid).get();
      final payload = snapshot.data()?[_tutorialField] as Map<String, dynamic>?;
      final state = TutorialState.fromJson(payload);
      DebugLogger.debug('🎓 Tutorial state loaded', {
        'uid': user.uid,
        'disabled': state.disabled,
        'completed': state.completedScreens.keys.join(','),
      });
      return state;
    } catch (error, stackTrace) {
      DebugLogger.error('🎓 Failed to load tutorial flags', error, stackTrace);
      return TutorialState.disabled();
    }
  }

  /// Persists the provided state.
  Future<void> saveState(TutorialState state) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      await _usersCollection.doc(user.uid).set({
        _tutorialField: state.toJson(),
        'tutorialFlagsUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      DebugLogger.debug('🎓 Tutorial state saved', {
        'uid': user.uid,
        'disabled': state.disabled,
        'completed': state.completedScreens.keys.join(','),
      });
    } catch (error, stackTrace) {
      DebugLogger.error('🎓 Failed to save tutorial flags', error, stackTrace);
      rethrow;
    }
  }

  /// Resets the tutorial progress to its initial state.
  Future<TutorialState> resetState() async {
    final next = TutorialState.initial();
    await saveState(next);
    return next;
  }
}
