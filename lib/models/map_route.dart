import 'package:latlong2/latlong.dart';

class MetroManilaRoute {
  const MetroManilaRoute({
    required this.id,
    required this.title,
    required this.fromLabel,
    required this.toLabel,
    required this.routeName,
    required this.estimatedTravelTime,
    required this.estimatedFare,
    required this.center,
    required this.zoom,
    required this.path,
    required this.markers,
  });

  final String id,
      title,
      fromLabel,
      toLabel,
      routeName,
      estimatedTravelTime,
      estimatedFare;
  final LatLng center;
  final double zoom;
  final List<LatLng> path;
  final List<MetroManilaMapMarkerSpec> markers;
}

class MetroManilaMapMarkerSpec {
  const MetroManilaMapMarkerSpec({
    required this.id,
    required this.label,
    required this.point,
    required this.kind,
  });
  final String id, label;
  final LatLng point;
  final MetroManilaMapMarkerKind kind;
}

enum MetroManilaMapMarkerKind {
  currentLocation,
  destination,
  jeepney,
  terminal,
  busStop,
}
