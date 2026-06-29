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
                  onTap: () {},
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
                    (_, i) => JeepCard(data: AppData.nearbyJeepneys[i]),
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
                  itemBuilder:
                      (_, i) => QuickActionCard(
                        data: AppData.passengerQuickActions[i],
                      ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Suggested Routes',
                  action: 'All',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                ...AppData.recommendedRoutes.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RouteCard(data: r),
                  ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Recent Trips',
                  action: 'History',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                ...AppData.recentTrips.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TripTile(data: t),
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
            color: AppColors.primary.withOpacity(0.28),
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
              child: _glow(140, Colors.white.withOpacity(0.10)),
            ),
            Positioned(
              bottom: -28,
              left: -18,
              child: _glow(120, AppColors.blueSky.withOpacity(0.18)),
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
                                color: Colors.white.withOpacity(0.8),
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
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.settings),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
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
