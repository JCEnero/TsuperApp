// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/trip_tile.dart';
import '../widgets/driver_widgets.dart';

class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key});

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Trips & Operations'),
        actions: [
          AppIconButton(
            icon: Symbols.download_rounded,
            onTap: () => _showInfo(context, 'Trip summary exported locally.'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.blueBright,
                  AppColors.primary,
                  AppColors.blueDeep,
                ],
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
                              Symbols.route_rounded,
                              size: 16,
                              color: Colors.white.withOpacity(0.85),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Today\'s Operations',
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
                              child: const Text(
                                'Route 2',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '18 trips completed',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Wrap(
                          spacing: 8,
                          children: [
                            StatusPill(
                              label: '5h 18m online',
                              icon: Symbols.today_rounded,
                            ),
                            StatusPill(
                              label: '42.7 km traveled',
                              icon: Symbols.date_range_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SmallStat(
                  label: 'Trips',
                  value: '42',
                  icon: Symbols.directions_bus_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallStat(
                  label: 'Occupancy',
                  value: '76%',
                  icon: Symbols.people_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallStat(
                  label: 'Completion',
                  value: '98%',
                  icon: Symbols.check_circle_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const WeeklyChartCard(),
          const SizedBox(height: 18),
          SectionHeader(
            title: "Today's Trips",
            action: 'Export',
            onTap: () => _showInfo(context, 'Today\'s trips exported.'),
          ),
          const SizedBox(height: 10),
          ...AppData.driverTrips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TripTile(data: t),
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'History',
            action: 'All',
            onTap: () => _showInfo(context, 'Showing full trip history.'),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: const Column(
              children: [
                _HistRow(route: 'Route 1', time: 'Mon 8:00 AM', amt: '₱180'),
                Divider(height: 1),
                _HistRow(route: 'Route 2', time: 'Tue 1:20 PM', amt: '₱220'),
                Divider(height: 1),
                _HistRow(route: 'Route 3', time: 'Wed 5:10 PM', amt: '₱195'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.gray200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppColors.softInk,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistRow extends StatelessWidget {
  const _HistRow({required this.route, required this.time, required this.amt});
  final String route, time, amt;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gray200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Symbols.history_rounded,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          route,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.softInk,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            amt,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Decorative soft circle used inside gradient hero panels.
Widget _glow(double size, Color color) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
);
