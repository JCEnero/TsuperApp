import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}

enum LocationServiceStatus { enabled, disabled }

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  LocationPermissionStatus? _permissionStatus;
  LocationServiceStatus? _serviceStatus;

  Position? get currentPosition => _currentPosition;
  LocationPermissionStatus? get permissionStatus => _permissionStatus;
  LocationServiceStatus? get serviceStatus => _serviceStatus;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _serviceStatus =
        serviceEnabled
            ? LocationServiceStatus.enabled
            : LocationServiceStatus.disabled;
    return serviceEnabled;
  }

  /// Request location permission
  Future<LocationPermissionStatus> requestLocationPermission() async {
    final PermissionStatus permission = await Permission.location.request();

    _permissionStatus = _mapPermissionStatus(permission);
    return _permissionStatus!;
  }

  /// Check current location permission status
  Future<LocationPermissionStatus> checkLocationPermission() async {
    final PermissionStatus permission = await Permission.location.status;
    _permissionStatus = _mapPermissionStatus(permission);
    return _permissionStatus!;
  }

  /// Open app settings for location permission
  Future<bool> openAppSettings() async {
    // Note: Platform-specific implementation required
    // For web, this is not supported
    return false;
  }

  /// Get current position
  Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      // Check if location service is enabled
      final bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceException('Location services are disabled.');
      }

      // Check permission
      final permissionStatus = await checkLocationPermission();
      if (permissionStatus == LocationPermissionStatus.denied) {
        final requestedStatus = await requestLocationPermission();
        if (requestedStatus == LocationPermissionStatus.denied ||
            requestedStatus == LocationPermissionStatus.permanentlyDenied) {
          throw LocationServiceException(
            'Location permission denied. Please enable it in settings.',
          );
        }
      } else if (permissionStatus ==
          LocationPermissionStatus.permanentlyDenied) {
        throw LocationServiceException(
          'Location permission permanently denied. Please enable it in settings.',
        );
      }

      // Get current position
      final LocationSettings locationSettings = LocationSettings(
        accuracy: accuracy,
      );

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      _currentPosition = position;
      return position;
    } catch (e) {
      if (e is LocationServiceException) {
        rethrow;
      }
      throw LocationServiceException('Failed to get current location: $e');
    }
  }

  /// Get last known position (faster, may be cached)
  Future<Position?> getLastKnownPosition() async {
    try {
      final Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _currentPosition = position;
      }
      return position;
    } catch (e) {
      throw LocationServiceException('Failed to get last known position: $e');
    }
  }

  /// Get location stream for real-time updates
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) {
        _currentPosition = position;
        return position;
      },
    );
  }

  /// Calculate distance between two coordinates in meters
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Calculate bearing between two coordinates
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  LocationPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      case PermissionStatus.denied:
        return LocationPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return LocationPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return LocationPermissionStatus.restricted;
      case PermissionStatus.limited:
        return LocationPermissionStatus.limited;
      case PermissionStatus.provisional:
        return LocationPermissionStatus.denied;
    }
  }

  /// Reset cached data
  void reset() {
    _currentPosition = null;
    _permissionStatus = null;
    _serviceStatus = null;
  }
}
