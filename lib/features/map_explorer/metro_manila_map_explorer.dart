// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../mock/app_data.dart';
import '../../models/map_route.dart';
import '../../shared/widgets/app_search_bar.dart';

class MetroManilaMapExplorer extends StatefulWidget {
  const MetroManilaMapExplorer({
    super.key,
    required this.initialRouteId,
    this.showDriverActions = false,
  });
  final String initialRouteId;
  final bool showDriverActions;

  @override
  State<MetroManilaMapExplorer> createState() => _MetroManilaMapExplorerState();
}

class _MetroManilaMapExplorerState extends State<MetroManilaMapExplorer>
    with TickerProviderStateMixin {
  static final LatLngBounds _bounds = LatLngBounds(
    const LatLng(14.36, 120.84),
    const LatLng(14.81, 121.18),
  );

  late final AnimatedMapController _mc = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
    curve: Curves.easeInOutCubic,
    cancelPreviousAnimations: true,
  );
  late MetroManilaRoute _route;
  String? _markerId;

  @override
  void initState() {
    super.initState();
    _route = AppData.metroManilaRoutes.firstWhere(
      (r) => r.id == widget.initialRouteId,
      orElse: () => AppData.metroManilaRoutes.first,
    );
    _markerId = _route.markers.first.id;
  }

  @override
  void dispose() {
    _mc.dispose();
    super.dispose();
  }

  MetroManilaMapMarkerSpec? get _marker =>
      _route.markers.where((m) => m.id == _markerId).firstOrNull;

  Future<void> _selectRoute(MetroManilaRoute r) async {
    if (r.id == _route.id) return;
    setState(() {
      _route = r;
      _markerId = r.markers.first.id;
    });
    await _mc.animatedFitCamera(
      cameraFit: CameraFit.coordinates(
        coordinates: r.path,
        padding: const EdgeInsets.all(72),
      ),
      customId: r.id,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _focusMarker(MetroManilaMapMarkerSpec m) async {
    setState(() => _markerId = m.id);
    await _mc.animateTo(
      dest: m.point,
      zoom: (_route.zoom + 0.35).clamp(11.0, 16.5),
      customId: m.id,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _zoomIn() => _mc.animatedZoomIn(
    customId: 'z',
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );
  void _zoomOut() => _mc.animatedZoomOut(
    customId: 'z',
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );
  Future<void> _fit() => _mc.animatedFitCamera(
    cameraFit: CameraFit.coordinates(
      coordinates: _route.path,
      padding: const EdgeInsets.all(72),
    ),
    customId: 'f',
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final sel = _marker;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSearchBar(placeholder: 'Search QCU, SM Fairview, Cubao…'),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppData.metroManilaRoutes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final r = AppData.metroManilaRoutes[i];
              return _MapChip(
                label: r.toLabel,
                selected: r.id == _route.id,
                onTap: () => _selectRoute(r),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mc.mapController,
                  options: MapOptions(
                    initialCenter: _route.center,
                    initialZoom: _route.zoom,
                    minZoom: 11,
                    maxZoom: 16.5,
                    cameraConstraint: CameraConstraint.contain(bounds: _bounds),
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onTap:
                        (_, __) =>
                            setState(() => _markerId = _route.markers.first.id),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'tsuper_app',
                      maxNativeZoom: 19,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      transitionBuilder:
                          (c, a) => FadeTransition(opacity: a, child: c),
                      child: PolylineLayer(
                        key: ValueKey('p-${_route.id}'),
                        polylines: [
                          Polyline(
                            points: _route.path,
                            color: AppColors.primary,
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                          ),
                        ],
                      ),
                    ),
                    AnimatedMarkerLayer(
                      markers:
                          _route.markers
                              .map(
                                (m) => AnimatedMarker(
                                  point: m.point,
                                  width: 80,
                                  height: 80,
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                  builder:
                                      (ctx, anim) => GestureDetector(
                                        onTap: () => _focusMarker(m),
                                        child: Opacity(
                                          opacity: anim.value,
                                          child: Transform.translate(
                                            offset: Offset(
                                              0,
                                              (1 - anim.value) * 10,
                                            ),
                                            child: _MapBadge(
                                              marker: m,
                                              selected: _markerId == m.id,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: _MapTag(title: 'Metro Manila', sub: 'Mock map'),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _ZoomPanel(
                    onIn: _zoomIn,
                    onOut: _zoomOut,
                    onFit: _fit,
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder:
                        (c, a) => FadeTransition(
                          opacity: a,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(a),
                            child: c,
                          ),
                        ),
                    child: _MapSheet(
                      key: ValueKey('${_route.id}-${sel?.id}'),
                      route: _route,
                      marker: sel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.showDriverActions) ...[
          const SizedBox(height: 8),
          const Text(
            'Driver focus mode',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.softInk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.gray200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.route_rounded,
              size: 14,
              color: selected ? Colors.white : AppColors.gray600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomPanel extends StatelessWidget {
  const _ZoomPanel({
    required this.onIn,
    required this.onOut,
    required this.onFit,
  });
  final VoidCallback onIn, onOut, onFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapBtn(icon: Symbols.add_rounded, onTap: onIn),
          const SizedBox(height: 3),
          _MapBtn(icon: Symbols.remove_rounded, onTap: onOut),
          const SizedBox(height: 3),
          _MapBtn(icon: Symbols.center_focus_strong_rounded, onTap: onFit),
        ],
      ),
    );
  }
}

class _MapBtn extends StatelessWidget {
  const _MapBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: AppColors.primary),
      ),
    );
  }
}

class _MapTag extends StatelessWidget {
  const _MapTag({required this.title, required this.sub});
  final String title, sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppColors.softInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapSheet extends StatelessWidget {
  const _MapSheet({super.key, required this.route, required this.marker});
  final MetroManilaRoute route;
  final MetroManilaMapMarkerSpec? marker;

  @override
  Widget build(BuildContext context) {
    final txt =
        marker == null
            ? 'Tap a marker to inspect stops.'
            : '${marker!.label} · ${_markerDescription(marker!.kind)}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  route.routeName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoTag(label: route.fromLabel),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Symbols.arrow_forward_rounded,
                  size: 12,
                  color: AppColors.muted,
                ),
              ),
              _InfoTag(label: route.toLabel),
              const Spacer(),
              _InfoTag(label: route.estimatedTravelTime),
              const SizedBox(width: 5),
              _InfoTag(label: route.estimatedFare, highlight: true),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            txt,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.softInk,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label, this.highlight = false});
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color:
            highlight ? AppColors.primary.withOpacity(0.08) : AppColors.gray100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: highlight ? AppColors.primary : AppColors.ink,
        ),
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.marker, required this.selected});
  final MetroManilaMapMarkerSpec marker;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final col = _markerColor(marker.kind, selected);
    final icon = _markerIcon(marker.kind);
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(selected ? 0.1 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: col,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 15, color: Colors.white),
          ),
          const SizedBox(height: 3),
          Text(
            marker.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

Color _markerColor(MetroManilaMapMarkerKind k, bool sel) {
  if (sel) return AppColors.primary;
  return switch (k) {
    MetroManilaMapMarkerKind.currentLocation => AppColors.gray600,
    MetroManilaMapMarkerKind.destination => AppColors.primary,
    MetroManilaMapMarkerKind.jeepney => AppColors.gray600,
    MetroManilaMapMarkerKind.terminal => AppColors.muted,
    MetroManilaMapMarkerKind.busStop => AppColors.muted,
  };
}

IconData _markerIcon(MetroManilaMapMarkerKind k) => switch (k) {
  MetroManilaMapMarkerKind.currentLocation => Symbols.my_location_rounded,
  MetroManilaMapMarkerKind.destination => Symbols.flag_rounded,
  MetroManilaMapMarkerKind.jeepney => Symbols.directions_bus_rounded,
  MetroManilaMapMarkerKind.terminal => Symbols.place_rounded,
  MetroManilaMapMarkerKind.busStop => Symbols.stop_circle_rounded,
};

String _markerDescription(MetroManilaMapMarkerKind k) => switch (k) {
  MetroManilaMapMarkerKind.currentLocation => 'Current location',
  MetroManilaMapMarkerKind.destination => 'Destination',
  MetroManilaMapMarkerKind.jeepney => 'Mock jeepney',
  MetroManilaMapMarkerKind.terminal => 'Terminal stop',
  MetroManilaMapMarkerKind.busStop => 'Bus stop',
};
