import '../models/route_info.dart';

/// Abstract contract for resolving a route query into a [RouteInfo].
///
/// Implementations:
///   - [MockRouteRepository]  : uses hard-coded coordinates (current)
///   - DirectionsRouteRepository (future): calls Google Directions API
///
/// To switch to the real API, create a new class that implements this
/// interface and inject it in [PassengerMapScreen] — no other code changes.
abstract class RouteRepository {
  /// Returns a [RouteInfo] whose [RouteInfo.displayName] or [RouteInfo.id]
  /// matches [query] (case-insensitive partial match), or `null` if none found.
  Future<RouteInfo?> findRoute(String query);

  /// Returns all known routes. Used to populate suggestions.
  Future<List<RouteInfo>> allRoutes();
}
