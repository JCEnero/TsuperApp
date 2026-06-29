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
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const AppSearchBar(placeholder: 'Where to?'),
                const SizedBox(height: 14),
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning 👋',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.softInk,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ferdinand Barral',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
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
    );
  }
}
