import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/menu_row.dart';
import '../../shared/widgets/form_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        leading:
            Navigator.of(context).canPop()
                ? IconButton(
                  icon: const Icon(Symbols.arrow_back_rounded),
                  onPressed: () => Navigator.maybePop(context),
                )
                : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SettingsGroup(
            label: 'Account',
            children: [
              MenuRow(
                label: 'Account',
                icon: Symbols.person_rounded,
                onTap: () {},
              ),
              const Divider(height: 1),
              MenuRow(
                label: 'Notifications',
                icon: Symbols.notifications_rounded,
                onTap: () {},
              ),
              const Divider(height: 1),
              MenuRow(
                label: 'Appearance',
                icon: Symbols.palette_rounded,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            label: 'Preferences',
            children: [
              ToggleRow(label: 'Dark Mode Ready', val: false),
              const Divider(height: 1),
              ToggleRow(label: 'Compact Layout', val: false),
              const Divider(height: 1),
              ToggleRow(label: 'High Contrast', val: false),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            label: 'Support',
            children: [
              MenuRow(
                label: 'About',
                icon: Symbols.info_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.about),
              ),
              const Divider(height: 1),
              MenuRow(
                label: 'Help Center',
                icon: Symbols.help_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter),
              ),
              const Divider(height: 1),
              MenuRow(
                label: 'Privacy Policy',
                icon: Symbols.privacy_tip_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.privacy),
              ),
              const Divider(height: 1),
              MenuRow(
                label: 'Terms & Conditions',
                icon: Symbols.gavel_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.terms),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'TSUPER APP · v1.0.0 (Phase 1)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.label, required this.children});
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        AppCard(child: Column(children: children)),
      ],
    );
  }
}
