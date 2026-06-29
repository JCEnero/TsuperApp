import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../map_explorer/metro_manila_map_explorer.dart';

class DriverMapScreen extends StatelessWidget {
  const DriverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'On Duty · Route 2 active',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    AppIconButton(
                      icon: Symbols.info_rounded,
                      onTap:
                          () =>
                              Navigator.pushNamed(context, AppRoutes.settings),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: MetroManilaMapExplorer(
                  initialRouteId: 'qcu-cubao',
                  showDriverActions: true,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Start Trip',
                      icon: Symbols.play_arrow_rounded,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DangerButton(
                      text: 'End Trip',
                      icon: Symbols.stop_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
