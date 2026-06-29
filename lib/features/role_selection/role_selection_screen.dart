// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/word_mark.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/tap_scale.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});
  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int? _sel;

  Future<void> _pick(int i, String route) async {
    setState(() => _sel = i);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

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
                  const SizedBox(height: 32),
                  Text(
                    'Who are you?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your role to enter your personalized experience.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.softInk),
                  ),
                  const SizedBox(height: 28),
                  _RoleCard(
                    title: 'Passenger',
                    subtitle:
                        'Search routes, track nearby jeepneys, and manage your commute.',
                    icon: Symbols.person_rounded,
                    badge: 'Commuter',
                    selected: _sel == 0,
                    onTap: () => _pick(0, AppRoutes.passenger),
                  ),
                  const SizedBox(height: 14),
                  _RoleCard(
                    title: 'Driver',
                    subtitle:
                        'Track trips, manage occupancy, and review shift earnings.',
                    icon: Symbols.directions_bus_rounded,
                    badge: 'Operator',
                    selected: _sel == 1,
                    onTap: () => _pick(1, AppRoutes.driver),
                  ),
                  const SizedBox(height: 32),
                  const _LabeledDivider(label: 'Already have an account?'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Log In',
                          icon: Symbols.login_rounded,
                          onPressed:
                              () =>
                                  Navigator.pushNamed(context, AppRoutes.login),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlineButton(
                          text: 'Register',
                          icon: Symbols.person_add_rounded,
                          onPressed:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed:
                          () => Navigator.pushNamed(
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
    required this.selected,
    required this.onTap,
  });
  final String title, subtitle, badge;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.gray200,
            width: selected ? 0 : 1.5,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? Colors.white.withOpacity(0.18)
                              : AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? Colors.white.withOpacity(0.18)
                              : AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.primary,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.5,
                  color:
                      selected
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.softInk,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    selected ? 'Selected ✓' : 'Select',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Symbols.arrow_forward_rounded,
                    size: 14,
                    color: selected ? Colors.white : AppColors.primary,
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
