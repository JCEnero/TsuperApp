import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/notif_tile.dart';
import '../../../shared/widgets/category_row.dart';

class DriverNotificationsScreen extends StatelessWidget {
  const DriverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark read'))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _GroupLabel(text: 'Today'),
          const SizedBox(height: 8),
          ...AppData.driverNotifications
              .take(2)
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotifTile(item: n, unread: true),
                ),
              ),
          const SizedBox(height: 12),
          const _GroupLabel(text: 'Earlier'),
          const SizedBox(height: 8),
          ...AppData.driverNotifications
              .skip(2)
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotifTile(item: n, unread: false),
                ),
              ),
          const SizedBox(height: 20),
          const CategoryRow(
            title: 'Announcements',
            icon: Symbols.campaign_rounded,
          ),
          const SizedBox(height: 8),
          const CategoryRow(
            title: 'Passenger Alerts',
            icon: Symbols.person_search_rounded,
          ),
          const SizedBox(height: 8),
          const CategoryRow(
            title: 'System Updates',
            icon: Symbols.system_update_alt_rounded,
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.muted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
