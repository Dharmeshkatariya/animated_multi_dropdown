import 'package:flutter/material.dart';

class FluidWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  FluidWavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final baseHeight = size.height * (1 - progress);

    path.moveTo(0, baseHeight);
    path.quadraticBezierTo(
      size.width * 0.25,
      baseHeight + waveHeight,
      size.width * 0.5,
      baseHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      baseHeight - waveHeight,
      size.width,
      baseHeight,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FluidWavePainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
