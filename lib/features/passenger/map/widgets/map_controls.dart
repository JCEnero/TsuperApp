import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

// ─── Shared constants (public — used by floating_action_button_group.dart) ────

const double kMapButtonSize = 52.0;
const double kMapButtonSpacing = 10.0;
const double kMapButtonRadius = 16.0;

const List<BoxShadow> kMapShadow = [
  BoxShadow(
    color: Color(0x18000000),
    blurRadius: 12,
    spreadRadius: 0,
    offset: Offset(0, 4),
  ),
  BoxShadow(
    color: Color(0x08000000),
    blurRadius: 4,
    offset: Offset(0, 1),
  ),
];

// ─── Single floating map button ───────────────────────────────────────────────

/// A pressable floating icon button used in the right-side control group.
/// Supports normal / active / disabled states with scale press animation.
class MapControlButton extends StatefulWidget {
  const MapControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip = '',
    this.semanticLabel = '',
    this.isActive = false,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final String semanticLabel;
  final bool isActive;
  final bool enabled;

  @override
  State<MapControlButton> createState() => _MapControlButtonState();
}

class _MapControlButtonState extends State<MapControlButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _press.forward();
  void _onTapUp(_) => _press.reverse();
  void _onTapCancel() => _press.reverse();

  void _onTap() {
    if (!widget.enabled) return;
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.enabled
        ? (widget.isActive ? Colors.white : AppColors.primary)
        : AppColors.gray300;
    final bgColor = widget.isActive ? AppColors.primary : Colors.white;

    return Semantics(
      label: widget.semanticLabel.isNotEmpty
          ? widget.semanticLabel
          : widget.tooltip,
      button: true,
      enabled: widget.enabled,
      child: Tooltip(
        message: widget.tooltip,
        preferBelow: false,
        child: GestureDetector(
          onTapDown: widget.enabled ? _onTapDown : null,
          onTapUp: widget.enabled ? _onTapUp : null,
          onTapCancel: widget.enabled ? _onTapCancel : null,
          onTap: _onTap,
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: kMapButtonSize,
              height: kMapButtonSize,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(kMapButtonRadius),
                boxShadow: widget.enabled ? kMapShadow : [],
              ),
              child: Icon(widget.icon, size: 22, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
