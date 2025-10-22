import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/admin_whitelist.dart';
import '../utils/debug_logger.dart';

/// Normalized user roles based on Firebase custom claims.
enum AppUserRole { customer, pro, admin }

AppUserRole? _mapRole(String? role, User user) {
  if (role == null) {
    return null;
  }

  switch (role) {
    case 'admin':
      return AppUserRole.admin;
    case 'pro':
      return AppUserRole.pro;
    case 'customer':
      return AppUserRole.customer;
    default:
      DebugLogger.warning('Unknown user role "$role" for ${user.uid}');
      return null;
  }
}

/// Provides the current user's role derived from Firebase custom claims.
final userRoleProvider = FutureProvider<AppUserRole?>((ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      DebugLogger.debug('👤 userRoleProvider: no authenticated user');
      return null;
    }

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims ?? {};
    final roleClaim = claims['role'] as String?;

    if (roleClaim == 'admin' || AdminWhitelist.contains(user.email)) {
      return AppUserRole.admin;
    }

    final mappedRole = _mapRole(roleClaim, user);
    DebugLogger.debug('👤 userRoleProvider resolved role', {
      'uid': user.uid,
      'role': mappedRole?.name,
    });
    return mappedRole;
  } catch (error, stackTrace) {
    DebugLogger.error(
      '❌ userRoleProvider failed to resolve role',
      error,
      stackTrace,
    );
    return null;
  }
});

/// Convenience provider exposing whether the current user is considered admin.
final isAdminRoleProvider = FutureProvider<bool>((ref) async {
  final role = await ref.watch(userRoleProvider.future);
  return role == AppUserRole.admin;
});
