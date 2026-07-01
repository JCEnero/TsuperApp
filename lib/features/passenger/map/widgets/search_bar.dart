import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';

class RouteSearchBar extends StatefulWidget {
  const RouteSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search routes...',
    this.onClear,
  });

  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onClear;

  @override
  State<RouteSearchBar> createState() => _RouteSearchBarState();
}

class _RouteSearchBarState extends State<RouteSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.gray400,
          ),
          prefixIcon: const Icon(
            Symbols.search_rounded,
            color: AppColors.gray600,
            size: 24,
          ),
          suffixIcon:
              _hasText
                  ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                      widget.onClear?.call();
                    },
                    icon: const Icon(
                      Symbols.close_rounded,
                      color: AppColors.gray600,
                      size: 20,
                    ),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
