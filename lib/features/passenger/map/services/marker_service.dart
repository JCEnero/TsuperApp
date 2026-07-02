import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/jeepney.dart';

class MarkerService {
  static final MarkerService _instance = MarkerService._internal();
  factory MarkerService() => _instance;
  MarkerService._internal();

  final Map<String, BitmapDescriptor> _markerCache = {};
  ui.Image? _jeepneyImage;
  bool _imageLoadAttempted = false;

  /// Get a custom jeepney marker with optional rotation.
  /// Heading is quantized to 8 compass directions (every 45°)
  /// to maximize cache hits and avoid generating thousands of bitmaps.
  Future<BitmapDescriptor> getJeepneyMarker({
    JeepneyStatus status = JeepneyStatus.available,
    double heading = 0.0,
    double size = 40.0,
  }) async {
    // Round heading to nearest 45° for cache efficiency
    final quantizedHeading = (heading / 45.0).round() * 45.0 % 360.0;
    final cacheKey =
        '${status.name}_${quantizedHeading.toStringAsFixed(0)}_${size.toStringAsFixed(0)}';

    if (_markerCache.containsKey(cacheKey)) {
      return _markerCache[cacheKey]!;
    }

    final markerDescriptor = await _createJeepneyMarker(
      status: status,
      heading: quantizedHeading,
      size: size,
    );

    _markerCache[cacheKey] = markerDescriptor;
    return markerDescriptor;
  }

  /// Pre-warm cache for all status + heading combinations.
  /// Call once after map loads so first movements are instant.
  Future<void> prewarmCache({double size = 40.0}) async {
    for (final status in JeepneyStatus.values) {
      for (var deg = 0; deg < 360; deg += 45) {
        await getJeepneyMarker(
          status: status,
          heading: deg.toDouble(),
          size: size,
        );
      }
    }
    if (kDebugMode) {
      print('[MarkerService] Cache pre-warmed: ${_markerCache.length} entries');
    }
  }

  Future<BitmapDescriptor> _createJeepneyMarker({
    required JeepneyStatus status,
    required double heading,
    required double size,
  }) async {
    // Load jeepney image once
    if (_jeepneyImage == null && !_imageLoadAttempted) {
      _imageLoadAttempted = true;
      try {
        if (kDebugMode) {
          print(
            '[MarkerService] Loading jeepney image from assets/markers/jeepney_navy.png',
          );
        }
        final ByteData byteData = await rootBundle.load(
          'assets/markers/jeepney_navy.png',
        );
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        _jeepneyImage = frameInfo.image;
        if (kDebugMode) {
          print(
            '[MarkerService] Jeepney image loaded successfully: ${_jeepneyImage!.width}x${_jeepneyImage!.height}',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('[MarkerService] Error loading jeepney image: $e');
        }
      }
    }

    // Get status color for dot
    final statusColor = _getStatusColor(status);

    // Get device pixel ratio
    final devicePixelRatio =
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

    // Create picture with rotation and status dot
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Apply rotation around center
    canvas.save();
    canvas.translate(size / 2, size / 2);
    canvas.rotate(heading * 3.14159 / 180.0);
    canvas.translate(-size / 2, -size / 2);

    // Draw jeepney illustration (no tinting)
    if (_jeepneyImage != null) {
      final jeepneySize = size * 0.8;
      final jeepneyOffset = (size - jeepneySize) / 2;
      canvas.drawImageRect(
        _jeepneyImage!,
        Rect.fromLTWH(
          0,
          0,
          _jeepneyImage!.width.toDouble(),
          _jeepneyImage!.height.toDouble(),
        ),
        Rect.fromLTWH(jeepneyOffset, jeepneyOffset, jeepneySize, jeepneySize),
        Paint(),
      );
    } else {
      // Fallback: draw a simple jeepney shape if image fails to load
      _drawFallbackJeepney(canvas, size);
    }

    canvas.restore();

    // Draw status dot on top-left (not rotated)
    _drawStatusDot(canvas, size, statusColor);

    final ui.Picture picture = recorder.endRecording();

    // Convert to image
    final ui.Image image = await picture.toImage(
      (size * devicePixelRatio).toInt(),
      (size * devicePixelRatio).toInt(),
    );

    // Convert to bytes
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      throw Exception('Failed to convert marker image to bytes');
    }

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    return BitmapDescriptor.bytes(pngBytes);
  }

  void _drawFallbackJeepney(Canvas canvas, double size) {
    final scale = size / 64.0;
    final paint =
        Paint()
          ..color = const Color(0xFF1A2A5F)
          ..style = PaintingStyle.fill;

    // Simple jeepney body shape
    final path =
        Path()
          ..moveTo(8 * scale, 24 * scale)
          ..lineTo(8 * scale, 44 * scale)
          ..lineTo(12 * scale, 44 * scale)
          ..lineTo(12 * scale, 48 * scale)
          ..lineTo(20 * scale, 48 * scale)
          ..lineTo(20 * scale, 44 * scale)
          ..lineTo(44 * scale, 44 * scale)
          ..lineTo(44 * scale, 48 * scale)
          ..lineTo(52 * scale, 48 * scale)
          ..lineTo(52 * scale, 44 * scale)
          ..lineTo(56 * scale, 44 * scale)
          ..lineTo(56 * scale, 24 * scale)
          ..lineTo(48 * scale, 16 * scale)
          ..lineTo(16 * scale, 16 * scale)
          ..close();

    canvas.drawPath(path, paint);
  }

  void _drawStatusDot(Canvas canvas, double size, Color color) {
    final dotSize = 10.0;
    final dotOffset = 4.0;

    // Draw white border
    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(dotOffset + dotSize / 2, dotOffset + dotSize / 2),
      dotSize / 2 + 2,
      borderPaint,
    );

    // Draw colored dot
    final dotPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(dotOffset + dotSize / 2, dotOffset + dotSize / 2),
      dotSize / 2,
      dotPaint,
    );
  }

  Color _getStatusColor(JeepneyStatus status) {
    switch (status) {
      case JeepneyStatus.available:
        return const Color(0xFF1A2A5F); // Navy Blue
      case JeepneyStatus.onRoute:
        return const Color(0xFF1976D2); // Medium Blue
      case JeepneyStatus.full:
        return const Color(0xFFD32F2F); // Red
      case JeepneyStatus.onBreak:
        return const Color(0xFFF57C00); // Orange
      case JeepneyStatus.maintenance:
        return const Color(0xFF757575); // Gray
    }
  }

  /// Synchronous cache lookup — returns null if not cached.
  /// Used by _rebuildMarkersSync in the map screen for fast animation ticks.
  BitmapDescriptor? getCachedMarker(
    JeepneyStatus status,
    double heading,
    double size,
  ) {
    final quantizedHeading = (heading / 45.0).round() * 45.0 % 360.0;
    final cacheKey =
        '${status.name}_${quantizedHeading.toStringAsFixed(0)}_${size.toStringAsFixed(0)}';
    return _markerCache[cacheKey];
  }

  /// Direct cache key lookup — returns null if not cached yet.
  BitmapDescriptor? getCached(String cacheKey) => _markerCache[cacheKey];
}
