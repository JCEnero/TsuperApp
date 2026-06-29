class PassengerModel {
  final String id;
  final String userId;
  final List<String>? favoritePlaces;
  final List<String>? recentRoutes;
  final DateTime createdAt;

  PassengerModel({
    required this.id,
    required this.userId,
    this.favoritePlaces,
    this.recentRoutes,
    required this.createdAt,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      favoritePlaces:
          (json['favorite_places'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      recentRoutes:
          (json['recent_routes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'favorite_places': favoritePlaces,
      'recent_routes': recentRoutes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PassengerModel copyWith({
    String? id,
    String? userId,
    List<String>? favoritePlaces,
    List<String>? recentRoutes,
    DateTime? createdAt,
  }) {
    return PassengerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
      recentRoutes: recentRoutes ?? this.recentRoutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
