import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/notif_tile.dart';
import '../../../shared/widgets/category_row.dart';

class PassengerNotificationsScreen extends StatelessWidget {
  const PassengerNotificationsScreen({super.key});

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
          ...AppData.passengerNotifications
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
          ...AppData.passengerNotifications
              .skip(2)
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotifTile(item: n, unread: false),
                ),
              ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Browse categories', action: '', onTap: () {}),
          const SizedBox(height: 10),
          const CategoryRow(
            title: 'Route Updates',
            icon: Symbols.route_rounded,
          ),
          const SizedBox(height: 8),
          const CategoryRow(
            title: 'System Alerts',
            icon: Symbols.warning_rounded,
          ),
          const SizedBox(height: 8),
          const CategoryRow(
            title: 'Promotions',
            icon: Symbols.local_offer_rounded,
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
