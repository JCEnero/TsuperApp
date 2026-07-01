import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/jeepney.dart';

class JeepneyMarker extends StatelessWidget {
  const JeepneyMarker({
    super.key,
    required this.jeepney,
    this.isSelected = false,
    this.onTap,
  });

  final Jeepney jeepney;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getStatusColor(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jeepney icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Symbols.directions_bus_rounded,
                size: 24,
                color: _getStatusColor(),
              ),
            ),
            // Occupancy indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getOccupancyIcon(),
                    size: 12,
                    color: _getOccupancyColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${jeepney.occupancy}/20',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  IconData _getOccupancyIcon() {
    if (jeepney.occupancy >= 18) {
      return Symbols.error_rounded;
    } else if (jeepney.occupancy >= 12) {
      return Symbols.warning_rounded;
    } else {
      return Symbols.check_circle_rounded;
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
