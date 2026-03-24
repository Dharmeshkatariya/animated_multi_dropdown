import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/material.dart';

class CyberGridPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  CyberGridPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color1.withValuesOpacity(0.05 * progress)
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (var y = 0.0; y < size.height; y += 20) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final bracketPaint = Paint()
      ..color = color2.withValuesOpacity(progress)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final bracketSize = 30.0 * progress;
    const margin = 10.0;

    canvas.drawPath(
      Path()
        ..moveTo(margin, margin + bracketSize)
        ..lineTo(margin, margin)
        ..lineTo(margin + bracketSize, margin),
      bracketPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(size.width - margin - bracketSize, margin)
        ..lineTo(size.width - margin, margin)
        ..lineTo(size.width - margin, margin + bracketSize),
      bracketPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(margin, size.height - margin - bracketSize)
        ..lineTo(margin, size.height - margin)
        ..lineTo(margin + bracketSize, size.height - margin),
      bracketPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(size.width - margin - bracketSize, size.height - margin)
        ..lineTo(size.width - margin, size.height - margin)
        ..lineTo(size.width - margin, size.height - margin - bracketSize),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CyberGridPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color1 != oldDelegate.color1 ||
        color2 != oldDelegate.color2;
  }
}

class CyberClipper extends CustomClipper<Path> {
  final double progress;

  CyberClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 8.0;
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();

    if (progress > 0.5) {
      final notchSize = 10.0 * (progress - 0.5) * 2;
      final center = size.width / 2;

      path.moveTo(center - notchSize, 0);
      path.lineTo(center, -notchSize);
      path.lineTo(center + notchSize, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CyberClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
