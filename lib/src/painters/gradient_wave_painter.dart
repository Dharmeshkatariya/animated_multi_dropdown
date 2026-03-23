import 'dart:math';

import 'package:flutter/material.dart';

class GradientWavePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double waveIntensity;

  GradientWavePainter({
    required this.progress,
    required this.colors,
    this.waveIntensity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.3);
    final radius = size.width * 0.8 * progress;

    // Enhanced gradient with more color stops
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors[0].withOpacity(0.3 * progress),
          colors[1].withOpacity(0.2 * progress),
          colors[2].withOpacity(0.1 * progress),
        ],
        stops: const [0.0, 0.7, 1.0],
        radius: 0.8,
        focal: Alignment.center,
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius, gradientPaint);

    // Draw multiple wave effects for richer visual
    final waveCount = 3;
    for (int waveIndex = 0; waveIndex < waveCount; waveIndex++) {
      final waveProgress = progress * (1 - waveIndex * 0.2);
      if (waveProgress <= 0) continue;

      final wavePaint = Paint()
        ..color = colors[waveIndex % colors.length]
            .withOpacity(0.3 * waveProgress * waveIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * (waveCount - waveIndex) / waveCount
        ..strokeCap = StrokeCap.round;

      final wavePath = Path();
      final waveHeight = 20.0 * waveProgress;
      final waveLength = size.width;
      final verticalOffset = size.height * (0.7 + waveIndex * 0.05);

      wavePath.moveTo(0, verticalOffset);
      for (var i = 0; i <= waveLength; i += 10) {
        final x = i.toDouble();
        // More complex wave function for organic feel
        final y = verticalOffset +
            sin(i * 0.04 + progress * 2) * waveHeight +
            sin(i * 0.1) * waveHeight * 0.3;
        if (i == 0) {
          wavePath.moveTo(x, y);
        } else {
          wavePath.lineTo(x, y);
        }
      }

      canvas.drawPath(wavePath, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant GradientWavePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        colors != oldDelegate.colors ||
        waveIntensity != oldDelegate.waveIntensity;
  }
}

class GradientWaveClipper extends CustomClipper<Path> {
  final double progress;
  final double waveHeightFactor;

  GradientWaveClipper({
    required this.progress,
    this.waveHeightFactor = 1.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 15.0 * progress * waveHeightFactor;
    final verticalOffset = size.height * 0.1 * (1 - progress);

    path.moveTo(0, size.height);
    path.lineTo(0, waveHeight + verticalOffset);

    for (var i = 0; i <= size.width; i += 5) {
      final x = i.toDouble();
      final y = waveHeight +
          verticalOffset +
          sin(i * 0.05 + progress * 3) * waveHeight * 0.8 +
          sin(i * 0.1) * waveHeight * 0.2;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant GradientWaveClipper oldClipper) {
    return progress != oldClipper.progress ||
        waveHeightFactor != oldClipper.waveHeightFactor;
  }
}
