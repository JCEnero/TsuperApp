import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/services/authentication_service.dart';
import '../../../shared/widgets/hero_banner.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/menu_row.dart';

class PassengerProfileScreen extends StatefulWidget {
  const PassengerProfileScreen({super.key});

  @override
  State<PassengerProfileScreen> createState() => _PassengerProfileScreenState();
}

class _PassengerProfileScreenState extends State<PassengerProfileScreen> {
  final _authService = AuthenticationService();

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroBanner(
              name: 'Ferdinand Barral',
              role: 'Passenger',
              initials: 'FB',
              stats: const [('18', 'Trips'), ('₱214', 'Saved'), ('7', 'Faves')],
              onSettings:
                  () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppCard(
                  child: Column(
                    children: [
                      MenuRow(
                        label: 'Saved Places',
                        icon: Symbols.bookmark_rounded,
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      MenuRow(
                        label: 'Trip History',
                        icon: Symbols.receipt_long_rounded,
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      MenuRow(
                        label: 'Settings',
                        icon: Symbols.settings_rounded,
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.settings,
                            ),
                      ),
                      const Divider(height: 1),
                      MenuRow(
                        label: 'Help Center',
                        icon: Symbols.help_rounded,
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.helpCenter,
                            ),
                      ),
                      const Divider(height: 1),
                      MenuRow(
                        label: 'About TSUPER',
                        icon: Symbols.info_rounded,
                        onTap:
                            () => Navigator.pushNamed(context, AppRoutes.about),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: MenuRow(
                    label: 'Log out',
                    icon: Symbols.logout_rounded,
                    iconColor: AppColors.danger,
                    textColor: AppColors.danger,
                    onTap: _handleLogout,
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Text(
                    'TSUPER APP · Phase 1 Preview',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
