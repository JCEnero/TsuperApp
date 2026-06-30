// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quick_action_data.dart';
import 'tap_scale.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.data});
  final QuickActionData data;

  @override
  Widget build(BuildContext context) {
    final lighter = Color.lerp(data.color, Colors.white, 0.22)!;
    return TapScale(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.gray200),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [lighter, data.color],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: data.color.withOpacity(0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Icon(
                  Symbols.arrow_outward_rounded,
                  size: 18,
                  color: AppColors.gray300,
                ),
              ],
            ),
            const Spacer(),
            Text(
              data.label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data.subtitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.5,
                color: AppColors.muted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
