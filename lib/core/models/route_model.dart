class RouteModel {
  final String id;
  final String routeName;
  final String origin;
  final String destination;
  final String estimatedFare;
  final String estimatedTime;
  final DateTime createdAt;

  RouteModel({
    required this.id,
    required this.routeName,
    required this.origin,
    required this.destination,
    required this.estimatedFare,
    required this.estimatedTime,
    required this.createdAt,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      routeName: json['route_name'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      estimatedFare: json['estimated_fare'] as String,
      estimatedTime: json['estimated_time'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_name': routeName,
      'origin': origin,
      'destination': destination,
      'estimated_fare': estimatedFare,
      'estimated_time': estimatedTime,
      'created_at': createdAt.toIso8601String(),
    };
  }

  RouteModel copyWith({
    String? id,
    String? routeName,
    String? origin,
    String? destination,
    String? estimatedFare,
    String? estimatedTime,
    DateTime? createdAt,
  }) {
    return RouteModel(
      id: id ?? this.id,
      routeName: routeName ?? this.routeName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
