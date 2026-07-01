import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/google_map_widget.dart';
import 'mock/mock_routes.dart';
import 'models/jeepney.dart';
import 'models/place_suggestion.dart';
import 'models/route_info.dart';
import 'services/jeepney_service.dart';
import 'services/marker_service.dart';
import 'services/route_repository.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/floating_action_button_group.dart';
import 'widgets/jeepney_bottom_sheet.dart';
import 'widgets/layer_selector_sheet.dart';
import 'widgets/map_legend.dart';
import 'widgets/route_search_sheet.dart';

class PassengerMapScreen extends StatefulWidget {
  const PassengerMapScreen({super.key});

  @override
  State<PassengerMapScreen> createState() => _PassengerMapScreenState();
}

class _PassengerMapScreenState extends State<PassengerMapScreen> {
  // ── Services ───────────────────────────────────────────────────────────────
  final JeepneyService _jeepneyService = JeepneyService();
  final MarkerService _markerService = MarkerService();
  final RouteRepository _routeRepository = MockRouteRepository();

  // ── Map state ──────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  Position? _userPosition;
  Jeepney? _selectedJeepney;
  Set<Marker> _markers = {};

  // ── Route state ────────────────────────────────────────────────────────────
  RouteInfo? _activeRoute;
  Set<Polyline> _polylines = {};

  // ── UI state ───────────────────────────────────────────────────────────────
  bool _searchExpanded = false;
  MapLayerType _mapLayer = MapLayerType.normal;

  // ── Zoom limits ────────────────────────────────────────────────────────────
  static const double _kMinZoom = 8.0;
  static const double _kMaxZoom = 20.0;
  static const double _kZoomStep = 1.5;

