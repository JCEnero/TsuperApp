import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_controls.dart';

// ─── Right-side vertical control group ───────────────────────────────────────

/// Locate · Zoom-in · Zoom-out · Layers — stacked vertically on the right.
class MapControlGroup extends StatelessWidget {
  const MapControlGroup({
    super.key,
    required this.onLocate,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLayers,
    this.locateEnabled = true,
  });

  final VoidCallback onLocate;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLayers;
  final bool locateEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Locate me
        MapControlButton(
          icon: Icons.my_location_rounded,
          onTap: onLocate,
          tooltip: 'My location',
          semanticLabel: 'Go to my location',
          enabled: locateEnabled,
        ),
        const SizedBox(height: kMapButtonSpacing),

        // Zoom controls — grouped in a single card with a divider
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kMapButtonRadius),
            boxShadow: kMapShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ZoomButton(
                icon: Icons.add_rounded,
                onTap: onZoomIn,
                tooltip: 'Zoom in',
                isTop: true,
              ),
              Container(
                height: 1,
                color: AppColors.gray200,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              _ZoomButton(
                icon: Icons.remove_rounded,
                onTap: onZoomOut,
                tooltip: 'Zoom out',
                isTop: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: kMapButtonSpacing),

        // Map layers
        MapControlButton(
          icon: Symbols.layers_rounded,
          onTap: onLayers,
          tooltip: 'Map layers',
          semanticLabel: 'Change map layer',
        ),
      ],
    );
  }
}

// ─── Zoom button ─────────────────────────────────────────────────────────────

class _ZoomButton extends StatefulWidget {
  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.isTop,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isTop;

  @override
  State<_ZoomButton> createState() => _ZoomButtonState();
}

class _ZoomButtonState extends State<_ZoomButton>
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
    _scale = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topRadius = Radius.circular(kMapButtonRadius);
    final bottomRadius = Radius.circular(kMapButtonRadius);
    final radius = widget.isTop
        ? BorderRadius.only(topLeft: topRadius, topRight: topRadius)
        : BorderRadius.only(bottomLeft: bottomRadius, bottomRight: bottomRadius);

    return Semantics(
      label: widget.tooltip,
      button: true,
      child: Tooltip(
        message: widget.tooltip,
        preferBelow: false,
        child: GestureDetector(
          onTapDown: (_) => _press.forward(),
          onTapUp: (_) => _press.reverse(),
          onTapCancel: () => _press.reverse(),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          child: ScaleTransition(
            scale: _scale,
            child: ClipRRect(
              borderRadius: radius,
              child: SizedBox(
                width: kMapButtonSize,
                height: kMapButtonSize,
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom-left filter pill ──────────────────────────────────────────────────

/// Pill-shaped "Filter" button — bottom-left of the map.
/// Shows a red badge when [activeCount] > 0.
class MapFilterButton extends StatefulWidget {
  const MapFilterButton({
    super.key,
    required this.onTap,
    this.activeCount = 0,
  });

  final VoidCallback onTap;
  final int activeCount;

  @override
  State<MapFilterButton> createState() => _MapFilterButtonState();
}

class _MapFilterButtonState extends State<MapFilterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActive = widget.activeCount > 0;

    return Semantics(
      label: 'Filter jeepneys',
      button: true,
      child: Tooltip(
        message: 'Filter jeepneys',
        child: GestureDetector(
          onTapDown: (_) => _press.forward(),
          onTapUp: (_) => _press.reverse(),
          onTapCancel: () => _press.reverse(),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          child: ScaleTransition(
            scale: _scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: hasActive ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: kMapShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_rounded,
                        size: 18,
                        color: hasActive ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              hasActive ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasActive)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.activeCount}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
