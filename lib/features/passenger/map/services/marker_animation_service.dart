import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/jeepney.dart';

class MarkerAnimationService {
  static final MarkerAnimationService _instance =
      MarkerAnimationService._internal();
  factory MarkerAnimationService() => _instance;
  MarkerAnimationService._internal();

  final Map<String, MarkerAnimationController> _controllers = {};
  Timer? _animationTimer;

  void startAnimation({
    required List<Jeepney> jeepneys,
    required Function(Set<Marker>) onMarkersUpdated,
    Duration interval = const Duration(seconds: 2),
  }) {
    _animationTimer?.cancel();

    _animationTimer = Timer.periodic(interval, (timer) {
      _simulateJeepneyMovement(jeepneys, onMarkersUpdated);
    });
  }

  void stopAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
  }

  void _simulateJeepneyMovement(
    List<Jeepney> jeepneys,
    Function(Set<Marker>) onMarkersUpdated,
  ) {
    final updatedMarkers = <Marker>{};

    for (final jeepney in jeepneys) {
      // Simulate small random movement
      final randomLatOffset = (jeepney.id.hashCode % 200 - 100) / 100000.0;
      final randomLngOffset = (jeepney.id.hashCode % 200 - 100) / 100000.0;

      final newLat = jeepney.latitude + randomLatOffset;
      final newLng = jeepney.longitude + randomLngOffset;

      updatedMarkers.add(
        Marker(
          markerId: MarkerId(jeepney.id),
          position: LatLng(newLat, newLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getStatusHue(jeepney.status),
          ),
        ),
      );
    }

    onMarkersUpdated(updatedMarkers);
  }

  double _getStatusHue(JeepneyStatus status) {
    switch (status) {
      case JeepneyStatus.available:
        return BitmapDescriptor.hueGreen;
      case JeepneyStatus.onRoute:
        return BitmapDescriptor.hueBlue;
      case JeepneyStatus.full:
        return BitmapDescriptor.hueRed;
      case JeepneyStatus.onBreak:
        return BitmapDescriptor.hueOrange;
      case JeepneyStatus.maintenance:
        return BitmapDescriptor.hueViolet;
    }
  }

  void dispose() {
    stopAnimation();
    _controllers.clear();
  }
}

class MarkerAnimationController {
  final String jeepneyId;
  LatLng currentPosition;
  LatLng targetPosition;
  double progress = 0.0;

  MarkerAnimationController({
    required this.jeepneyId,
    required this.currentPosition,
    required this.targetPosition,
  });

  LatLng get interpolatedPosition {
    return LatLng(
      currentPosition.latitude +
          (targetPosition.latitude - currentPosition.latitude) * progress,
      currentPosition.longitude +
          (targetPosition.longitude - currentPosition.longitude) * progress,
    );
  }

  void updateProgress(double delta) {
    progress = (progress + delta).clamp(0.0, 1.0);
  }

  bool get isComplete => progress >= 1.0;
}
