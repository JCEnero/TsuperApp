import 'dart:math';
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
import 'services/jeepney_socket_service.dart';
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

class _PassengerMapScreenState extends State<PassengerMapScreen>
    with TickerProviderStateMixin {
  // ── Services ───────────────────────────────────────────────────────────────
  final JeepneyService _jeepneyService = JeepneyService();
  final MarkerService _markerService = MarkerService();
  final JeepneySocketService _socketService = JeepneySocketService();
  final RouteRepository _routeRepository = MockRouteRepository();

  // ── Map state ──────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  Position? _userPosition;
  Jeepney? _selectedJeepney;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isConnected = false;

  // ── Live tracking animation state ──────────────────────────────────────────
  final Map<String, LatLng> _animatedPositions = {};
  final Map<String, AnimationController> _animControllers = {};
  final Map<String, Animation<double>> _latAnims = {};
  final Map<String, Animation<double>> _lngAnims = {};

  // ── Route state ────────────────────────────────────────────────────────────
  RouteInfo? _activeRoute;
  Set<Polyline> _liveRoutePolylines = {}; // OSRM route polylines from backend

  // ── UI state ───────────────────────────────────────────────────────────────
  bool _searchExpanded = false;
  MapLayerType _mapLayer = MapLayerType.normal;

  // ── Zoom limits ────────────────────────────────────────────────────────────
  static const double _kMinZoom = 8.0;
  static const double _kMaxZoom = 20.0;
  static const double _kZoomStep = 1.5;
  double _currentZoom = 16.0;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) print('[PassengerMapScreen] initState');
    _initializeSocketService();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    for (final ctrl in _animControllers.values) {
      ctrl.dispose();
    }
    _mapController?.dispose();
    super.dispose();
  }

  // ── Socket.IO live tracking ────────────────────────────────────────────────

  void _initializeSocketService() {
    _socketService.onConnectionChanged = (connected) {
      if (mounted) setState(() => _isConnected = connected);

      // Fall back to mock data if backend is unreachable
      if (!connected && _jeepneyService.jeepneys.isEmpty) {
        if (kDebugMode) print('[Map] Falling back to mock data');
        _jeepneyService.initializeMockData();
        _updateMarkers();
      }
    };

    // Initial snapshot — populate map immediately on connect
    _socketService.onSnapshot = (jeepneys) {
      if (!mounted) return;
      for (final jeepney in jeepneys) {
        _jeepneyService.updateJeepneyFromLive(jeepney);
        _animatedPositions[jeepney.id] = LatLng(
          jeepney.latitude,
          jeepney.longitude,
        );
      }
      _updateMarkers();
    };

    // Per-jeepney update — animate to new position
    _socketService.onJeepneyUpdate = (jeepney) {
      if (!mounted) return;
      _jeepneyService.updateJeepneyFromLive(jeepney);
      _animateLiveMarker(jeepney);
    };

    // OSRM route polylines from backend — draw on map
    _socketService.onRoutesReceived = (routes) {
      if (!mounted) return;
      _buildLivePolylines(routes);
    };

    _socketService.connect();
  }

  // ── Live marker animation ──────────────────────────────────────────────────

  void _animateLiveMarker(Jeepney jeepney) {
    final currentPos =
        _animatedPositions[jeepney.id] ??
        LatLng(jeepney.latitude, jeepney.longitude);
    final targetPos = LatLng(jeepney.latitude, jeepney.longitude);

    final dLat = currentPos.latitude - targetPos.latitude;
    final dLng = currentPos.longitude - targetPos.longitude;
    if (sqrt(dLat * dLat + dLng * dLng) < 0.00005) return;

    _animControllers[jeepney.id]?.dispose();

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final latAnim = Tween<double>(
      begin: currentPos.latitude,
      end: targetPos.latitude,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    final lngAnim = Tween<double>(
      begin: currentPos.longitude,
      end: targetPos.longitude,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    _animControllers[jeepney.id] = controller;
    _latAnims[jeepney.id] = latAnim;
    _lngAnims[jeepney.id] = lngAnim;

    controller.addListener(() {
      if (!mounted) return;
      _animatedPositions[jeepney.id] = LatLng(
        _latAnims[jeepney.id]!.value,
        _lngAnims[jeepney.id]!.value,
      );
      _updateMarkers();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animatedPositions[jeepney.id] = targetPos;
      }
    });

    controller.forward();
  }

  // ── OSRM live route polylines ──────────────────────────────────────────────

  void _buildLivePolylines(List<RouteData> routes) {
    final polylines = <Polyline>{};
    for (final route in routes) {
      final color = _hexToColor(route.color);
      final points = route.waypoints.map((wp) => LatLng(wp[0], wp[1])).toList();
      polylines.add(
        Polyline(
          polylineId: PolylineId('live_${route.id}'),
          points: points,
          color: color.withValues(alpha: 0.6),
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }
    if (mounted) setState(() => _liveRoutePolylines = polylines);
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  // ── Location / camera ──────────────────────────────────────────────────────

  void _onPositionAcquired(Position position) {
    if (!mounted) return;
    setState(() => _userPosition = position);
    _updateMarkers();
  }

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

  void _zoomIn() {
    if (_mapController == null) return;
    if (_currentZoom >= _kMaxZoom) return;
    _mapController!.animateCamera(CameraUpdate.zoomBy(_kZoomStep));
  }

  void _zoomOut() {
    if (_mapController == null) return;
    if (_currentZoom <= _kMinZoom) return;
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
    if (!mounted) return;
    final jeepneys = _jeepneyService.jeepneys;
    final markers = <Marker>{};

    for (final j in jeepneys) {
      final isSelected = _selectedJeepney?.id == j.id;
      final pos = _animatedPositions[j.id] ?? LatLng(j.latitude, j.longitude);
      final icon = await _markerService.getJeepneyMarker(
        status: j.status,
        heading: j.heading,
        size: isSelected ? 100.0 : 80.0,
      );
      markers.add(
        Marker(
          markerId: MarkerId(j.id),
          position: pos,
          rotation: j.heading,
          anchor: const Offset(0.5, 0.5),
          onTap: () => _onJeepneyTapped(j),
          icon: icon,
          infoWindow: InfoWindow(
            title: j.routeName,
            snippet: '${j.occupancy}/20 • ${j.status.displayName}',
          ),
        ),
      );
    }
    if (mounted) setState(() => _markers = markers);
  }

  // ── Jeepney tap ────────────────────────────────────────────────────────────

  void _onJeepneyTapped(Jeepney jeepney) {
    setState(() => _selectedJeepney = jeepney);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(jeepney.latitude, jeepney.longitude),
        17,
      ),
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
          _userPosition!.latitude,
          _userPosition!.longitude,
          j.latitude,
          j.longitude,
        ) /
        1000;
  }

  // ── Route visualisation ────────────────────────────────────────────────────

  void _onDestinationSelected(PlaceSuggestion dest) =>
      _resolveAndDrawRoute(dest.primaryText);

  Future<void> _resolveAndDrawRoute(String query) async {
    final route = await _routeRepository.findRoute(query);
    if (!mounted) return;
    if (route == null) {
      _clearRoute();
      return;
    }
    _applyRoute(route);
  }

  void _applyRoute(RouteInfo route) {
    // Filter jeepneys to only show ones on this route
    _jeepneyService.setActiveRoute(route.id);

    // Highlight matching live polyline, dim others
    _highlightLiveRoute(route.id);

    setState(() {
      _activeRoute = route;
      _polylines = _buildRoutePolylines(route);
    });

    final bounds = route.bounds;
    if (bounds != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 72));
    }

    _updateMarkers();
  }

  /// Dims all live route polylines except the selected one.
  void _highlightLiveRoute(String selectedRouteId) {
    final updated = <Polyline>{};
    for (final polyline in _liveRoutePolylines) {
      final isSelected = polyline.polylineId.value == 'live_$selectedRouteId';
      updated.add(
        polyline.copyWith(
          colorParam:
              isSelected
                  ? polyline.color.withValues(alpha: 0.9)
                  : polyline.color.withValues(alpha: 0.15),
          widthParam: isSelected ? 6 : 2,
        ),
      );
    }
    if (mounted) setState(() => _liveRoutePolylines = updated);
  }

  Set<Polyline> _buildRoutePolylines(RouteInfo route) => {
    Polyline(
      polylineId: PolylineId('${route.id}_halo'),
      points: route.points,
      color: AppColors.primary.withValues(alpha: 0.22),
      width: 18,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      zIndex: 1,
    ),
    Polyline(
      polylineId: PolylineId('${route.id}_line'),
      points: route.points,
      color: AppColors.primary,
      width: 7,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      zIndex: 2,
    ),
  };

  void _clearRoute() {
    if (_activeRoute == null && _polylines.isEmpty) return;

    // Restore all live polylines to full opacity
    final restored = <Polyline>{};
    for (final polyline in _liveRoutePolylines) {
      restored.add(
        polyline.copyWith(
          colorParam: polyline.color.withValues(alpha: 0.6),
          widthParam: 4,
        ),
      );
    }

    // Clear jeepney route filter — show all jeepneys again
    _jeepneyService.clearRouteFilter();

    setState(() {
      _activeRoute = null;
      _polylines = {};
      _liveRoutePolylines = restored;
    });

    _updateMarkers();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final bottomPad = mq.padding.bottom;

    // Combine user-selected route polylines + live OSRM route polylines
    final allPolylines = {..._liveRoutePolylines, ..._polylines};

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Full-screen map ────────────────────────────────────────────────
          Positioned.fill(
            child: GoogleMapWidget(
              initialCameraPosition: null,
              markers: _markers,
              polylines: allPolylines,
              mapType: _mapLayer.toGoogleMapType(),
              suppressCustomStyle: _mapLayer.showNativePOIs,
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

          // ── Top overlay: search card + legend ─────────────────────────────
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
                    onExpandedChanged:
                        (v) => setState(() => _searchExpanded = v),
                    currentLocationLabel:
                        _userPosition != null
                            ? 'Your current location'
                            : 'Locating…',
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child:
                      _searchExpanded
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

          // ── Live connection badge ──────────────────────────────────────────
          Positioned(
            top: topPad + 8,
            right: 16,
            child: _buildConnectionBadge(),
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

  Widget _buildConnectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            _isConnected
                ? Colors.green.withValues(alpha: 0.9)
                : Colors.orange.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isConnected ? Icons.wifi : Icons.wifi_off,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            _isConnected ? 'Live' : 'Offline',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
