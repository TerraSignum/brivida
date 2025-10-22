import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Get current authenticated user
  static User? get currentUser => _auth.currentUser;

  /// Get current user's UID
  static String? get currentUserUid => _auth.currentUser?.uid;

  /// Check if user is authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  /// Sign out current user
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user's email
  static String? get currentUserEmail => _auth.currentUser?.email;

  /// Check if current user's email is verified
  static bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
}
