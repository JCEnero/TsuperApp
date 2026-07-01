import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.type});

  final IllustrationType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case IllustrationType.tracking:
        return _TrackingIllustration();
      case IllustrationType.routes:
        return _RoutesIllustration();
      case IllustrationType.confidence:
        return _ConfidenceIllustration();
    }
  }
}

enum IllustrationType { tracking, routes, confidence }

class _TrackingIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _TrackingPainter(),
    );
  }
}

class _TrackingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width < 400 ? 0.6 : 1.0;

    // Background circle
    final bgPaint =
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 120 * scale, bgPaint);

    // Map path
    final pathPaint =
        Paint()
          ..color = AppColors.gray300
          ..strokeWidth = 4 * scale
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(center.dx - 80 * scale, center.dy - 40 * scale);
    path.quadraticBezierTo(
      center.dx - 40 * scale,
      center.dy + 20 * scale,
      center.dx,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx + 40 * scale,
      center.dy - 20 * scale,
      center.dx + 80 * scale,
      center.dy + 40 * scale,
    );
    canvas.drawPath(path, pathPaint);

    // Jeepney markers
    _drawJeepney(canvas, center.dx - 60 * scale, center.dy - 20 * scale, scale);
    _drawJeepney(canvas, center.dx, center.dy, scale);
    _drawJeepney(canvas, center.dx + 60 * scale, center.dy + 20 * scale, scale);

    // Location pin
    _drawLocationPin(
      canvas,
      center.dx + 80 * scale,
      center.dy + 40 * scale,
      scale,
    );
  }

  void _drawJeepney(Canvas canvas, double x, double y, double scale) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 12 * scale, paint);

    final outlinePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3 * scale
          ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(x, y), 12 * scale, outlinePaint);
  }

  void _drawLocationPin(Canvas canvas, double x, double y, double scale) {
    final paint =
        Paint()
          ..color = AppColors.danger
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(x, y - 20 * scale);
    path.lineTo(x - 12 * scale, y);
    path.lineTo(x + 12 * scale, y);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(x, y - 8 * scale),
      6 * scale,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutesIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _RoutesPainter(),
    );
  }
}

class _RoutesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width < 400 ? 0.6 : 1.0;

    // Background
    final bgPaint =
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 120 * scale, bgPaint);

    // Multiple route lines
    final colors = [AppColors.primary, AppColors.success, AppColors.warning];

    for (int i = 0; i < 3; i++) {
      final pathPaint =
          Paint()
            ..color = colors[i]
            ..strokeWidth = 4 * scale
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      final path = Path();
      final offset = (i - 1) * 30 * scale;
      path.moveTo(center.dx - 80 * scale, center.dy + offset);
      path.quadraticBezierTo(
        center.dx - 20 * scale,
        center.dy - 40 * scale + offset,
        center.dx + 80 * scale,
        center.dy + offset,
      );
      canvas.drawPath(path, pathPaint);

      // Route markers
      _drawRouteMarker(
        canvas,
        center.dx - 80 * scale,
        center.dy + offset,
        scale,
        colors[i],
      );
      _drawRouteMarker(
        canvas,
        center.dx + 80 * scale,
        center.dy + offset,
        scale,
        colors[i],
      );
    }

    // Time badge
    _drawTimeBadge(canvas, center.dx, center.dy - 50 * scale, scale);
  }

  void _drawRouteMarker(
    Canvas canvas,
    double x,
    double y,
    double scale,
    Color color,
  ) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 8 * scale, paint);
  }

  void _drawTimeBadge(Canvas canvas, double x, double y, double scale) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(x, y),
        width: 60 * scale,
        height: 28 * scale,
      ),
      Radius.circular(14 * scale),
    );
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfidenceIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _ConfidencePainter(),
    );
  }
}

class _ConfidencePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width < 400 ? 0.6 : 1.0;

    // Background
    final bgPaint =
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 120 * scale, bgPaint);

    // Shield
    final shieldPaint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    final shieldPath = Path();
    shieldPath.moveTo(center.dx, center.dy - 60 * scale);
    shieldPath.lineTo(center.dx + 50 * scale, center.dy - 20 * scale);
    shieldPath.lineTo(center.dx + 50 * scale, center.dy + 30 * scale);
    shieldPath.quadraticBezierTo(
      center.dx + 50 * scale,
      center.dy + 60 * scale,
      center.dx,
      center.dy + 70 * scale,
    );
    shieldPath.quadraticBezierTo(
      center.dx - 50 * scale,
      center.dy + 60 * scale,
      center.dx - 50 * scale,
      center.dy + 30 * scale,
    );
    shieldPath.lineTo(center.dx - 50 * scale, center.dy - 20 * scale);
    shieldPath.close();
    canvas.drawPath(shieldPath, shieldPaint);

    // Checkmark
    final checkPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 6 * scale
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final checkPath = Path();
    checkPath.moveTo(center.dx - 20 * scale, center.dy);
    checkPath.lineTo(center.dx, center.dy + 20 * scale);
    checkPath.lineTo(center.dx + 30 * scale, center.dy - 20 * scale);
    canvas.drawPath(checkPath, checkPaint);

    // Stars
    _drawStar(canvas, center.dx - 70 * scale, center.dy - 40 * scale, scale);
    _drawStar(canvas, center.dx + 70 * scale, center.dy - 40 * scale, scale);
    _drawStar(canvas, center.dx, center.dy + 50 * scale, scale);
  }

  void _drawStar(Canvas canvas, double x, double y, double scale) {
    final paint =
        Paint()
          ..color = AppColors.warning
          ..style = PaintingStyle.fill;

    final path = Path();
    final outerRadius = 12 * scale;
    final innerRadius = 5 * scale;

    for (int i = 0; i < 10; i++) {
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final px = x + radius * 0.866 * (i % 2 == 0 ? 1 : 0.5);
      final py = y + radius * (i % 2 == 0 ? 0 : 1);

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