  // Tracks live zoom level, kept in sync by onCameraMove.
  // Used only for clamping — never used as the source of truth for direction.
  double _currentZoom = 16.0;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) print('[PassengerMapScreen] initState');
    _jeepneyService.initializeMockData();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ── Location / camera ──────────────────────────────────────────────────────

  void _onPositionAcquired(Position position) {
    if (!mounted) return;
    setState(() => _userPosition = position);
    _updateMarkers();
  }

  /// Keeps _currentZoom in sync with whatever the map is actually showing.
  /// This is the ONLY correct way to track zoom — reading it after animateCamera
  /// is unreliable due to async race conditions.
  void _onCameraMove(CameraPosition pos) {
    _currentZoom = pos.zoom;
  }

  void _locateMe() {
    if (_userPosition == null || _mapController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available yet. Please wait…'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // Smooth eased camera move — no abrupt jumps.
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          zoom: 16.0,
          tilt: 0,
          bearing: 0,
        ),
      ),
    );
  }

  /// Zoom in by a fixed step.
  ///
  /// Uses [CameraUpdate.zoomBy] so the SDK applies the delta relative to
  /// the *live* camera zoom — no async getLatLng, no stale state reads,
  /// no race conditions. Direction is always correct.
  void _zoomIn() {
    if (_mapController == null) return;
    if (_currentZoom >= _kMaxZoom) return; // already at ceiling
    _mapController!.animateCamera(CameraUpdate.zoomBy(_kZoomStep));
  }

  /// Zoom out by a fixed step.
  void _zoomOut() {
    if (_mapController == null) return;
    if (_currentZoom <= _kMinZoom) return; // already at floor
    _mapController!.animateCamera(CameraUpdate.zoomBy(-_kZoomStep));
  }

  // ── Layer selector ─────────────────────────────────────────────────────────

  void _openLayers() {
    showLayerSelectorSheet(
      context: context,
      current: _mapLayer,
      onSelected: (layer) => setState(() => _mapLayer = layer),
    );
  }

  // ── Filter ─────────────────────────────────────────────────────────────────

  void _openFilter() {
    showFilterSheet(
      context: context,
      current: _jeepneyService.currentFilter,
      onChanged: (f) {
        setState(() => _jeepneyService.setFilter(f));
        _updateMarkers();
      },
    );
  }

  int get _activeFilterCount =>
      _jeepneyService.currentFilter == JeepneyFilter.all ? 0 : 1;

  // ── Markers ────────────────────────────────────────────────────────────────

  Future<void> _updateMarkers() async {
    final jeepneys = _jeepneyService.jeepneys;
    final markers = <Marker>{};
    for (final j in jeepneys) {
      final isSelected = _selectedJeepney?.id == j.id;
      final icon = await _markerService.getJeepneyMarker(
        status: j.status,
        heading: j.heading,
        size: isSelected ? 100.0 : 80.0,
      );
      markers.add(Marker(
        markerId: MarkerId(j.id),
        position: LatLng(j.latitude, j.longitude),
        onTap: () => _onJeepneyTapped(j),
        icon: icon,
      ));
    }
    if (mounted) setState(() => _markers = markers);
  }

  // ── Jeepney tap ────────────────────────────────────────────────────────────

  void _onJeepneyTapped(Jeepney jeepney) {
    setState(() => _selectedJeepney = jeepney);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(jeepney.latitude, jeepney.longitude), 17),
    );
    JeepneyBottomSheet.show(
      context,
      jeepney: jeepney,
      distanceFromUser: _calculateDistance(jeepney),
      onClose: () {
        setState(() => _selectedJeepney = null);
        _updateMarkers();
      },
    );
  }

  double? _calculateDistance(Jeepney j) {
    if (_userPosition == null) return null;
    return Geolocator.distanceBetween(
          _userPosition!.latitude, _userPosition!.longitude,
          j.latitude, j.longitude) /
        1000;
  }

  // ── Route visualisation ────────────────────────────────────────────────────

  void _onDestinationSelected(PlaceSuggestion dest) =>
      _resolveAndDrawRoute(dest.primaryText);

  Future<void> _resolveAndDrawRoute(String query) async {
    final route = await _routeRepository.findRoute(query);
    if (!mounted) return;
    if (route == null) { _clearRoute(); return; }
    _applyRoute(route);
  }

  void _applyRoute(RouteInfo route) {
    setState(() {
      _activeRoute = route;
      _polylines = _buildPolylines(route);
    });
    final bounds = route.bounds;
    if (bounds != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 72));
    }
  }

  Set<Polyline> _buildPolylines(RouteInfo route) => {
        Polyline(
          polylineId: PolylineId('${route.id}_halo'),
          points: route.points,
          color: AppColors.primary.withValues(alpha: 0.22),
          width: 18,
          startCap: Cap.roundCap, endCap: Cap.roundCap,
          jointType: JointType.round, zIndex: 1,
        ),
        Polyline(
          polylineId: PolylineId('${route.id}_line'),
          points: route.points,
          color: AppColors.primary,
          width: 7,
          startCap: Cap.roundCap, endCap: Cap.roundCap,
          jointType: JointType.round, zIndex: 2,
        ),
      };

  void _clearRoute() {
    if (_activeRoute == null && _polylines.isEmpty) return;
    setState(() { _activeRoute = null; _polylines = {}; });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final bottomPad = mq.padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Full-screen map ────────────────────────────────────────────────
          Positioned.fill(
            child: GoogleMapWidget(
              initialCameraPosition: null,
              markers: _markers,
              polylines: _polylines,
              mapType: _mapLayer.toGoogleMapType(),
              suppressCustomStyle: _mapLayer.showNativePOIs,
              // Disable all default Google UI — we use custom controls
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              onCameraMove: _onCameraMove,
              onMapCreated: (c) => setState(() => _mapController = c),
              onPositionAcquired: _onPositionAcquired,
              showMyLocationFab: false,
            ),
          ),

          // ── Top overlay: search card + chips/legend ────────────────────────
          Positioned(
            top: topPad + 8,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RouteSearchSheet(
                    onDestinationSelected: _onDestinationSelected,
                    onRouteCleared: _clearRoute,
                    onExpandedChanged: (v) =>
                        setState(() => _searchExpanded = v),
                    currentLocationLabel: _userPosition != null
                        ? 'Your current location'
                        : 'Locating…',
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _searchExpanded
                      ? const SizedBox.shrink()
                      : const Padding(
                          key: ValueKey('legend'),
                          padding: EdgeInsets.only(left: 16, top: 4),
                          child: MapLegend(),
                        ),
                ),
              ],
            ),
          ),

          // ── Right-side vertical control group ──────────────────────────────
          Positioned(
            right: 16,
            bottom: bottomPad + 90,
            child: MapControlGroup(
              onLocate: _locateMe,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onLayers: _openLayers,
              locateEnabled: _userPosition != null,
            ),
          ),

          // ── Bottom-left filter pill ────────────────────────────────────────
          Positioned(
            left: 16,
            bottom: bottomPad + 90,
            child: MapFilterButton(
              onTap: _openFilter,
              activeCount: _activeFilterCount,
            ),
          ),
        ],
      ),
    );
  }
}
