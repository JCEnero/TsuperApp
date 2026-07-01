import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/route_info.dart';
import '../services/route_repository.dart';

/// Mock implementation of [RouteRepository] that returns pre-defined
/// LatLng paths for each jeepney route operating around QCU / Cubao /
/// SM Fairview (Quezon City, Philippines).
///
/// Route IDs match the backend simulator's QC_ROUTES keys so that
/// jeepney filtering works correctly when a passenger selects a route.
class MockRouteRepository implements RouteRepository {
  static final List<RouteInfo> _routes = [
    // ── Nova Bayan → SM Fairview ──────────────────────────────────────────
    RouteInfo(
      id: 'NOVA_BAYAN_TO_SM_FAIRVIEW',
      displayName: 'Nova Bayan → SM Fairview',
      origin: 'Nova Bayan Terminal',
      destination: 'SM City Fairview',
      points: [
        const LatLng(14.7567, 121.0437),
        const LatLng(14.7450, 121.0390),
        const LatLng(14.7350, 121.0320),
        const LatLng(14.7244, 121.0156),
      ],
    ),

    // ── SM Fairview → SM North EDSA ───────────────────────────────────────
    RouteInfo(
      id: 'SM_FAIRVIEW_TO_SM_NORTH',
      displayName: 'SM Fairview → SM North EDSA',
      origin: 'SM City Fairview',
      destination: 'SM North EDSA',
      points: [
        const LatLng(14.7244, 121.0156),
        const LatLng(14.7100, 121.0180),
        const LatLng(14.6900, 121.0240),
        const LatLng(14.6700, 121.0290),
        const LatLng(14.6560, 121.0322),
      ],
    ),

    // ── SM North EDSA → Cubao ─────────────────────────────────────────────
    RouteInfo(
      id: 'SM_NORTH_TO_CUBAO',
      displayName: 'SM North EDSA → Cubao',
      origin: 'SM North EDSA',
      destination: 'Araneta Cubao',
      points: [
        const LatLng(14.6560, 121.0322),
        const LatLng(14.6450, 121.0380),
        const LatLng(14.6350, 121.0430),
        const LatLng(14.6231, 121.0502),
      ],
    ),

    // ── Cubao → Nova Bayan (return) ───────────────────────────────────────
    RouteInfo(
      id: 'CUBAO_TO_NOVA_BAYAN',
      displayName: 'Cubao → Nova Bayan',
      origin: 'Araneta Cubao',
      destination: 'Nova Bayan Terminal',
      points: [
        const LatLng(14.6231, 121.0502),
        const LatLng(14.6500, 121.0430),
        const LatLng(14.6900, 121.0350),
        const LatLng(14.7200, 121.0250),
        const LatLng(14.7567, 121.0437),
      ],
    ),
  ];

  // Alias map so passengers can search naturally
  static const Map<String, String> _aliases = {
    'nova bayan': 'NOVA_BAYAN_TO_SM_FAIRVIEW',
    'nova bayan to sm fairview': 'NOVA_BAYAN_TO_SM_FAIRVIEW',
    'sm fairview to sm north': 'SM_FAIRVIEW_TO_SM_NORTH',
    'sm fairview': 'SM_FAIRVIEW_TO_SM_NORTH',
    'sm north to cubao': 'SM_NORTH_TO_CUBAO',
    'sm north': 'SM_NORTH_TO_CUBAO',
    'cubao to nova bayan': 'CUBAO_TO_NOVA_BAYAN',
    'cubao': 'CUBAO_TO_NOVA_BAYAN',
    'fairview': 'SM_FAIRVIEW_TO_SM_NORTH',
  };

  @override
  Future<RouteInfo?> findRoute(String query) async {
    if (query.trim().isEmpty) return null;
    final q = query.trim().toLowerCase();

    // 1. Alias match
    final aliasId = _aliases[q];
    if (aliasId != null) {
      return _routes.firstWhere((r) => r.id == aliasId);
    }

    // 2. Partial match on id, displayName, origin, destination
    try {
      return _routes.firstWhere(
        (r) =>
            r.id.toLowerCase().contains(q) ||
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
