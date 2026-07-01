import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import '../services/jeepney_service.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final JeepneyFilter selectedFilter;
  final ValueChanged<JeepneyFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              JeepneyFilter.values.map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_getFilterLabel(filter)),
                    selected: isSelected,
                    onSelected: (_) => onFilterChanged(filter),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.gray600,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.gray300,
                    ),
                    avatar:
                        isSelected
                            ? null
                            : Icon(_getFilterIcon(filter), size: 18),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  String _getFilterLabel(JeepneyFilter filter) {
    switch (filter) {
      case JeepneyFilter.all:
        return 'All';
      case JeepneyFilter.nearby:
        return 'Nearby';
      case JeepneyFilter.lessCrowded:
        return 'Less Crowded';
      case JeepneyFilter.available:
        return 'Available';
      case JeepneyFilter.full:
        return 'Full';
    }
  }

  IconData _getFilterIcon(JeepneyFilter filter) {
    switch (filter) {
      case JeepneyFilter.all:
        return Symbols.list_rounded;
      case JeepneyFilter.nearby:
        return Symbols.my_location_rounded;
      case JeepneyFilter.lessCrowded:
        return Symbols.people_outline_rounded;
      case JeepneyFilter.available:
        return Symbols.check_circle_rounded;
      case JeepneyFilter.full:
        return Symbols.groups_rounded;
    }
  }
}
