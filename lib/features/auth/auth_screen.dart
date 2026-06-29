// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/word_mark.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/form_widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.mode});
  final AuthMode mode;

  String get _title => switch (mode) {
    AuthMode.login => 'Welcome back',
    AuthMode.register => 'Create account',
    AuthMode.forgot => 'Reset password',
  };
  String get _sub => switch (mode) {
    AuthMode.login => 'Sign in to your TSUPER account.',
    AuthMode.register => 'Start your premium commute experience.',
    AuthMode.forgot => 'Enter your email to receive a reset link.',
  };

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: insets),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (Navigator.of(context).canPop()) ...[
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Symbols.arrow_back_rounded,
                                size: 20,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        const WordMark(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _sub,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.softInk,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (mode == AuthMode.register) ...[
                      AppFormField(
                        label: 'Full name',
                        icon: Symbols.person_rounded,
                      ),
                      const SizedBox(height: 12),
                    ],
                    AppFormField(
                      label: 'Email or mobile number',
                      icon: Symbols.email_rounded,
                    ),
                    const SizedBox(height: 12),
                    if (mode != AuthMode.forgot) ...[
                      AppFormField(
                        label: 'Password',
                        icon: Symbols.lock_rounded,
                        obscure: true,
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (mode == AuthMode.register) ...[
                      const SizedBox(height: 8),
                      AppFormField(
                        label: 'Confirm password',
                        icon: Symbols.lock_rounded,
                        obscure: true,
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (mode == AuthMode.login)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.forgotPassword,
                              ),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                    if (mode == AuthMode.forgot) ...[
                      const SizedBox(height: 8),
                      Text(
                        'A reset link will be sent to your registered email address.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: switch (mode) {
                        AuthMode.login => 'Log In',
                        AuthMode.register => 'Create Account',
                        AuthMode.forgot => 'Send Reset Link',
                      },
                      icon: Symbols.arrow_forward_rounded,
                      onPressed:
                          () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.roleSelection,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (mode == AuthMode.login)
                      Center(
                        child: GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: AppColors.softInk),
                                ),
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (mode == AuthMode.register)
                      Center(
                        child: GestureDetector(
                          onTap:
                              () =>
                                  Navigator.pushNamed(context, AppRoutes.login),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(color: AppColors.softInk),
                                ),
                                TextSpan(
                                  text: 'Log in',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (mode == AuthMode.forgot)
                      Center(
                        child: TextButton(
                          onPressed:
                              () =>
                                  Navigator.pushNamed(context, AppRoutes.login),
                          child: const Text('Back to login'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
