import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/jeepney.dart';

class JeepneyBottomSheet extends StatelessWidget {
  const JeepneyBottomSheet({
    super.key,
    required this.jeepney,
    required this.onClose,
    this.distanceFromUser,
  });

  final Jeepney jeepney;
  final VoidCallback onClose;
  final double? distanceFromUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Symbols.directions_bus_rounded,
                        size: 28,
                        color: _getStatusColor(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jeepney.routeName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jeepney.driverName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppColors.softInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Symbols.close_rounded),
                      color: AppColors.gray600,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Status and Occupancy
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.circle,
                      label: jeepney.status.displayName,
                      color: _getStatusColor(),
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      icon: Symbols.people_rounded,
                      label: '${jeepney.occupancy}/20 passengers',
                      color: _getOccupancyColor(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Distance
                if (distanceFromUser != null) _buildDistanceRow(),
                const SizedBox(height: 16),
                // Last Updated
                _buildLastUpdatedRow(),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Symbols.directions_rounded),
                        label: const Text('Track Route'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Symbols.notifications_rounded),
                        label: const Text('Set Alert'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceRow() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '${distanceFromUser!.toStringAsFixed(1)} km away',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdatedRow() {
    final now = DateTime.now();
    final difference = now.difference(jeepney.lastUpdated);

    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes} min ago';
    } else {
      timeAgo = '${difference.inHours} hours ago';
    }

    return Row(
      children: [
        const Icon(
          Symbols.schedule_rounded,
          size: 16,
          color: AppColors.gray600,
        ),
        const SizedBox(width: 8),
        Text(
          'Updated $timeAgo',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (jeepney.status) {
      case JeepneyStatus.available:
        return AppColors.primary;
      case JeepneyStatus.onRoute:
        return AppColors.secondary;
      case JeepneyStatus.full:
        return AppColors.danger;
      case JeepneyStatus.onBreak:
        return AppColors.warning;
      case JeepneyStatus.maintenance:
        return AppColors.gray600;
    }
  }

  Color _getOccupancyColor() {
    if (jeepney.occupancy >= 18) {
      return AppColors.danger;
    } else if (jeepney.occupancy >= 12) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }
}
