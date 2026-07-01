// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/app_routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/role_selection/role_selection_screen.dart';
import 'features/passenger/shell/passenger_shell.dart';
import 'features/driver/shell/driver_shell.dart';
import 'features/auth/auth_screen.dart';
import 'features/auth/email_confirmation_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/info/info_screen.dart';

// Re-export legacy names so test/widget_test.dart and any other
// existing import of package:tsuper_app/app.dart keeps working.
export 'core/constants/app_colors.dart' show AppColors;
export 'core/navigation/app_routes.dart' show AppRoutes, AuthMode;
export 'core/theme/app_theme.dart'
    show TsuperTransitionsBuilder, TsuperFadeSlideTransitionsBuilder;
export 'features/onboarding/onboarding_screen.dart' show OnboardingScreen;

// ─────────────────────────────────────────────────────────────────────────────
//  APP ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class TsuperApp extends StatelessWidget {
  const TsuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSUPER',
      theme: buildAppTheme(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
        AppRoutes.passenger: (_) => const PassengerShell(),
        AppRoutes.driver: (_) => const DriverShell(),
        AppRoutes.login: (_) => const AuthScreen(mode: AuthMode.login),
        AppRoutes.register: (_) => const AuthScreen(mode: AuthMode.register),
        AppRoutes.forgotPassword:
            (_) => const AuthScreen(mode: AuthMode.forgot),
        AppRoutes.emailConfirmation: (_) => const EmailConfirmationScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.about:
            (_) => const InfoScreen(
              title: 'About',
              body:
                  'TSUPER APP is a premium commuter experience for passengers and drivers. Phase 1 is UI only.',
            ),
        AppRoutes.helpCenter:
            (_) => const InfoScreen(
              title: 'Help Center',
              body: 'Help content placeholder for the TSUPER APP support area.',
            ),
        AppRoutes.privacy:
            (_) => const InfoScreen(
              title: 'Privacy Policy',
              body: 'Privacy policy placeholder for the Phase 1 mock build.',
            ),
        AppRoutes.terms:
            (_) => const InfoScreen(
              title: 'Terms & Conditions',
              body: 'Terms placeholder for the Phase 1 mock build.',
            ),
      },
    );
  }
}
