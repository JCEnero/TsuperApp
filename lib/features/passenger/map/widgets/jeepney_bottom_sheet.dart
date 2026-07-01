import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/jeepney.dart';

/// A compact, fixed bottom card shown when a jeepney marker is tapped.
/// No scrolling — all content fits in a single card.
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

  static Future<void> show(
    BuildContext context, {
    required Jeepney jeepney,
    required VoidCallback onClose,
    double? distanceFromUser,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      useRootNavigator: false,
      builder: (_) => JeepneyBottomSheet(
        jeepney: jeepney,
        distanceFromUser: distanceFromUser,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(jeepney.status);
    final occupancyColor = _occupancyColor(jeepney.occupancy);
    final occupancyPct = ((jeepney.occupancy / 20) * 100).round();

    // Compute last-updated label
    final diff = DateTime.now().difference(jeepney.lastUpdated);
    final timeAgo = diff.inSeconds < 60
        ? 'Just now'
        : diff.inMinutes < 60
            ? '${diff.inMinutes} min ago'
            : '${diff.inHours} hr ago';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag indicator ─────────────────────────────────────────────
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Header: icon + route + driver + close ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: const Icon(
                  Symbols.directions_bus_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jeepney.routeName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Symbols.person_rounded,
                          size: 12,
                          color: AppColors.softInk,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            jeepney.driverName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.softInk,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      jeepney.status.displayName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Close button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onClose();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Symbols.close_rounded,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Divider ────────────────────────────────────────────────────
          Container(height: 1, color: AppColors.gray200),
          const SizedBox(height: 14),

          // ── Info row: Occupancy · ETA · Distance ───────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                // Occupancy
                Expanded(
                  child: _StatCell(
                    icon: Symbols.people_rounded,
                    iconColor: occupancyColor,
                    label: 'Occupancy',
                    value: '${jeepney.occupancy}/20',
                    sub: '$occupancyPct% full',
                  ),
                ),
                _VerticalDivider(),
                // ETA
                Expanded(
                  child: _StatCell(
                    icon: Symbols.schedule_rounded,
                    iconColor: AppColors.primary,
                    label: 'ETA',
                    value: jeepney.eta != null
                        ? '${jeepney.eta} min'
                        : '—',
                    sub: jeepney.eta != null
                        ? 'Est. arrival'
                        : 'Unavailable',
                  ),
                ),
                _VerticalDivider(),
                // Distance / Status
                Expanded(
                  child: distanceFromUser != null
                      ? _StatCell(
                          icon: Symbols.location_on_rounded,
                          iconColor: AppColors.primary,
                          label: 'Distance',
                          value:
                              '${distanceFromUser!.toStringAsFixed(1)} km',
                          sub: 'From you',
                        )
                      : _StatCell(
                          icon: Symbols.route_rounded,
                          iconColor: AppColors.primary,
                          label: 'Route',
                          value: 'Active',
                          sub: 'On road',
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Occupancy progress bar ─────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: jeepney.occupancy / 20,
                    backgroundColor: AppColors.gray200,
                    color: occupancyColor,
                    minHeight: 5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passenger load',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.muted,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Symbols.sync_rounded,
                    size: 11,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Updated $timeAgo',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Action buttons ─────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Symbols.directions_rounded, size: 16),
                  label: const Text(
                    'Track Route',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Symbols.notifications_rounded, size: 16),
                  label: const Text(
                    'Set Alert',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Compact stat cell ────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.softInk,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppColors.gray200,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color _statusColor(JeepneyStatus status) {
  switch (status) {
    case JeepneyStatus.available:
      return AppColors.onDuty;
    case JeepneyStatus.onRoute:
      return AppColors.primary;
    case JeepneyStatus.full:
      return AppColors.danger;
    case JeepneyStatus.onBreak:
      return AppColors.warning;
    case JeepneyStatus.maintenance:
      return AppColors.gray600;
  }
}

Color _occupancyColor(int occupancy) {
  if (occupancy >= 18) return AppColors.danger;
  if (occupancy >= 12) return AppColors.warning;
  return AppColors.onDuty;
}
