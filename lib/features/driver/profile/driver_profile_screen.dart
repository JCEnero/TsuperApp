import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../shared/widgets/hero_banner.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/menu_row.dart';
import '../../../shared/widgets/form_widgets.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroBanner(
              name: 'Ramon dela Cruz',
              role: 'Driver · Route 2',
              initials: 'RD',
              stats: const [
                ('ZXG-421', 'Plate'),
                ('24', 'Trips'),
                ('81%', 'Occ.'),
              ],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Driver Information',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.muted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const DetailRow(
                        label: 'License No.',
                        value: 'N01-204-889',
                      ),
                      const Divider(height: 16),
                      const DetailRow(
                        label: 'Vehicle',
                        value: 'Toyota Jeepney 28B',
                      ),
                      const Divider(height: 16),
                      const DetailRow(
                        label: 'Assigned Route',
                        value: 'Cubao – Fairview Line',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    children: [
                      MenuRow(
                        label: 'Vehicle Details',
                        icon: Symbols.directions_bus_rounded,
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      MenuRow(
                        label: 'Assigned Route',
                        icon: Symbols.route_rounded,
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
                        label: 'Help',
                        icon: Symbols.help_rounded,
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.helpCenter,
                            ),
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
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          AppRoutes.roleSelection,
                        ),
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
