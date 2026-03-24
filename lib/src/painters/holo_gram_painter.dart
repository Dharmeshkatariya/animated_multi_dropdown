import 'dart:math';

import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/material.dart';

class HologramPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  HologramPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.3);
    final radius = size.width * 0.8 * progress;

    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: colors,
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius, gradientPaint);

    // Draw scan lines
    final linePaint = Paint()
      ..color = colors[0].withValuesOpacity(0.1)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 3) {
      final lineHeight = sin(y * 0.1) * 5 * progress;
      canvas.drawLine(
        Offset(0, y + lineHeight),
        Offset(size.width, y + lineHeight),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HologramPainter oldDelegate) {
    return progress != oldDelegate.progress || colors != oldDelegate.colors;
  }
}
