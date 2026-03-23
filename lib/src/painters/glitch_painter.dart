import 'dart:math';

import 'package:flutter/material.dart';

class GlitchPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  GlitchPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random();
    const maxLines = 20;
    const maxOffset = 10.0;

    // Draw glitch lines
    for (var i = 0; i < maxLines * progress; i++) {
      final y = size.height * rnd.nextDouble();
      final offset = maxOffset * rnd.nextDouble() * progress;
      final width = size.width * rnd.nextDouble() * 0.3;
      final color = rnd.nextBool() ? color1 : color2;

      final paint = Paint()
        ..color = color.withOpacity(0.1 * progress)
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(0, y),
        Offset(width, y + offset),
        paint,
      );
    }

    // Draw scanline effect
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color1.withOpacity(0.05 * progress),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    for (var y = 0.0; y < size.height; y += 2) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        scanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GlitchPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color1 != oldDelegate.color1 ||
        color2 != oldDelegate.color2;
  }
}
