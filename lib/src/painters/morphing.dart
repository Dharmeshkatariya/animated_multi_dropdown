import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/cupertino.dart';

class MorphingPainter extends CustomPainter {
  final double progress;
  final Color color;

  MorphingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValuesOpacity(0.1 * progress)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * (0.7 - (0.3 * progress)),
        size.width * 0.5,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * (0.7 + (0.3 * progress)),
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MorphingPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
