// Route name constants and auth enum only — no screen imports (avoids circular deps).
// The route map is wired in lib/app.dart.

enum AuthMode { login, register, forgot }

enum UserRole { passenger, driver }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.passenger => 'Passenger',
    UserRole.driver => 'Driver',
  };

  /// The home route a user of this role lands on after authenticating.
  String get homeRoute => switch (this) {
    UserRole.passenger => AppRoutes.passenger,
    UserRole.driver => AppRoutes.driver,
  };
}

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const passenger = '/passenger';
  static const driver = '/driver';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const emailConfirmation = '/email-confirmation';
  static const settings = '/settings';
  static const about = '/about';
  static const helpCenter = '/help-center';
  static const privacy = '/privacy';
  static const terms = '/terms';
}
