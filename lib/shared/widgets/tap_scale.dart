import 'package:flutter/material.dart';

class TapScale extends StatefulWidget {
  const TapScale({super.key, required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;
  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _d = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _d = true),
      onTapUp: (_) {
        setState(() => _d = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _d = false),
      child: AnimatedScale(
        scale: _d ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
