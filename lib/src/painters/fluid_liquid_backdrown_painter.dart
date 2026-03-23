import 'dart:math';

import 'package:flutter/material.dart';

class FluidLiquidBackdrownPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isOpen;

  FluidLiquidBackdrownPainter({
    required this.progress,
    required this.color,
    required this.isOpen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3);
    final radius = size.width * 0.9 * progress;

    // Main fluid gradient
    final gradient = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.3 * progress),
          color.withOpacity(0.1 * progress),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius, gradient);

    // Wave effect
    final wavePaint = Paint()
      ..color = color.withOpacity(0.2 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final wavePath = Path();
    final waveHeight = 15.0 * progress;
    final waveLength = size.width;

    wavePath.moveTo(0, size.height * 0.7);
    for (var i = 0; i < waveLength; i += 20) {
      final x = i.toDouble();
      final y = size.height * 0.7 + sin(x * 0.05 + progress * 3) * waveHeight;
      wavePath.lineTo(x, y);
    }
    canvas.drawPath(wavePath, wavePaint);

    // Floating droplets when opening
    if (isOpen && progress > 0.3) {
      final dropletPaint = Paint()
        ..color = color.withOpacity(0.2 * progress)
        ..style = PaintingStyle.fill;

      final random = Random(progress.hashCode);
      for (int i = 0; i < 8; i++) {
        final dropletSize = random.nextDouble() * 8 + 4;
        final dropletX = random.nextDouble() * size.width;
        final dropletY = size.height * (0.4 + random.nextDouble() * 0.5);
        final dropletOffset = Offset(dropletX, dropletY);

        canvas.drawCircle(dropletOffset, dropletSize, dropletPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FluidLiquidBackdrownPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        isOpen != oldDelegate.isOpen;
  }
}
