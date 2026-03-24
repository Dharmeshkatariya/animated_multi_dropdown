import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:flutter/cupertino.dart';

class LiquidSwipePainter extends CustomPainter {
  final double progress;
  final Color color;

  LiquidSwipePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValuesOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3 * progress,
        size.height * 0.7 - (50 * progress),
        size.width * 0.6 * progress,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.9 * progress,
        size.height * 0.7 + (50 * progress),
        size.width * progress,
        size.height * 0.7,
      )
      ..lineTo(size.width * progress, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidSwipePainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
