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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Trips & Earnings'),
        actions: [AppIconButton(icon: Symbols.download_rounded, onTap: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '₱3,450',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  children: [
                    EarningsPill(
                      label: 'Today ₱2,140',
                      icon: Symbols.today_rounded,
                    ),
                    EarningsPill(
                      label: 'This week',
                      icon: Symbols.date_range_rounded,
                    ),
                  ],
                ),
              ],
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
                  accent: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallStat(
                  label: 'Avg Occupancy',
                  value: '76%',
                  icon: Symbols.people_rounded,
                  accent: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallStat(
                  label: 'Completion',
                  value: '98%',
                  icon: Symbols.check_circle_rounded,
                  accent: AppColors.gray600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const WeeklyChartCard(),
          const SizedBox(height: 18),
          SectionHeader(title: "Today's Trips", action: 'Export', onTap: () {}),
          const SizedBox(height: 10),
          ...AppData.driverTrips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TripTile(data: t),
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(title: 'History', action: 'All', onTap: () {}),
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
    this.accent = AppColors.primary,
  });
  final String label, value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 3, color: accent),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 13, color: Colors.white),
                ),
                const SizedBox(height: 8),
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

class _HistRow extends StatelessWidget {
  const _HistRow({required this.route, required this.time, required this.amt});
  final String route, time, amt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Symbols.history_rounded,
          size: 16,
          color: Colors.white,
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
    );
  }
}
