import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(color: AppColors.primary, label: 'Available'),
          _buildLegendItem(color: AppColors.secondary, label: 'On Route'),
          _buildLegendItem(color: AppColors.warning, label: 'On Break'),
          _buildLegendItem(color: AppColors.danger, label: 'Full'),
          _buildLegendItem(color: AppColors.gray600, label: 'Maintenance'),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.softInk,
            ),
          ),
        ],
      ),
    );
  }
}
