import '../models/jeepney.dart';

enum JeepneyFilter { all, nearby, lessCrowded, available, full }

class JeepneyService {
  static final JeepneyService _instance = JeepneyService._internal();
  factory JeepneyService() => _instance;
  JeepneyService._internal();

  List<Jeepney> _jeepneys = [];
  JeepneyFilter _currentFilter = JeepneyFilter.all;
  String _searchQuery = '';

  List<Jeepney> get jeepneys => _getFilteredJeepneys();
  JeepneyFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  void initializeMockData() {
    _jeepneys = _getMockJeepneys();
  }

  List<Jeepney> _getFilteredJeepneys() {
    var filtered = _jeepneys;

    // Apply search filter
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

    // Apply category filter
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

  Jeepney? getJeepneyById(String id) {
    try {
      return _jeepneys.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Jeepney> _getMockJeepneys() {
    final now = DateTime.now();
    return [
      Jeepney(
        id: 'j1',
        routeName: 'QCU - Cubao',
        latitude: 14.5995,
        longitude: 120.9842,
        heading: 45.0,
        occupancy: 12,
        driverName: 'Juan Dela Cruz',
        status: JeepneyStatus.onRoute,
        lastUpdated: now,
        eta: 4,
      ),
      Jeepney(
        id: 'j2',
        routeName: 'QCU - SM Fairview',
        latitude: 14.6020,
        longitude: 120.9870,
        heading: 90.0,
        occupancy: 8,
        driverName: 'Maria Santos',
        status: JeepneyStatus.available,
        lastUpdated: now,
        eta: 2,
      ),
      Jeepney(
        id: 'j3',
        routeName: 'Cubao - QCU',
        latitude: 14.5970,
        longitude: 120.9810,
        heading: 180.0,
        occupancy: 18,
        driverName: 'Pedro Reyes',
        status: JeepneyStatus.onRoute,
        lastUpdated: now,
        eta: 7,
      ),
      Jeepney(
        id: 'j4',
        routeName: 'SM Fairview - QCU',
        latitude: 14.6050,
        longitude: 120.9900,
        heading: 270.0,
        occupancy: 5,
        driverName: 'Ana Garcia',
        status: JeepneyStatus.available,
        lastUpdated: now,
        eta: 1,
      ),
      Jeepney(
        id: 'j5',
        routeName: 'QCU - Cubao',
        latitude: 14.5960,
        longitude: 120.9860,
        heading: 135.0,
        occupancy: 20,
        driverName: 'Carlos Mendoza',
        status: JeepneyStatus.full,
        lastUpdated: now,
        eta: 10,
      ),
      Jeepney(
        id: 'j6',
        routeName: 'QCU - SM Fairview',
        latitude: 14.6030,
        longitude: 120.9830,
        heading: 315.0,
        occupancy: 15,
        driverName: 'Elena Rodriguez',
        status: JeepneyStatus.onRoute,
        lastUpdated: now,
        eta: 5,
      ),
      Jeepney(
        id: 'j7',
        routeName: 'Cubao - QCU',
        latitude: 14.5985,
        longitude: 120.9885,
        heading: 0.0,
        occupancy: 3,
        driverName: 'Miguel Torres',
        status: JeepneyStatus.available,
        lastUpdated: now,
        eta: 3,
      ),
      Jeepney(
        id: 'j8',
        routeName: 'SM Fairview - QCU',
        latitude: 14.6005,
        longitude: 120.9795,
        heading: 225.0,
        occupancy: 19,
        driverName: 'Sofia Hernandez',
        status: JeepneyStatus.full,
        lastUpdated: now,
        eta: 12,
      ),
      Jeepney(
        id: 'j9',
        routeName: 'QCU - Cubao',
        latitude: 14.5945,
        longitude: 120.9895,
        heading: 60.0,
        occupancy: 7,
        driverName: 'Ramon Villanueva',
        status: JeepneyStatus.onBreak,
        lastUpdated: now,
      ),
      Jeepney(
        id: 'j10',
        routeName: 'QCU - SM Fairview',
        latitude: 14.6015,
        longitude: 120.9765,
        heading: 300.0,
        occupancy: 11,
        driverName: 'Luz Bautista',
        status: JeepneyStatus.onRoute,
        lastUpdated: now,
        eta: 6,
      ),
    ];
  }
}
