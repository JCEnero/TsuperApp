import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/google_map_widget.dart';
import 'models/jeepney.dart';
import 'services/jeepney_service.dart';
import 'widgets/filter_chips.dart';
import 'widgets/jeepney_bottom_sheet.dart';
import 'widgets/map_legend.dart';
import 'widgets/search_bar.dart' as custom_widgets;

class PassengerMapScreen extends StatefulWidget {
  const PassengerMapScreen({super.key});

  @override
  State<PassengerMapScreen> createState() => _PassengerMapScreenState();
}

class _PassengerMapScreenState extends State<PassengerMapScreen> {
  final JeepneyService _jeepneyService = JeepneyService();

  GoogleMapController? _mapController;
  Position? _userPosition;
  Jeepney? _selectedJeepney;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('[PassengerMapScreen] initState called');
    }
    _jeepneyService.initializeMockData();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onPositionAcquired(Position position) {
    if (kDebugMode) {
      print('[PassengerMapScreen] Position acquired: ${position.latitude}, ${position.longitude}');
    }
    if (mounted) {
      setState(() {
        _userPosition = position;
      });
      _updateMarkers();
    }
  }

  void _updateMarkers() {
    final jeepneys = _jeepneyService.jeepneys;
    final markers = <Marker>{};

    for (final jeepney in jeepneys) {
      final isSelected = _selectedJeepney?.id == jeepney.id;

      markers.add(
        Marker(
          markerId: MarkerId(jeepney.id),
          position: LatLng(jeepney.latitude, jeepney.longitude),
          onTap: () => _onJeepneyTapped(jeepney),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected
                ? BitmapDescriptor.hueAzure
                : _getStatusHue(jeepney.status),
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
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
    setState(() {
      _selectedJeepney = jeepney;
    });

    // Animate camera to jeepney
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(jeepney.latitude, jeepney.longitude),
          17.0,
        ),
      );
    }

    // Show bottom sheet
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => JeepneyBottomSheet(
            jeepney: jeepney,
            distanceFromUser: _calculateDistance(jeepney),
            onClose: () {
              setState(() {
                _selectedJeepney = null;
              });
              _updateMarkers();
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
        1000; // Convert to km
  }

  void _onFilterChanged(JeepneyFilter filter) {
    setState(() {
      _jeepneyService.setFilter(filter);
    });
    _updateMarkers();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _jeepneyService.setSearchQuery(query);
    });
    _updateMarkers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Google Map
          GoogleMapWidget(
            initialCameraPosition: null,
            markers: _markers,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            onPositionAcquired: _onPositionAcquired,
            showMyLocationFab: false,
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: custom_widgets.RouteSearchBar(
              onChanged: _onSearchChanged,
            ),
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
            child: MapLegend(),
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
}
