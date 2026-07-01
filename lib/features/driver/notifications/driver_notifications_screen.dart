import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/notif_tile.dart';
import '../../../shared/widgets/category_row.dart';

class DriverNotificationsScreen extends StatefulWidget {
  const DriverNotificationsScreen({super.key});

  @override
  State<DriverNotificationsScreen> createState() =>
      _DriverNotificationsScreenState();
}

class _DriverNotificationsScreenState extends State<DriverNotificationsScreen> {
  final Set<int> _unread = {0, 1};

  void _markAllRead() {
    setState(_unread.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All driver notifications marked as read.')),
    );
  }

  void _openCategory(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opened $title updates.')));
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
          ...AppData.driverNotifications
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
          ...AppData.driverNotifications
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
          CategoryRow(
            title: 'Announcements',
            icon: Symbols.campaign_rounded,
            onTap: () => _openCategory('announcements'),
          ),
          const SizedBox(height: 8),
          CategoryRow(
            title: 'Passenger Alerts',
            icon: Symbols.person_search_rounded,
            onTap: () => _openCategory('passenger alerts'),
          ),
          const SizedBox(height: 8),
          CategoryRow(
            title: 'System Updates',
            icon: Symbols.system_update_alt_rounded,
            onTap: () => _openCategory('system updates'),
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
