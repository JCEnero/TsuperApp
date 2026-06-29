import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/app_nav_bar.dart';
import '../dashboard/driver_dashboard_screen.dart';
import '../map/driver_map_screen.dart';
import '../trips/driver_trips_screen.dart';
import '../notifications/driver_notifications_screen.dart';
import '../profile/driver_profile_screen.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({super.key});
  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _i = 0;
  static const _pages = [
    DriverDashboardScreen(),
    DriverMapScreen(),
    DriverTripsScreen(),
    DriverNotificationsScreen(),
    DriverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: AppNavBar(
        selectedIndex: _i,
        onSelected: (v) => setState(() => _i = v),
        items: AppData.driverNav,
      ),
    );
  }
}
