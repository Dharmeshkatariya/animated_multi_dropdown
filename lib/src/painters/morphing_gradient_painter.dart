import 'package:flutter/material.dart';

class MorphingGradientPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  MorphingGradientPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.8, size.height * 0.3);
    final radius = size.width * 0.6 * progress;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: colors,
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant MorphingGradientPainter oldDelegate) {
    return progress != oldDelegate.progress || colors != oldDelegate.colors;
  }
}
