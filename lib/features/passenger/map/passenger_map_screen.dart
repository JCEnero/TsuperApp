import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/google_map_widget.dart';
import 'models/jeepney.dart';
import 'services/jeepney_service.dart';
import 'services/jeepney_socket_service.dart';
import 'widgets/filter_chips.dart';
import 'widgets/jeepney_bottom_sheet.dart';
import 'widgets/map_legend.dart';
import 'widgets/search_bar.dart' as custom_widgets;

class PassengerMapScreen extends StatefulWidget {
  const PassengerMapScreen({super.key});

  @override
  State<PassengerMapScreen> createState() => _PassengerMapScreenState();
}

class _PassengerMapScreenState extends State<PassengerMapScreen>
    with TickerProviderStateMixin {
  final JeepneyService _jeepneyService = JeepneyService();
  final JeepneySocketService _socketService = JeepneySocketService();

  GoogleMapController? _mapController;
  Position? _userPosition;
  Jeepney? _selectedJeepney;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isConnected = false;

  // Track current animated positions per jeepney id
  final Map<String, LatLng> _animatedPositions = {};

  // Animation controllers per jeepney
  final Map<String, AnimationController> _animControllers = {};
  final Map<String, Animation<double>> _latAnims = {};
  final Map<String, Animation<double>> _lngAnims = {};

  @override
  void initState() {
    super.initState();
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

  // ─── Socket.IO Setup ────────────────────────────────────────────────────────

  void _initializeSocketService() {
    _socketService.onConnectionChanged = (connected) {
      if (mounted) {
        setState(() => _isConnected = connected);
      }

      // If connection fails, fall back to mock data
      if (!connected && _jeepneyService.jeepneys.isEmpty) {
        if (kDebugMode) print('[Map] Falling back to mock data');
        _jeepneyService.initializeMockData();
        _updateMarkersFromService();
      }
    };

    // Initial snapshot — all jeepneys at once
    _socketService.onSnapshot = (jeepneys) {
      if (!mounted) return;
      for (final jeepney in jeepneys) {
        _jeepneyService.updateJeepneyFromLive(jeepney);
        _animatedPositions[jeepney.id] = LatLng(
          jeepney.latitude,
          jeepney.longitude,
        );
      }
      _updateMarkersFromService();
    };

    // Individual update — animate marker to new position
    _socketService.onJeepneyUpdate = (jeepney) {
      if (!mounted) return;
      _jeepneyService.updateJeepneyFromLive(jeepney);
      _animateMarker(jeepney);
    };

    // Route polylines — draw on map
    _socketService.onRoutesReceived = (routes) {
      if (!mounted) return;
      _buildPolylines(routes);
    };

    _socketService.connect();
  }

  // ─── Marker Animation ───────────────────────────────────────────────────────

  void _animateMarker(Jeepney jeepney) {
    final currentPos =
        _animatedPositions[jeepney.id] ??
        LatLng(jeepney.latitude, jeepney.longitude);
    final targetPos = LatLng(jeepney.latitude, jeepney.longitude);

    // Skip if barely moved (avoids unnecessary animation)
    final distance = _distance(currentPos, targetPos);
    if (distance < 0.00005) return;

    // Dispose old controller if exists
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
      _rebuildMarkers();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animatedPositions[jeepney.id] = targetPos;
      }
    });

    controller.forward();
  }

  double _distance(LatLng a, LatLng b) {
    final dLat = a.latitude - b.latitude;
    final dLng = a.longitude - b.longitude;
    return sqrt(dLat * dLat + dLng * dLng);
  }

  // ─── Polyline Drawing ───────────────────────────────────────────────────────

  void _buildPolylines(List<RouteData> routes) {
    final polylines = <Polyline>{};

    for (final route in routes) {
      final color = _hexToColor(route.color);
      final points = route.waypoints.map((wp) => LatLng(wp[0], wp[1])).toList();

      polylines.add(
        Polyline(
          polylineId: PolylineId(route.id),
          points: points,
          color: color.withValues(alpha: 0.7),
          width: 4,
          patterns: [],
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }

    if (mounted) {
      setState(() => _polylines = polylines);
    }
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  // ─── Markers ────────────────────────────────────────────────────────────────

  void _updateMarkersFromService() {
    _rebuildMarkers();
  }

  void _rebuildMarkers() {
    if (!mounted) return;
    final jeepneys = _jeepneyService.jeepneys;
    final markers = <Marker>{};

    for (final jeepney in jeepneys) {
      final isSelected = _selectedJeepney?.id == jeepney.id;
      final pos =
          _animatedPositions[jeepney.id] ??
          LatLng(jeepney.latitude, jeepney.longitude);

      markers.add(
        Marker(
          markerId: MarkerId(jeepney.id),
          position: pos,
          rotation: jeepney.heading,
          anchor: const Offset(0.5, 0.5),
          onTap: () => _onJeepneyTapped(jeepney),
          icon:
              isSelected
                  ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  )
                  : BitmapDescriptor.defaultMarkerWithHue(
                    _getStatusHue(jeepney.status),
                  ),
          infoWindow: InfoWindow(
            title: jeepney.routeName,
            snippet: '${jeepney.occupancy}/20 • ${jeepney.status.displayName}',
          ),
        ),
      );
    }

    setState(() => _markers = markers);
  }

  double _getStatusHue(JeepneyStatus status) {
    switch (status) {
      case JeepneyStatus.available:
        return BitmapDescriptor.hueGreen;
      case JeepneyStatus.onRoute:
        return BitmapDescriptor.hueBlue;
      case JeepneyStatus.full:
        return BitmapDescriptor.hueRed;
      case JeepneyStatus.onBreak:
        return BitmapDescriptor.hueOrange;
      case JeepneyStatus.maintenance:
        return BitmapDescriptor.hueViolet;
    }
  }

  void _onJeepneyTapped(Jeepney jeepney) {
    setState(() => _selectedJeepney = jeepney);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(jeepney.latitude, jeepney.longitude),
        17.0,
      ),
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => JeepneyBottomSheet(
            jeepney: jeepney,
            distanceFromUser: _calculateDistance(jeepney),
            onClose: () {
              setState(() => _selectedJeepney = null);
              _rebuildMarkers();
            },
          ),
    );
  }

  double? _calculateDistance(Jeepney jeepney) {
    if (_userPosition == null) return null;
    return Geolocator.distanceBetween(
          _userPosition!.latitude,
          _userPosition!.longitude,
          jeepney.latitude,
          jeepney.longitude,
        ) /
        1000;
  }

  void _onPositionAcquired(Position position) {
    if (mounted) setState(() => _userPosition = position);
  }

  void _onFilterChanged(JeepneyFilter filter) {
    setState(() => _jeepneyService.setFilter(filter));
    _rebuildMarkers();
  }

  void _onSearchChanged(String query) {
    setState(() => _jeepneyService.setSearchQuery(query));
    _rebuildMarkers();
  }

  void _recenterToUser() {
    if (_userPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_userPosition!.latitude, _userPosition!.longitude),
          16.0,
        ),
      );
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Google Map with live markers + route polylines
          GoogleMapWidget(
            initialCameraPosition: const CameraPosition(
              target: LatLng(14.6937, 121.0200), // Quezon City center
              zoom: 13.0,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              setState(() => _mapController = controller);
            },
            onPositionAcquired: _onPositionAcquired,
            showMyLocationFab: false,
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: custom_widgets.RouteSearchBar(onChanged: _onSearchChanged),
          ),

          // Filter Chips
          Positioned(
            top: MediaQuery.of(context).padding.top + 72,
            left: 0,
            right: 0,
            child: FilterChips(
              selectedFilter: _jeepneyService.currentFilter,
              onFilterChanged: _onFilterChanged,
            ),
          ),

          // Legend
          Positioned(
            top: MediaQuery.of(context).padding.top + 128,
            left: 16,
            child: const MapLegend(),
          ),

          // Connection status indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 128,
            right: 16,
            child: _buildConnectionBadge(),
          ),

          // Recenter Button
          Positioned(
            right: 16,
            bottom: 80,
            child: FloatingActionButton(
              heroTag: 'recenter_fab',
              mini: true,
              onPressed: _recenterToUser,
              backgroundColor: Colors.white,
              elevation: 4,
              child: const Icon(
                Icons.center_focus_strong_rounded,
                color: AppColors.primary,
                size: 24,
              ),
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
