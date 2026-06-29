import '../navigation/app_routes.dart';

/// Minimal in-memory session for the Phase 1 mock build.
///
/// In a real app the role is owned by the account and returned by the backend
/// on sign-in. Until that exists, we capture the role chosen at registration
/// and reuse it on subsequent logins. Login never asks the user for a role.
class AppSession {
  AppSession._();
  static final AppSession instance = AppSession._();

  /// The role of the currently signed-in (or just-registered) user.
  UserRole? role;

  /// Resolve the role to route a login to. A real backend would return this
  /// based on the authenticated account; here we fall back to passenger.
  UserRole resolveRoleForLogin() => role ?? UserRole.passenger;

  void signOut() => role = null;
}
