import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import 'app_card.dart';

class OdRow extends StatelessWidget {
  const OdRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OdCard extends StatelessWidget {
  const OdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const OdRow(
            label: 'From',
            value: 'Brgy. Bagong Pag-asa, QC',
            icon: Symbols.trip_origin_rounded,
            color: AppColors.primary,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 8, bottom: 8),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          const OdRow(
            label: 'To',
            value: 'Cubao Gateway',
            icon: Symbols.location_on_rounded,
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}
