import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Firebase Auth
final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Current user stream
final currentUserProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(authProvider);
  return auth.authStateChanges();
});

// Firestore
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Cloud Functions
final functionsProvider = Provider<FirebaseFunctions>((ref) {
  final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
  return functions;
});

// Firebase Storage
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

// Current user data (nullable)
final currentUserDataProvider = Provider<User?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
});
