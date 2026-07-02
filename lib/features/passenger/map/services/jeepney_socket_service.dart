import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/jeepney.dart';

/// Route polyline data received from the backend.
class RouteData {
  final String id;
  final String name;
  final String color;
  final List<List<double>> waypoints; // [[lat, lng], ...]
  final double distanceKm;
  final double durationMin;

  const RouteData({
    required this.id,
    required this.name,
    required this.color,
    required this.waypoints,
    required this.distanceKm,
    required this.durationMin,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      waypoints:
          (json['waypoints'] as List<dynamic>)
              .map(
                (wp) =>
                    (wp as List<dynamic>)
                        .map((v) => (v as num).toDouble())
                        .toList(),
              )
              .toList(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationMin: (json['durationMin'] as num).toDouble(),
    );
  }
}

/// Converts backend JSON to a Jeepney model.
Jeepney _jeepneyFromJson(Map<String, dynamic> json) {
  return Jeepney(
    id: json['id'] as String,
    routeName: json['routeName'] as String,
    routeId: json['routeId'] as String?,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    heading: (json['heading'] as num).toDouble(),
    occupancy: (json['occupancy'] as num).toInt(),
    driverName: json['driverName'] as String,
    status: _parseStatus(json['status'] as String),
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );
}

JeepneyStatus _parseStatus(String status) {
  switch (status) {
    case 'available':
      return JeepneyStatus.available;
    case 'full':
      return JeepneyStatus.full;
    case 'on_break':
      return JeepneyStatus.onBreak;
    case 'maintenance':
      return JeepneyStatus.maintenance;
    case 'on_route':
    default:
      return JeepneyStatus.onRoute;
  }
}

/// JeepneySocketService
///
/// Connects to the backend Socket.IO server and listens for live
/// jeepney position updates. Replaces the static mock data.
///
/// Usage:
///   final service = JeepneySocketService();
///   service.onJeepneyUpdate = (jeepney) => updateMarker(jeepney);
///   service.onRoutesReceived = (routes) => drawPolylines(routes);
///   service.connect();
class JeepneySocketService {
  static final JeepneySocketService _instance =
      JeepneySocketService._internal();
  factory JeepneySocketService() => _instance;
  JeepneySocketService._internal();

  io.Socket? _socket;
  bool _isConnected = false;

  // Callbacks — set these before calling connect()
  Function(List<Jeepney>)? onSnapshot;
  Function(Jeepney)? onJeepneyUpdate;
  Function(List<RouteData>)? onRoutesReceived;
  Function(bool)? onConnectionChanged;

  // Backend URL — update this when deploying
  // For web (local): http://localhost:3000
  // For Android emulator: http://10.0.2.2:3000
  // For physical device: http://YOUR_LOCAL_IP:3000
  static const String _serverUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

  bool get isConnected => _isConnected;

  void connect() {
    if (_socket != null && _isConnected) return;

    if (kDebugMode) {
      print('[JeepneySocketService] Connecting to $_serverUrl...');
    }

    _socket = io.io(
      _serverUrl,
      io.OptionBuilder()
          // Web needs polling + websocket, native can use websocket only
          .setTransports(kIsWeb ? ['polling', 'websocket'] : ['websocket'])
          .disableAutoConnect()
          .setTimeout(10000)
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnected = true;
      if (kDebugMode) print('[JeepneySocketService] ✅ Connected');
      onConnectionChanged?.call(true);
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      if (kDebugMode) print('[JeepneySocketService] ❌ Disconnected');
      onConnectionChanged?.call(false);
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      if (kDebugMode) print('[JeepneySocketService] Connection error: $error');
      onConnectionChanged?.call(false);
    });

    // Receive all current jeepney positions (initial snapshot)
    _socket!.on('jeepney:snapshot', (data) {
      try {
        final list =
            (data as List<dynamic>)
                .map((item) => _jeepneyFromJson(item as Map<String, dynamic>))
                .toList();
        onSnapshot?.call(list);
        if (kDebugMode) {
          print('[JeepneySocketService] Snapshot: ${list.length} jeepneys');
        }
      } catch (e) {
        if (kDebugMode) print('[JeepneySocketService] Snapshot error: $e');
      }
    });

    // Receive single jeepney update (every 2 seconds from simulator)
    _socket!.on('jeepney:update', (data) {
      try {
        final jeepney = _jeepneyFromJson(data as Map<String, dynamic>);
        onJeepneyUpdate?.call(jeepney);
      } catch (e) {
        if (kDebugMode) print('[JeepneySocketService] Update error: $e');
      }
    });

    // Receive route polyline data (drawn on map)
    _socket!.on('routes:snapshot', (data) {
      try {
        final routes =
            (data as List<dynamic>)
                .map((item) => RouteData.fromJson(item as Map<String, dynamic>))
                .toList();
        onRoutesReceived?.call(routes);
        if (kDebugMode) {
          print('[JeepneySocketService] Routes: ${routes.length} received');
        }
      } catch (e) {
        if (kDebugMode) print('[JeepneySocketService] Routes error: $e');
      }
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }
}
