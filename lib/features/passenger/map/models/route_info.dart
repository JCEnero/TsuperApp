import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents a resolved jeepney route with its full polyline path.
///
/// This model is intentionally source-agnostic: [points] can come from
/// a mock data set during development or from a Google Directions API
/// response in production — the rest of the app doesn't care.
class RouteInfo {
  const RouteInfo({
    required this.id,
    required this.displayName,
    required this.points,
    this.origin,
    this.destination,
  });

  /// Unique route identifier (matches jeepney routeName keys).
  final String id;

  /// Human-readable label shown in the route banner.
  final String displayName;

  /// Ordered list of coordinates that define the polyline path.
  /// Replace with decoded Directions API polyline points when going live.
  final List<LatLng> points;

  /// Optional human-readable origin label.
  final String? origin;

  /// Optional human-readable destination label.
  final String? destination;

  /// Convenience: bounding box for camera fitting.
  LatLngBounds? get bounds {
    if (points.isEmpty) return null;
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
