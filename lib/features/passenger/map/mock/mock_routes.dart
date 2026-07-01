import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/route_info.dart';
import '../services/route_repository.dart';

/// Mock implementation of [RouteRepository] that returns pre-defined
/// LatLng paths for each jeepney route operating around QCU / Cubao /
/// SM Fairview (Quezon City, Philippines).
///
/// Coordinates follow real roads where possible so the polyline looks
/// believable on the map even during development.
///
/// ─── Migration path to Directions API ────────────────────────────────────
/// 1. Create `DirectionsRouteRepository implements RouteRepository`.
/// 2. In `findRoute`, call the Directions API and decode the encoded
///    polyline into a `List<LatLng>`.
/// 3. Wrap it in a `RouteInfo` and return it.
/// 4. In `PassengerMapScreen`, replace `MockRouteRepository()` with
///    `DirectionsRouteRepository(apiKey: ...)`.
/// No other file needs to change.
/// ─────────────────────────────────────────────────────────────────────────
class MockRouteRepository implements RouteRepository {
  static final List<RouteInfo> _routes = [
    // ── QCU → Cubao ──────────────────────────────────────────────────────
    RouteInfo(
      id: 'qcu-cubao',
      displayName: 'QCU – Cubao',
      origin: 'QCU (Quezon City University)',
      destination: 'Cubao',
      points: [
        // QCU campus gate area
        const LatLng(14.6500, 121.0430),
        const LatLng(14.6478, 121.0412),
        const LatLng(14.6455, 121.0390),
        // Along Batangas St.
        const LatLng(14.6430, 121.0360),
        const LatLng(14.6405, 121.0335),
        // Junction to EDSA
        const LatLng(14.6385, 121.0310),
        const LatLng(14.6360, 121.0280),
        // Along EDSA southbound
        const LatLng(14.6335, 121.0260),
        const LatLng(14.6310, 121.0245),
        const LatLng(14.6285, 121.0230),
        const LatLng(14.6260, 121.0218),
        // Approaching Cubao terminal
        const LatLng(14.6220, 121.0210),
        const LatLng(14.6195, 121.0205),
        // Cubao (Araneta Center)
        const LatLng(14.6177, 121.0510),
      ],
    ),

    // ── Cubao → QCU ──────────────────────────────────────────────────────
    RouteInfo(
      id: 'cubao-qcu',
      displayName: 'Cubao – QCU',
      origin: 'Cubao',
      destination: 'QCU (Quezon City University)',
      points: [
        // Cubao (Araneta Center)
        const LatLng(14.6177, 121.0510),
        const LatLng(14.6195, 121.0205),
        const LatLng(14.6220, 121.0210),
        // EDSA northbound
        const LatLng(14.6260, 121.0218),
        const LatLng(14.6285, 121.0230),
        const LatLng(14.6310, 121.0245),
        const LatLng(14.6335, 121.0260),
        const LatLng(14.6360, 121.0280),
        const LatLng(14.6385, 121.0310),
        // Back toward QCU
        const LatLng(14.6405, 121.0335),
        const LatLng(14.6430, 121.0360),
        const LatLng(14.6455, 121.0390),
        const LatLng(14.6478, 121.0412),
        // QCU campus gate
        const LatLng(14.6500, 121.0430),
      ],
    ),

    // ── QCU → SM Fairview ────────────────────────────────────────────────
    RouteInfo(
      id: 'qcu-sm-fairview',
      displayName: 'QCU – SM Fairview',
      origin: 'QCU (Quezon City University)',
      destination: 'SM City Fairview',
      points: [
        // QCU campus gate
        const LatLng(14.6500, 121.0430),
        const LatLng(14.6520, 121.0425),
        // Commonwealth Ave northbound
        const LatLng(14.6545, 121.0420),
        const LatLng(14.6580, 121.0415),
        const LatLng(14.6620, 121.0412),
        const LatLng(14.6660, 121.0408),
        const LatLng(14.6705, 121.0405),
        const LatLng(14.6755, 121.0400),
        const LatLng(14.6800, 121.0395),
        // Regalado Ave junction
        const LatLng(14.6850, 121.0390),
        const LatLng(14.6895, 121.0400),
        const LatLng(14.6930, 121.0415),
        const LatLng(14.6960, 121.0430),
        // SM Fairview
        const LatLng(14.6990, 121.0450),
        const LatLng(14.7010, 121.0455),
      ],
    ),

    // ── SM Fairview → QCU ────────────────────────────────────────────────
    RouteInfo(
      id: 'sm-fairview-qcu',
      displayName: 'SM Fairview – QCU',
      origin: 'SM City Fairview',
      destination: 'QCU (Quezon City University)',
      points: [
        // SM Fairview
        const LatLng(14.7010, 121.0455),
        const LatLng(14.6990, 121.0450),
        const LatLng(14.6960, 121.0430),
        const LatLng(14.6930, 121.0415),
        const LatLng(14.6895, 121.0400),
        // Commonwealth Ave southbound
        const LatLng(14.6850, 121.0390),
        const LatLng(14.6800, 121.0395),
        const LatLng(14.6755, 121.0400),
        const LatLng(14.6705, 121.0405),
        const LatLng(14.6660, 121.0408),
        const LatLng(14.6620, 121.0412),
        const LatLng(14.6580, 121.0415),
        const LatLng(14.6545, 121.0420),
        const LatLng(14.6520, 121.0425),
        // QCU campus gate
        const LatLng(14.6500, 121.0430),
      ],
    ),
  ];

  // Alias map: jeepney routeNames → route id
  static const Map<String, String> _routeNameAliases = {
    'qcu - cubao': 'qcu-cubao',
    'qcu-cubao': 'qcu-cubao',
    'cubao - qcu': 'cubao-qcu',
    'cubao-qcu': 'cubao-qcu',
    'qcu - sm fairview': 'qcu-sm-fairview',
    'qcu-sm fairview': 'qcu-sm-fairview',
    'qcu - sm': 'qcu-sm-fairview',
    'sm fairview - qcu': 'sm-fairview-qcu',
    'sm fairview-qcu': 'sm-fairview-qcu',
    'sm - qcu': 'sm-fairview-qcu',
    'fairview': 'qcu-sm-fairview',
    'cubao': 'qcu-cubao',
  };

  @override
  Future<RouteInfo?> findRoute(String query) async {
    if (query.trim().isEmpty) return null;

    final q = query.trim().toLowerCase();

    // 1. Exact alias match
    final aliasId = _routeNameAliases[q];
    if (aliasId != null) {
      return _routes.firstWhere((r) => r.id == aliasId);
    }

    // 2. Partial match on id or displayName
    try {
      return _routes.firstWhere(
        (r) =>
            r.id.contains(q) ||
            r.displayName.toLowerCase().contains(q) ||
            (r.origin?.toLowerCase().contains(q) ?? false) ||
            (r.destination?.toLowerCase().contains(q) ?? false),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<RouteInfo>> allRoutes() async => List.unmodifiable(_routes);
}
