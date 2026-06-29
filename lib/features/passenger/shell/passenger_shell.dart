import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/app_nav_bar.dart';
import '../home/passenger_home_screen.dart';
import '../map/passenger_map_screen.dart';
import '../routes/passenger_routes_screen.dart';
import '../notifications/passenger_notifications_screen.dart';
import '../profile/passenger_profile_screen.dart';

class PassengerShell extends StatefulWidget {
  const PassengerShell({super.key});
  @override
  State<PassengerShell> createState() => _PassengerShellState();
}

class _PassengerShellState extends State<PassengerShell> {
  int _i = 0;
  static const _pages = [
    PassengerHomeScreen(),
    PassengerMapScreen(),
    PassengerRoutesScreen(),
    PassengerNotificationsScreen(),
    PassengerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: AppNavBar(
        selectedIndex: _i,
        onSelected: (v) => setState(() => _i = v),
        items: AppData.passengerNav,
      ),
    );
  }
}
