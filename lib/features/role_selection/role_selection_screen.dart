// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/word_mark.dart';
import '../../shared/widgets/tap_scale.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _register(BuildContext context, UserRole role) =>
      Navigator.pushNamed(context, AppRoutes.register, arguments: role);

  void _login(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const WordMark(),
                  const SizedBox(height: 36),
                  Text(
                    'Get started',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how you’ll use TSUPER to get an experience tailored to you.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.softInk),
                  ),
                  const SizedBox(height: 28),
                  _RoleCard(
                    title: 'Passenger',
                    subtitle:
                        'Search routes, track nearby jeepneys, and manage your daily commute.',
                    icon: Symbols.person_rounded,
                    badge: 'Commuter',
                    accent: AppColors.primary,
                    onTap: () => _register(context, UserRole.passenger),
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    title: 'Driver',
                    subtitle:
                        'Track trips, manage occupancy, and review your shift earnings.',
                    icon: Symbols.directions_bus_rounded,
                    badge: 'Operator',
                    accent: const Color(0xFFB8860B),
                    onTap: () => _register(context, UserRole.driver),
                  ),
                  const SizedBox(height: 28),
                  const _LabeledDivider(label: 'Already have an account?'),
                  const SizedBox(height: 16),
                  _LoginPill(onTap: () => _login(context)),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      ),
                      child: const Text('Forgot password?'),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.accent,
    required this.onTap,
  });
  final String title, subtitle, badge;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.gray200, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [accent, Color.lerp(accent, Colors.black, 0.22)!],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.28),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 26, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.softInk,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Sign up as $title',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Symbols.arrow_forward_rounded,
                      size: 15,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginPill extends StatelessWidget {
  const _LoginPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Symbols.login_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Log in to your account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
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

class _LabeledDivider extends StatelessWidget {
  const _LabeledDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
