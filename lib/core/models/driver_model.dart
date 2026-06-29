class DriverModel {
  final String id;
  final String userId;
  final String plateNumber;
  final String vehicleNumber;
  final String? assignedRoute;
  final String status;
  final double? currentLatitude;
  final double? currentLongitude;
  final int occupancy;
  final DateTime createdAt;

  DriverModel({
    required this.id,
    required this.userId,
    required this.plateNumber,
    required this.vehicleNumber,
    this.assignedRoute,
    required this.status,
    this.currentLatitude,
    this.currentLongitude,
    required this.occupancy,
    required this.createdAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plateNumber: json['plate_number'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      assignedRoute: json['assigned_route'] as String?,
      status: json['status'] as String,
      currentLatitude: (json['current_latitude'] as num?)?.toDouble(),
      currentLongitude: (json['current_longitude'] as num?)?.toDouble(),
      occupancy: json['occupancy'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plate_number': plateNumber,
      'vehicle_number': vehicleNumber,
      'assigned_route': assignedRoute,
      'status': status,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'occupancy': occupancy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  DriverModel copyWith({
    String? id,
    String? userId,
    String? plateNumber,
    String? vehicleNumber,
    String? assignedRoute,
    String? status,
    double? currentLatitude,
    double? currentLongitude,
    int? occupancy,
    DateTime? createdAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      assignedRoute: assignedRoute ?? this.assignedRoute,
      status: status ?? this.status,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      occupancy: occupancy ?? this.occupancy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
