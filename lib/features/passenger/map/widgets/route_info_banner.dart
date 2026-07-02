import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/jeepney.dart';
import '../services/jeepney_service.dart';

/// Bottom banner shown after a passenger selects a destination.
/// Displays all routes serving that destination with live jeepney counts.
///
/// Example:
///   ┌──────────────────────────────────────────┐
///   │ 🚌 Routes to SM North EDSA               │
///   │                                          │
///   │  SM Fairview → SM North   3 jeepneys    │
///   │  SM North → Cubao         2 jeepneys    │
///   └──────────────────────────────────────────┘
class RouteInfoBanner extends StatelessWidget {
  const RouteInfoBanner({
    super.key,
    required this.destination,
    required this.activeRouteIds,
    required this.jeepneyService,
    required this.onClose,
  });

  final String destination;
  final List<String> activeRouteIds;
  final JeepneyService jeepneyService;
  final VoidCallback onClose;

  // Route display names matching our backend route IDs
  static const Map<String, String> _routeNames = {
    'NOVA_BAYAN_TO_SM_FAIRVIEW': 'Nova Bayan → SM Fairview',
    'SM_FAIRVIEW_TO_SM_NORTH': 'SM Fairview → SM North EDSA',
    'SM_NORTH_TO_CUBAO': 'SM North EDSA → Cubao',
    'CUBAO_TO_NOVA_BAYAN': 'Cubao → Nova Bayan',
  };

  static const Map<String, Color> _routeColors = {
    'NOVA_BAYAN_TO_SM_FAIRVIEW': Color(0xFF1E88E5), // blue
    'SM_FAIRVIEW_TO_SM_NORTH': Color(0xFF43A047), // green
    'SM_NORTH_TO_CUBAO': Color(0xFFFB8C00), // orange
    'CUBAO_TO_NOVA_BAYAN': Color(0xFFE53935), // red
  };

  @override
  Widget build(BuildContext context) {
    // Get all jeepneys across active routes
    final allJeepneys = jeepneyService.allJeepneys;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 8),
            child: Row(
              children: [
                const Icon(
                  Symbols.directions_bus_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Routes to $destination',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Symbols.close_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.gray200),

          // Route rows
          ...activeRouteIds.map((routeId) {
            final routeName =
                _routeNames[routeId] ?? routeId.replaceAll('_', ' ');
            final color = _routeColors[routeId] ?? AppColors.primary;

            // Count live jeepneys on this route
            final count =
                allJeepneys
                    .where(
                      (j) =>
                          j.routeId == routeId &&
                          j.status != JeepneyStatus.maintenance,
                    )
                    .length;

            final available =
                allJeepneys
                    .where(
                      (j) =>
                          j.routeId == routeId &&
                          j.status == JeepneyStatus.available,
                    )
                    .length;

            return _RouteRow(
              routeName: routeName,
              color: color,
              totalCount: count,
              availableCount: available,
            );
          }),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.routeName,
    required this.color,
    required this.totalCount,
    required this.availableCount,
  });

  final String routeName;
  final Color color;
  final int totalCount;
  final int availableCount;

  @override
  Widget build(BuildContext context) {
    final isLive = totalCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Route color indicator
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Route name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routeName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isLive
                      ? '$availableCount available · $totalCount total'
                      : 'No active jeepneys',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isLive ? AppColors.softInk : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),

          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isLive
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isLive ? AppColors.success : AppColors.muted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  isLive ? 'Live' : 'None',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isLive ? AppColors.success : AppColors.muted,
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
