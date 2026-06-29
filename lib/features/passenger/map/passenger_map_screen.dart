import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../map_explorer/metro_manila_map_explorer.dart';

class PassengerMapScreen extends StatelessWidget {
  const PassengerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Explore Routes',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  AppIconButton(icon: Symbols.tune_rounded, onTap: () {}),
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: MetroManilaMapExplorer(
                  initialRouteId: 'qcu-sm-fairview',
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
