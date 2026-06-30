import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/place_chips.dart';
import '../../../shared/widgets/jeep_card.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/route_card.dart';
import '../../../shared/widgets/trip_tile.dart';
import '../../../shared/widgets/promo_banner.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onQuickActionTap(BuildContext context, String label) {
    switch (label) {
      case 'Plan Route':
        _showInfo(context, 'Open the Routes tab to plan a trip.');
        break;
      case 'Track Jeepney':
        _showInfo(context, 'Open the Map tab to track nearby jeepneys.');
        break;
      case 'Saved Places':
        _showInfo(context, 'Saved places loaded.');
        break;
      case 'Help Desk':
        Navigator.pushNamed(context, AppRoutes.helpCenter);
        break;
      default:
        _showInfo(context, '$label ready.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppData.passengerSavedPlaces.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder:
                        (_, i) =>
                            QuickChip(data: AppData.passengerSavedPlaces[i]),
                  ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Nearby Jeepneys',
                  action: 'See all',
                  onTap: () => _showInfo(context, 'Showing all nearby units.'),
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 158,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: AppData.nearbyJeepneys.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder:
                    (_, i) => JeepCard(
                      data: AppData.nearbyJeepneys[i],
                      useNavyGradient: true,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionHeader(
                  title: 'Quick Actions',
                  action: 'More',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.passengerQuickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (_, i) {
                    final action = AppData.passengerQuickActions[i];
                    return QuickActionCard(
                      data: action,
                      useNavyGradient: true,
                      onTap: () => _onQuickActionTap(context, action.label),
                    );
                  },
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Suggested Routes',
                  action: 'All',
                  onTap:
                      () => _showInfo(
                        context,
                        'Showing all suggested routes for today.',
                      ),
                ),
                const SizedBox(height: 10),
                ...AppData.recommendedRoutes.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RouteCard(data: r, useNavyGradient: true),
                  ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Recent Trips',
                  action: 'History',
                  onTap:
                      () => _showInfo(context, 'Recent trip history loaded.'),
                ),
                const SizedBox(height: 10),
                ...AppData.recentTrips.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TripTile(data: t, useNavyGradient: true),
                  ),
                ),
                const SizedBox(height: 10),
                const PromoBanner(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blueBright, AppColors.primary, AppColors.blueDeep],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: Stack(
          children: [
            Positioned(
              top: -36,
              right: -28,
              child: _glow(140, Colors.white.withValues(alpha: 0.10)),
            ),
            Positioned(
              bottom: -28,
              left: -18,
              child: _glow(120, AppColors.blueSky.withValues(alpha: 0.18)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, top + 16, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning 👋',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Ferdinand Barral',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.settings,
                            ),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'FB',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const AppSearchBar(placeholder: 'Where to?'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _glow(double size, Color color) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
);
