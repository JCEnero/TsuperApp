import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_colors.dart';
import '../../../mock/app_data.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/route_card.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/od_card.dart';
import '../../../shared/widgets/place_chips.dart';
import '../../../shared/widgets/app_card.dart';

class PassengerRoutesScreen extends StatefulWidget {
  const PassengerRoutesScreen({super.key});
  @override
  State<PassengerRoutesScreen> createState() => _PassengerRoutesScreenState();
}

class _PassengerRoutesScreenState extends State<PassengerRoutesScreen> {
  int _filter = 0;
  static const _filters = ['Fastest', 'Cheapest', 'Least Crowded'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Route Planner'),
        actions: [AppIconButton(icon: Symbols.history_rounded, onTap: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const OdCard(),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder:
                  (_, i) => RouteFilterChip(
                    label: _filters[i],
                    selected: i == _filter,
                    onTap: () => setState(() => _filter = i),
                  ),
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Suggested Routes',
            action: 'Filter',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ...AppData.recommendedRoutes.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RouteCard(data: r, showAction: true),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: PrimaryButton(
                  text: 'Start Trip',
                  icon: Symbols.play_arrow_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlineButton(
                  text: 'Save Route',
                  icon: Symbols.bookmark_rounded,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Recent Searches',
            action: 'Clear',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          AppCard(
            child: const Column(
              children: [
                RecentRow(label: 'Makati CBD'),
                Divider(height: 1),
                RecentRow(label: 'Quezon Memorial Circle'),
                Divider(height: 1),
                RecentRow(label: 'Quiapo Market'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(title: 'Saved Places', action: 'Edit', onTap: () {}),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                AppData.passengerSavedPlaces
                    .map((p) => SavedChip(data: p))
                    .toList(),
          ),
        ],
      ),
    );
  }
}
