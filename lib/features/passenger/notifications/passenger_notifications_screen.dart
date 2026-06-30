import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/notif_tile.dart';
import '../../../shared/widgets/category_row.dart';

class PassengerNotificationsScreen extends StatefulWidget {
  const PassengerNotificationsScreen({super.key});

  @override
  State<PassengerNotificationsScreen> createState() =>
      _PassengerNotificationsScreenState();
}

class _PassengerNotificationsScreenState
    extends State<PassengerNotificationsScreen> {
  final Set<int> _unread = {0, 1};

  void _markAllRead() {
    setState(_unread.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All passenger notifications marked as read.'),
      ),
    );
  }

  void _openCategory(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opened $title notifications.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: _markAllRead, child: const Text('Mark read')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _GroupLabel(text: 'Today'),
          const SizedBox(height: 8),
          ...AppData.passengerNotifications
              .take(2)
              .toList()
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotifTile(
                    item: entry.value,
                    unread: _unread.contains(entry.key),
                  ),
                ),
              ),
          const SizedBox(height: 12),
          const _GroupLabel(text: 'Earlier'),
          const SizedBox(height: 8),
          ...AppData.passengerNotifications
              .skip(2)
              .toList()
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotifTile(
                    item: entry.value,
                    unread: _unread.contains(entry.key + 2),
                  ),
                ),
              ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Browse categories',
            action: '',
            onTap: () => _openCategory('all'),
          ),
          const SizedBox(height: 10),
          CategoryRow(
            title: 'Route Updates',
            icon: Symbols.route_rounded,
            onTap: () => _openCategory('route updates'),
          ),
          const SizedBox(height: 8),
          CategoryRow(
            title: 'System Alerts',
            icon: Symbols.warning_rounded,
            onTap: () => _openCategory('system alerts'),
          ),
          const SizedBox(height: 8),
          CategoryRow(
            title: 'Promotions',
            icon: Symbols.local_offer_rounded,
            onTap: () => _openCategory('promotions'),
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
