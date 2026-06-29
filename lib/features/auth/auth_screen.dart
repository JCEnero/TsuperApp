// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/auth/app_session.dart';
import '../../shared/widgets/word_mark.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/form_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});
  final AuthMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _identifier = TextEditingController(); // email or mobile
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  static const _suffixOptions = ['None', 'Jr.', 'Sr.', 'II', 'III', 'IV', 'V'];
  String _suffix = 'None';

  bool _agreedToTerms = false;
  bool _showTermsError = false;
  String _password0 = '';

  UserRole? _role;

  AuthMode get mode => widget.mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is UserRole) _role = args;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _identifier.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

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

  // ── Validators ─────────────────────────────────────────────────────────────
  String? _validateName(String? v, String field) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$field is required';
    if (value.length < 2) return '$field is too short';
    if (!RegExp(r"^[A-Za-zÀ-ÿ' .-]+$").hasMatch(value)) return 'Use letters only';
    return null;
  }

  String? _validateIdentifier(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email or mobile number is required';
    final isEmail = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(value);
    final digits = value.replaceAll(RegExp(r'[\s()-]'), '');
    final isMobile = RegExp(r'^(\+?63|0)9\d{9}$').hasMatch(digits);
    if (!isEmail && !isMobile) return 'Enter a valid email or PH mobile number';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Password is required';
    if (mode == AuthMode.login) return null; // don't reveal rules on login
    if (value.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Add a lowercase letter';
    if (!RegExp(r'\d').hasMatch(value)) return 'Add a number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(value)) {
      return 'Add a special character';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if (mode != AuthMode.register) return null;
    if ((v ?? '').isEmpty) return 'Please confirm your password';
    if (v != _password.text) return 'Passwords do not match';
    return null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  void _submit() {
    final formOk = _formKey.currentState?.validate() ?? false;
    var ok = formOk;
    if (mode == AuthMode.register && !_agreedToTerms) {
      setState(() => _showTermsError = true);
      ok = false;
    }
    if (!ok) return;
    FocusScope.of(context).unfocus();

    if (mode == AuthMode.forgot) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent. Please check your email.'),
          ),
        );
      Navigator.pop(context);
      return;
    }

    // Auth success. A real backend call would send a structured payload here,
    // e.g. { role, firstName, lastName, suffix, identifier, password }.
    // Register captures the chosen role; login resolves it from the account.
    final UserRole role = mode == AuthMode.register
        ? (_role ?? UserRole.passenger)
        : AppSession.instance.resolveRoleForLogin();
    AppSession.instance.role = role;
    Navigator.pushNamedAndRemoveUntil(context, role.homeRoute, (r) => false);
  }

  // Login has no role gate — tapping "Register" sends users to role selection
  // so they pick a role first. Registering users can jump straight to login.
  void _toRegister() =>
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
  void _toLogin() => Navigator.pushReplacementNamed(context, AppRoutes.login);

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
                child: Form(
                  key: _formKey,
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
                      if (_role != null && mode != AuthMode.forgot) ...[
                        const SizedBox(height: 14),
                        _RoleBadge(role: _role!),
                      ],
                      const SizedBox(height: 28),

                      // ── Name fields (register only) ──
                      if (mode == AuthMode.register) ...[
                        AppFormField(
                          label: 'First name',
                          icon: Symbols.person_rounded,
                          controller: _firstName,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: (v) => _validateName(v, 'First name'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppFormField(
                                label: 'Last name',
                                icon: Symbols.badge_rounded,
                                controller: _lastName,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validator: (v) => _validateName(v, 'Last name'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _buildSuffixField()),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ── Identifier ──
                      AppFormField(
                        label: 'Email or mobile number',
                        icon: Symbols.email_rounded,
                        controller: _identifier,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateIdentifier,
                      ),

                      // ── Password ──
                      if (mode != AuthMode.forgot) ...[
                        const SizedBox(height: 12),
                        AppFormField(
                          label: 'Password',
                          icon: Symbols.lock_rounded,
                          obscure: true,
                          controller: _password,
                          textInputAction: mode == AuthMode.register
                              ? TextInputAction.next
                              : TextInputAction.done,
                          validator: _validatePassword,
                          onChanged: (v) => setState(() => _password0 = v),
                          onFieldSubmitted: (_) {
                            if (mode == AuthMode.login) _submit();
                          },
                        ),
                      ],

                      // ── Password strength (register only) ──
                      if (mode == AuthMode.register && _password0.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _PasswordStrength(password: _password0),
                      ],

                      // ── Confirm password (register only) ──
                      if (mode == AuthMode.register) ...[
                        const SizedBox(height: 12),
                        AppFormField(
                          label: 'Confirm password',
                          icon: Symbols.lock_reset_rounded,
                          obscure: true,
                          controller: _confirm,
                          textInputAction: TextInputAction.done,
                          validator: _validateConfirm,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],

                      // ── Forgot link / helper ──
                      if (mode == AuthMode.login)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.forgotPassword,
                              arguments: _role,
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

                      // ── Terms (register only) ──
                      if (mode == AuthMode.register) ...[
                        const SizedBox(height: 12),
                        _buildTermsCheckbox(context),
                      ],

                      const SizedBox(height: 20),
                      PrimaryButton(
                        text: switch (mode) {
                          AuthMode.login => 'Log In',
                          AuthMode.register => 'Create Account',
                          AuthMode.forgot => 'Send Reset Link',
                        },
                        icon: Symbols.arrow_forward_rounded,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      if (mode == AuthMode.login)
                        Center(
                          child: GestureDetector(
                            onTap: () => _toRegister(),
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
                            onTap: () => _toLogin(),
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
                            onPressed: () => Navigator.maybePop(context),
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
      ),
    );
  }

  Widget _buildSuffixField() {
    return DropdownButtonFormField<String>(
      initialValue: _suffix,
      isExpanded: true,
      icon: const Icon(
        Symbols.expand_more_rounded,
        size: 20,
        color: AppColors.muted,
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        labelText: 'Suffix',
        prefixIcon: const Icon(
          Symbols.more_horiz_rounded,
          size: 19,
          color: AppColors.muted,
        ),
        filled: true,
        fillColor: AppColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.softInk,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: [
        for (final s in _suffixOptions)
          DropdownMenuItem(
            value: s,
            child: Text(s, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) => setState(() => _suffix = v ?? 'None'),
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _agreedToTerms,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (v) => setState(() {
                  _agreedToTerms = v ?? false;
                  if (_agreedToTerms) _showTermsError = false;
                }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _agreedToTerms = !_agreedToTerms;
                  if (_agreedToTerms) _showTermsError = false;
                }),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.softInk,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.pushNamed(context, AppRoutes.terms),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.pushNamed(context, AppRoutes.privacy),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_showTermsError)
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 4),
            child: Text(
              'You must accept the terms to continue',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}

// Small pill showing which role the auth flow is for.
class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final icon = role == UserRole.driver
        ? Symbols.directions_bus_rounded
        : Symbols.person_rounded;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              'Continuing as ${role.label}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Live password strength indicator.
class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});
  final String password;

  (int, String, Color) _evaluate() {
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(password)) score++;
    score = score.clamp(0, 4);
    return switch (score) {
      0 || 1 => (1, 'Weak', AppColors.danger),
      2 => (2, 'Fair', AppColors.warning),
      3 => (3, 'Good', const Color(0xFF3B82F6)),
      _ => (4, 'Strong', AppColors.success),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (score, label, color) = _evaluate();
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 5,
                    decoration: BoxDecoration(
                      color: i < score ? color : AppColors.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < 3) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
