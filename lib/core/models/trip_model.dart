class TripModel {
  final String id;
  final String? userId;
  final String? driverId;
  final String routeId;
  final String origin;
  final String destination;
  final String fare;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime createdAt;

  TripModel({
    required this.id,
    this.userId,
    this.driverId,
    required this.routeId,
    required this.origin,
    required this.destination,
    required this.fare,
    required this.status,
    this.startTime,
    this.endTime,
    required this.createdAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      driverId: json['driver_id'] as String?,
      routeId: json['route_id'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      fare: json['fare'] as String,
      status: json['status'] as String,
      startTime:
          json['start_time'] != null
              ? DateTime.parse(json['start_time'] as String)
              : null,
      endTime:
          json['end_time'] != null
              ? DateTime.parse(json['end_time'] as String)
              : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'driver_id': driverId,
      'route_id': routeId,
      'origin': origin,
      'destination': destination,
      'fare': fare,
      'status': status,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  TripModel copyWith({
    String? id,
    String? userId,
    String? driverId,
    String? routeId,
    String? origin,
    String? destination,
    String? fare,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      routeId: routeId ?? this.routeId,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
