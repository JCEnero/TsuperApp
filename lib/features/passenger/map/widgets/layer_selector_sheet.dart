import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/constants/app_colors.dart';

// ─── Map layer enum ───────────────────────────────────────────────────────────

/// Each case maps to a Google Maps base layer.
///
/// [MapLayerType.landmarks] is implemented as [MapType.normal] with the
/// default map style cleared so Google's built-in POI / establishment labels
/// are fully visible. The flutter_google_maps plugin does not expose a
/// dedicated POI toggle, so this is the closest supported behaviour.
enum MapLayerType { normal, satellite, terrain, hybrid, landmarks }

extension MapLayerTypeX on MapLayerType {
  String get label {
    switch (this) {
      case MapLayerType.normal:    return 'Default';
      case MapLayerType.satellite: return 'Satellite';
      case MapLayerType.terrain:   return 'Terrain';
      case MapLayerType.hybrid:    return 'Hybrid';
      case MapLayerType.landmarks: return 'Landmarks';
    }
  }

  String get description {
    switch (this) {
      case MapLayerType.normal:    return 'Standard road map';
      case MapLayerType.satellite: return 'Aerial imagery';
      case MapLayerType.terrain:   return 'Elevation & landforms';
      case MapLayerType.hybrid:    return 'Satellite + roads & labels';
      case MapLayerType.landmarks: return 'POIs, businesses & places';
    }
  }

  IconData get icon {
    switch (this) {
      case MapLayerType.normal:    return Icons.map_rounded;
      case MapLayerType.satellite: return Symbols.satellite_alt_rounded;
      case MapLayerType.terrain:   return Symbols.terrain_rounded;
      case MapLayerType.hybrid:    return Symbols.layers_rounded;
      case MapLayerType.landmarks: return Symbols.location_city_rounded;
    }
  }

  /// Converts to the [MapType] used by the Google Maps Flutter SDK.
  ///
  /// Landmarks uses [MapType.normal] — the calling widget is responsible for
  /// clearing any custom map style JSON so POI labels are rendered by Google.
  MapType toGoogleMapType() {
    switch (this) {
      case MapLayerType.normal:    return MapType.normal;
      case MapLayerType.satellite: return MapType.satellite;
      case MapLayerType.terrain:   return MapType.terrain;
      case MapLayerType.hybrid:    return MapType.hybrid;
      case MapLayerType.landmarks: return MapType.normal;
    }
  }

  /// True when the custom map style JSON should be suppressed so Google's
  /// default POI/establishment labels are visible.
  bool get showNativePOIs => this == MapLayerType.landmarks;
}

// ─── Public show helper ───────────────────────────────────────────────────────

Future<void> showLayerSelectorSheet({
  required BuildContext context,
  required MapLayerType current,
  required ValueChanged<MapLayerType> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.18),
    builder: (_) => _LayerSelectorSheet(current: current, onSelected: onSelected),
  );
}

// ─── Sheet ────────────────────────────────────────────────────────────────────

class _LayerSelectorSheet extends StatelessWidget {
  const _LayerSelectorSheet({required this.current, required this.onSelected});

  final MapLayerType current;
  final ValueChanged<MapLayerType> onSelected;

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
        children: [
          // Drag handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
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
                child: const Icon(Symbols.layers_rounded,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Text(
                'Map Layer',
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
          const SizedBox(height: 20),

          // Tiles
          ...MapLayerType.values.map((layer) => _LayerTile(
                layer: layer,
                isSelected: layer == current,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelected(layer);
                  Navigator.of(context).pop();
                },
              )),

          // SDK limitation note for Landmarks
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Landmarks mode clears the custom map style so Google\'s '
                    'built-in POI labels become visible. Full programmatic POI '
                    'toggling is not exposed by the Flutter Google Maps plugin.',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

// ─── Layer tile ───────────────────────────────────────────────────────────────

class _LayerTile extends StatefulWidget {
  const _LayerTile({
    required this.layer,
    required this.isSelected,
    required this.onTap,
  });

  final MapLayerType layer;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_LayerTile> createState() => _LayerTileState();
}

class _LayerTileState extends State<_LayerTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hover;

  @override
  void initState() {
    super.initState();
    _hover = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (h) => h ? _hover.forward() : _hover.reverse(),
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primary.withValues(alpha: 0.07)
                  : AppColors.gray100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    widget.layer.icon,
                    size: 20,
                    color: widget.isSelected
                        ? AppColors.primary
                        : AppColors.gray600,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.layer.label,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: widget.isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: widget.isSelected
                              ? AppColors.primary
                              : AppColors.ink,
                        ),
                      ),
                      Text(
                        widget.layer.description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white),
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
