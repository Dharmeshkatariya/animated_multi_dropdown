import 'dart:math';

import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/material.dart';

class BondPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isOpen;

  BondPainter({
    required this.progress,
    required this.color,
    required this.isOpen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValuesOpacity(0.3 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height);
    final radius = size.height * 0.8 * progress;

    if (isOpen) {
      // Draw molecular bonds when open
      const bondCount = 5;
      for (var i = 0; i < bondCount; i++) {
        final angle = (i * (2 * pi / bondCount)) + (pi * progress);
        final end = Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        );
        canvas.drawLine(center, end, paint);
      }
    } else {
      // Draw simple connection when closed
      canvas.drawCircle(center, radius * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BondPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        isOpen != oldDelegate.isOpen;
  }
}
