// Route name constants and auth enum only — no screen imports (avoids circular deps).
// The route map is wired in lib/app.dart.

enum AuthMode { login, register, forgot }

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const passenger = '/passenger';
  static const driver = '/driver';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const settings = '/settings';
  static const about = '/about';
  static const helpCenter = '/help-center';
  static const privacy = '/privacy';
  static const terms = '/terms';
}
