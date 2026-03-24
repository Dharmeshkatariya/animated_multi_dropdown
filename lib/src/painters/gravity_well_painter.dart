import 'dart:math';

import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/material.dart';

class GravityWellPainter extends CustomPainter {
  final double progress;
  final Color color;

  GravityWellPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.9, size.height / 2);
    final maxRadius = size.width * 0.6;

    // Draw gravity well gradient
    final gradient = RadialGradient(
      colors: [
        color.withValuesOpacity(0.2 * progress),
        color.withValuesOpacity(0.05 * progress),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: maxRadius * progress),
      );

    canvas.drawCircle(center, maxRadius * progress, paint);

    // Draw spiral effect
    final spiralPaint = Paint()
      ..color = color.withValuesOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final spiralPath = Path();
    const spiralTurns = 2;
    const spiralStartRadius = 5.0;
    final spiralEndRadius = maxRadius * progress;

    spiralPath.moveTo(
      center.dx + spiralStartRadius * cos(0),
      center.dy + spiralStartRadius * sin(0),
    );

    for (var i = 0; i <= 360 * spiralTurns; i++) {
      final angle = i * pi / 180;
      final radius = spiralStartRadius +
          (spiralEndRadius - spiralStartRadius) * (i / (360 * spiralTurns));
      spiralPath.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    canvas.drawPath(spiralPath, spiralPaint);
  }

  @override
  bool shouldRepaint(covariant GravityWellPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
