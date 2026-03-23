import 'dart:math';

import 'package:flutter/material.dart';

class CosmicRipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double controllerValue;

  CosmicRipplePainter({
    required this.progress,
    required this.color,
    required this.controllerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.9, size.height / 2);
    final maxRadius = size.width * 0.7;

    // Draw pulsing background gradient
    final bgGradient = RadialGradient(
      colors: [
        color.withOpacity(0.05 * progress),
        Colors.transparent,
      ],
      stops: [0.0, 0.8 + (0.2 * controllerValue)],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = bgGradient.createShader(
          Rect.fromCircle(center: center, radius: maxRadius * progress),
        ),
    );

    // Draw animated ripple circles
    for (var i = 0; i < 3; i++) {
      final rippleProgress = (progress + (i * 0.2)) % 1.0;
      final radius = maxRadius * rippleProgress;
      final opacity = 0.2 * (1 - rippleProgress);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 + (2 * rippleProgress)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(center, radius, paint);
    }

    // Draw animated radiating lines with wave effect
    final linePaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    for (var i = 0; i < 12; i++) {
      final angle = (2 * pi / 12) * i;
      final waveOffset = sin(angle * 2 + controllerValue * 2 * pi) * 10;
      final endRadius =
          maxRadius * progress * (0.7 + 0.3 * waveOffset.abs() / 10);

      final x = center.dx + endRadius * cos(angle);
      final y = center.dy + endRadius * sin(angle);

      canvas.drawLine(
        center,
        Offset(x, y),
        linePaint,
      );
    }

    // Draw twinkling stars
    final rnd = Random(42);
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5 * progress);

    for (var i = 0; i < 30; i++) {
      final starX = rnd.nextDouble() * size.width;
      final starY = rnd.nextDouble() * size.height;
      final pulse = sin(controllerValue * 2 * pi + i) * 0.5 + 0.5;
      final starSize = 1 + (2 * pulse * progress);

      canvas.drawCircle(
        Offset(starX, starY),
        starSize,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CosmicRipplePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        controllerValue != oldDelegate.controllerValue;
  }
}
