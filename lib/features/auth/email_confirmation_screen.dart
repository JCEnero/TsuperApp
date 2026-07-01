// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/services/authentication_service.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/app_buttons.dart';

/// Shown after successful registration when email confirmation is required.
/// Tells the user to check their inbox and polls for confirmation.
class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final _authService = AuthenticationService();
  String? _email;
  bool _isResending = false;
  bool _resentSuccess = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Email is passed as route argument from registration
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) _email = args;
  }

  Future<void> _resendEmail() async {
    if (_email == null) return;

    setState(() {
      _isResending = true;
      _resentSuccess = false;
    });

    try {
      await _authService.resetPassword(_email!);
      if (mounted) {
        setState(() => _resentSuccess = true);
      }
    } catch (_) {
      // Silently fail — user can try again
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _goToLogin,
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
                      const AppLogo(size: AppLogoSize.small),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Email icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.mark_email_unread_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Check your email',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: AppColors.softInk,
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(text: 'We sent a confirmation link to '),
                        TextSpan(
                          text: _email ?? 'your email',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '.\n\nClick the link in the email to verify your account, then come back and log in.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Go to login button
                  PrimaryButton(
                    text: 'Go to Login',
                    icon: Symbols.login_rounded,
                    onPressed: _goToLogin,
                  ),

                  const SizedBox(height: 16),

                  // Resend email
                  if (_resentSuccess)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Symbols.check_circle_rounded,
                            size: 18,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Verification email resent. Check your inbox.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Center(
                      child: TextButton(
                        onPressed: _isResending ? null : _resendEmail,
                        child: Text(
                          _isResending
                              ? 'Resending...'
                              : "Didn't receive the email? Resend",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Help note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Symbols.info_rounded,
                          size: 18,
                          color: AppColors.softInk,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Check your spam or junk folder if you don\'t see the email in your inbox.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.softInk,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
