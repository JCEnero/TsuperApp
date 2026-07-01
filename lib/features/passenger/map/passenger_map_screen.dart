import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../map_explorer/metro_manila_map_explorer.dart';

class PassengerMapScreen extends StatelessWidget {
  const PassengerMapScreen({super.key});

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder:
          (context) => SafeArea(
            child: StatefulBuilder(
              builder: (context, setState) {
                var showStops = true;
                var showJeepneys = true;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Map Filters',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Show jeepneys'),
                        value: showJeepneys,
                        onChanged: (v) => setState(() => showJeepneys = v),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Show stops'),
                        value: showStops,
                        onChanged: (v) => setState(() => showStops = v),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Map filters applied.'),
                              ),
                            );
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }

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
                  AppIconButton(
                    icon: Symbols.tune_rounded,
                    onTap: () => _openFilters(context),
                  ),
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
