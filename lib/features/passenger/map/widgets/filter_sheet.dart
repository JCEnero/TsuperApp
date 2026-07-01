import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../services/jeepney_service.dart';

// ─── Filter metadata ──────────────────────────────────────────────────────────

class _FilterMeta {
  const _FilterMeta(this.filter, this.label, this.icon, this.color);
  final JeepneyFilter filter;
  final String label;
  final IconData icon;
  final Color color;
}

const List<_FilterMeta> _kFilters = [
  _FilterMeta(JeepneyFilter.all,         'All',          Icons.list_rounded,                   AppColors.primary),
  _FilterMeta(JeepneyFilter.available,   'Available',    Icons.check_circle_outline_rounded,   AppColors.onDuty),
  _FilterMeta(JeepneyFilter.nearby,      'Nearby',       Icons.near_me_rounded,                AppColors.primary),
  _FilterMeta(JeepneyFilter.lessCrowded, 'Less Crowded', Icons.people_outline_rounded,          AppColors.warning),
  _FilterMeta(JeepneyFilter.full,        'Full',         Icons.do_not_disturb_on_rounded,       AppColors.danger),
];

// ─── Public show helper ───────────────────────────────────────────────────────

Future<void> showFilterSheet({
  required BuildContext context,
  required JeepneyFilter current,
  required ValueChanged<JeepneyFilter> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.18),
    builder: (_) => _FilterSheet(current: current, onChanged: onChanged),
  );
}

// ─── Sheet widget ─────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.current, required this.onChanged});

  final JeepneyFilter current;
  final ValueChanged<JeepneyFilter> onChanged;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late JeepneyFilter _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  void _select(JeepneyFilter f) {
    HapticFeedback.selectionClick();
    setState(() => _selected = f);
    widget.onChanged(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.filter_alt_rounded,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Text(
                'Filter Jeepneys',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 17, color: AppColors.gray600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a filter to show on the map',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),

          // Filter grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _kFilters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (_, i) {
              final meta = _kFilters[i];
              final isSelected = _selected == meta.filter;
              return _FilterChipTile(
                meta: meta,
                isSelected: isSelected,
                onTap: () => _select(meta.filter),
              );
            },
          ),

          const SizedBox(height: 16),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

// ─── Filter chip tile ─────────────────────────────────────────────────────────

class _FilterChipTile extends StatefulWidget {
  const _FilterChipTile({
    required this.meta,
    required this.isSelected,
    required this.onTap,
  });

  final _FilterMeta meta;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_FilterChipTile> createState() => _FilterChipTileState();
}

class _FilterChipTileState extends State<_FilterChipTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _press.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    final color = widget.meta.color;

    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) => _press.reverse(),
      onTapCancel: () => _press.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: sel ? color.withValues(alpha: 0.10) : AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sel ? color.withValues(alpha: 0.40) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: sel ? color.withValues(alpha: 0.15) : Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  widget.meta.icon,
                  size: 17,
                  color: sel ? color : AppColors.softInk,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.meta.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? color : AppColors.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
