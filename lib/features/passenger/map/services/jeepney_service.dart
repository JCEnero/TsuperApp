import '../models/jeepney.dart';

enum JeepneyFilter { all, nearby, lessCrowded, available, full }

class JeepneyService {
  static final JeepneyService _instance = JeepneyService._internal();
  factory JeepneyService() => _instance;
  JeepneyService._internal();

  List<Jeepney> _jeepneys = [];
  JeepneyFilter _currentFilter = JeepneyFilter.all;
  String _searchQuery = '';
  List<String> _activeRouteIds = []; // Multiple routes for destination search

  List<Jeepney> get jeepneys => _getFilteredJeepneys();
  JeepneyFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  String? get activeRouteId =>
      _activeRouteIds.isEmpty ? null : _activeRouteIds.first;

  void initializeMockData() {
    // Mock coordinates removed — live data comes from Socket.IO backend.
    // The backend simulator provides real OSRM-based QC coordinates.
    // This method is kept as a no-op fallback in case the connection fails
    // and _jeepneys is empty — the map will simply show nothing until
    // the backend connects.
    _jeepneys = [];
  }

  List<Jeepney> _getFilteredJeepneys() {
    var filtered = _jeepneys;

    // Route filter — show jeepneys on any of the active routes
    if (_activeRouteIds.isNotEmpty) {
      filtered =
          filtered
              .where(
                (j) => j.routeId != null && _activeRouteIds.contains(j.routeId),
              )
              .toList();
    }

    // Search filter on route name
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (j) => j.routeName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    // Status filter
    switch (_currentFilter) {
      case JeepneyFilter.all:
        break;
      case JeepneyFilter.nearby:
        filtered = filtered.where((j) => j.isNearby).toList();
        break;
      case JeepneyFilter.lessCrowded:
        filtered = filtered.where((j) => j.occupancy <= 10).toList();
        break;
      case JeepneyFilter.available:
        filtered = filtered.where((j) => j.isAvailable).toList();
        break;
      case JeepneyFilter.full:
        filtered = filtered.where((j) => j.isFull).toList();
        break;
    }

    return filtered;
  }

  void setFilter(JeepneyFilter filter) {
    _currentFilter = filter;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  /// Filter map to show jeepneys on one or more routes.
  /// Pass empty list to show all jeepneys again.
  void setActiveRoute(String? routeId) {
    _activeRouteIds = routeId != null ? [routeId] : [];
  }

  void setActiveRoutes(List<String> routeIds) {
    _activeRouteIds = routeIds;
  }

  void clearRouteFilter() {
    _activeRouteIds = [];
  }

  void updateJeepneyLocation(String id, double latitude, double longitude) {
    final index = _jeepneys.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jeepneys[index] = _jeepneys[index].copyWith(
        latitude: latitude,
        longitude: longitude,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void updateJeepneyOccupancy(String id, int occupancy) {
    final index = _jeepneys.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jeepneys[index] = _jeepneys[index].copyWith(
        occupancy: occupancy,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void updateJeepneyStatus(String id, JeepneyStatus status) {
    final index = _jeepneys.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jeepneys[index] = _jeepneys[index].copyWith(
        status: status,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Updates or adds a jeepney from live Socket.IO data.
  void updateJeepneyFromLive(Jeepney jeepney) {
    final index = _jeepneys.indexWhere((j) => j.id == jeepney.id);
    if (index != -1) {
      _jeepneys[index] = jeepney;
    } else {
      _jeepneys.add(jeepney);
    }
  }

  Jeepney? getJeepneyById(String id) {
    try {
      return _jeepneys.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }
}
