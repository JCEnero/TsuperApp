class Jeepney {
  const Jeepney({
    required this.id,
    required this.routeName,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.occupancy,
    required this.driverName,
    required this.status,
    required this.lastUpdated,
    this.routeId,
    this.eta,
  });

  final String id;
  final String routeName;

  /// Backend route ID (e.g. 'NOVA_BAYAN_TO_SM_FAIRVIEW').
  /// Used to filter jeepneys by selected route.
  final String? routeId;

  final double latitude;
  final double longitude;
  final double heading;
  final int occupancy;
  final String driverName;
  final JeepneyStatus status;
  final DateTime lastUpdated;

  /// Estimated time of arrival in minutes (null = unknown)
  final int? eta;

  Jeepney copyWith({
    String? id,
    String? routeName,
    String? routeId,
    double? latitude,
    double? longitude,
    double? heading,
    int? occupancy,
    String? driverName,
    JeepneyStatus? status,
    DateTime? lastUpdated,
    int? eta,
  }) {
    return Jeepney(
      id: id ?? this.id,
      routeName: routeName ?? this.routeName,
      routeId: routeId ?? this.routeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heading: heading ?? this.heading,
      occupancy: occupancy ?? this.occupancy,
      driverName: driverName ?? this.driverName,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      eta: eta ?? this.eta,
    );
  }

  double get occupancyPercentage => occupancy / 20.0;

  bool get isAvailable => status == JeepneyStatus.available;
  bool get isFull => occupancy >= 20;
  bool get isNearby => false;
}

enum JeepneyStatus { available, onRoute, full, onBreak, maintenance }

extension JeepneyStatusExtension on JeepneyStatus {
  String get displayName {
    switch (this) {
      case JeepneyStatus.available:
        return 'Available';
      case JeepneyStatus.onRoute:
        return 'On Route';
      case JeepneyStatus.full:
        return 'Full';
      case JeepneyStatus.onBreak:
        return 'On Break';
      case JeepneyStatus.maintenance:
        return 'Maintenance';
    }
  }
}
