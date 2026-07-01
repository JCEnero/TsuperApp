import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    super.key,
    this.initialCameraPosition,
    this.onMapCreated,
    this.onCameraMove,
    this.onPositionAcquired,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = false,
    this.zoomControlsEnabled = false,
    this.compassEnabled = true,
    this.mapToolbarEnabled = false,
    this.padding = EdgeInsets.zero,
    this.markers = const {},
    this.polygons = const {},
    this.polylines = const {},
    this.circles = const {},
    this.minMaxZoomPreference = const MinMaxZoomPreference(2.0, 22.0),
    this.showMyLocationFab = true,
  });

  final CameraPosition? initialCameraPosition;
  final Function(GoogleMapController)? onMapCreated;
  final Function(CameraPosition)? onCameraMove;
  final Function(Position)? onPositionAcquired;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final EdgeInsets padding;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final MinMaxZoomPreference minMaxZoomPreference;
  final bool showMyLocationFab;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isMovingToLocation = false;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('[GoogleMapWidget] initState called');
    }
    _loadMapStyle();
    _initializeLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      setState(() => _isLoading = true);

      if (kDebugMode) {
        print('[GoogleMapWidget] Starting location initialization...');
      }

      // Check if location service is enabled
      final bool serviceEnabled =
          await _locationService.isLocationServiceEnabled();
      if (kDebugMode) {
        print('[GoogleMapWidget] Location service enabled: $serviceEnabled');
      }
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable GPS.';
          _isLoading = false;
        });
        return;
      }

      // Check permission
      final permissionStatus = await _locationService.checkLocationPermission();
      if (kDebugMode) {
        print('[GoogleMapWidget] Permission status: $permissionStatus');
      }
      if (permissionStatus == LocationPermissionStatus.denied) {
        final requestedStatus =
            await _locationService.requestLocationPermission();
        if (kDebugMode) {
          print(
            '[GoogleMapWidget] Requested permission status: $requestedStatus',
          );
        }
        if (requestedStatus == LocationPermissionStatus.denied) {
          setState(() {
            _errorMessage =
                'Location permission denied. Please enable it to see your location.';
            _isLoading = false;
          });
          return;
        } else if (requestedStatus ==
            LocationPermissionStatus.permanentlyDenied) {
          setState(() {
            _errorMessage =
                'Location permission permanently denied. Please enable it in app settings.';
            _isLoading = false;
          });
          return;
        }
      } else if (permissionStatus ==
          LocationPermissionStatus.permanentlyDenied) {
        setState(() {
          _errorMessage =
              'Location permission permanently denied. Please enable it in app settings.';
          _isLoading = false;
        });
        return;
      }

      // Get current position with timeout
      if (kDebugMode) {
        print('[GoogleMapWidget] Getting current position...');
      }
      final position = await _locationService.getCurrentPosition().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Location request timed out after 15 seconds');
        },
      );
      if (kDebugMode) {
        print(
          '[GoogleMapWidget] Position acquired: ${position.latitude}, ${position.longitude}',
        );
      }
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // Notify parent widget that position was acquired
      if (widget.onPositionAcquired != null) {
        widget.onPositionAcquired!(position);
      }

      // Move camera to user location
      if (_mapController != null) {
        if (kDebugMode) {
          print('[GoogleMapWidget] Moving camera to location...');
        }
        _moveToCurrentLocation();
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('[GoogleMapWidget] Timeout error: $e');
      }
      setState(() {
        _errorMessage =
            'Location request timed out. Please check your GPS and try again.';
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('[GoogleMapWidget] Error: $e');
      }
      setState(() {
        _errorMessage = 'Failed to get location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (_currentPosition == null || _mapController == null) return;

    setState(() => _isMovingToLocation = true);

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 16.0,
        ),
      ),
    );

    setState(() => _isMovingToLocation = false);
  }

  Future<void> _handleMyLocationPressed() async {
    if (_isMovingToLocation) return;

    // Refresh location
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() => _currentPosition = position);
      await _moveToCurrentLocation();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  Future<void> _openAppSettings() async {
    await _locationService.openAppSettings();
  }

  Future<void> _loadMapStyle() async {
    try {
      final String styleString = await rootBundle.loadString('assets/map_style.json');
      setState(() {
        _mapStyle = styleString;
      });
    } catch (e) {
      if (kDebugMode) {
        print('[GoogleMapWidget] Error loading map style: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              widget.initialCameraPosition ??
              CameraPosition(
                target: LatLng(
                  _currentPosition?.latitude ?? 14.5995,
                  _currentPosition?.longitude ?? 120.9842,
                ),
                zoom: 16.0,
              ),
          onMapCreated: (controller) {
            _mapController = controller;
            if (widget.onMapCreated != null) {
              widget.onMapCreated!(controller);
            }
            if (_currentPosition != null) {
              _moveToCurrentLocation();
            }
          },
          onCameraMove: widget.onCameraMove,
          myLocationEnabled: widget.myLocationEnabled,
          myLocationButtonEnabled: widget.myLocationButtonEnabled,
          zoomControlsEnabled: widget.zoomControlsEnabled,
          compassEnabled: widget.compassEnabled,
          mapToolbarEnabled: widget.mapToolbarEnabled,
          padding: widget.padding,
          markers: widget.markers,
          polygons: widget.polygons,
          polylines: widget.polylines,
          circles: widget.circles,
          minMaxZoomPreference: widget.minMaxZoomPreference,
          style: _mapStyle,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
        if (widget.showMyLocationFab)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'my_location_fab',
              mini: true,
              onPressed: _isMovingToLocation ? null : _handleMyLocationPressed,
              backgroundColor: Colors.white,
              elevation: 4,
              child: Icon(
                Symbols.my_location_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Getting your location...',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.softInk,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.location_off_rounded,
                size: 48,
                color: AppColors.gray600,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.softInk,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _initializeLocation,
                icon: const Icon(Symbols.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              if (_errorMessage!.contains('settings'))
                TextButton.icon(
                  onPressed: _openAppSettings,
                  icon: const Icon(Symbols.settings_rounded),
                  label: const Text('Open Settings'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
