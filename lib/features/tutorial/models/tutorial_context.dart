import '../../../core/providers/user_role_provider.dart';

/// Context information that helps tailoring tutorial steps to the current user.
class TutorialContext {
  const TutorialContext({this.role});

  final AppUserRole? role;

  bool get isAdmin => role == AppUserRole.admin;

  bool get isPro => role == AppUserRole.pro || isAdmin;

  bool get isCustomer => role == AppUserRole.customer || role == null;
}
