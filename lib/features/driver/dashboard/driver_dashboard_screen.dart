// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/trip_tile.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../widgets/driver_widgets.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _DriverHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NavyEarningsCard(),
                const SizedBox(height: 12),
                _StatsRow(),
                const SizedBox(height: 18),
                _VehicleCard(),
                const SizedBox(height: 10),
                _RouteCard2(),
                const SizedBox(height: 18),
                _OccCard(),
                const SizedBox(height: 18),
                SectionHeader(
                  title: 'Quick Actions',
                  action: 'More',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.driverQuickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder:
                      (_, i) =>
                          QuickActionCard(data: AppData.driverQuickActions[i]),
                ),
                const SizedBox(height: 18),
                SectionHeader(
                  title: "Today's Trips",
                  action: 'History',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                ...AppData.driverTrips.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TripTile(data: t),
                  ),
                ),
                const SizedBox(height: 18),
                const WeeklyChartCard(),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Start Trip',
                        icon: Symbols.play_arrow_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DangerButton(
                        text: 'End Trip',
                        icon: Symbols.stop_rounded,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverHeader extends StatelessWidget {
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
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blueBright, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'RD',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good day, Driver 👋',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.softInk,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ramon dela Cruz',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.onDutyTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.onDuty,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'On Duty',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onDuty,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppIconButton(
            icon: Symbols.settings_rounded,
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}

class _NavyEarningsCard extends StatelessWidget {
  Widget _glow(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blueBright, AppColors.primary, AppColors.blueDeep],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -24,
              child: _glow(130, Colors.white.withOpacity(0.10)),
            ),
            Positioned(
              bottom: -46,
              left: -16,
              child: _glow(140, AppColors.blueSky.withOpacity(0.20)),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Symbols.account_balance_wallet_rounded,
                        size: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "Today's Earnings",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 6,
                              height: 6,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Shift active',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '₱2,140',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Symbols.trending_up_rounded,
                        size: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '+16% vs yesterday',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    children: [
                      EarningsPill(
                        label: '24 trips',
                        icon: Symbols.directions_bus_rounded,
                      ),
                      EarningsPill(
                        label: '81% occupancy',
                        icon: Symbols.people_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(AppData.driverStats.length, (i) {
        final s = AppData.driverStats[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 5,
              right: i == AppData.driverStats.length - 1 ? 0 : 5,
            ),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.025),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.blueBright, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(s.icon, size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    s.label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      color: AppColors.softInk,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Symbols.trending_up_rounded,
                        size: 14,
                        color: AppColors.blueBright,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        s.change,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blueBright,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blueBright, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Symbols.directions_bus_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle 28B',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Toyota Jeepney · ZXG-421',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.softInk,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.onDutyTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 7,
                  height: 7,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.onDuty,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Active',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onDuty,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blueBright, AppColors.primary],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.route_rounded,
              size: 19,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assigned Route',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.softInk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppData.driverRoute,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Route 2',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OccCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blueBright, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Symbols.people_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Occupancy',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '76% · 13/17',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 12,
              color: AppColors.gray200,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.76,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.blueBright, AppColors.primary],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Symbols.info_rounded, size: 13, color: AppColors.softInk),
              SizedBox(width: 5),
              Text(
                '4 seats remaining for next stop.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.softInk,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
