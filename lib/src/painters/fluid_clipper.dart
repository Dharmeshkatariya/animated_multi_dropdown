import 'dart:math';

import 'package:flutter/material.dart';

class FluidDropdownClipper extends CustomClipper<Path> {
  final double progress;
  final bool isOpen;

  FluidDropdownClipper({required this.progress, required this.isOpen});

  @override
  Path getClip(Size size) {
    final path = Path();
    final curveHeight = 20.0 * progress;

    // Create fluid top edge
    path.moveTo(0, curveHeight);

    // Add wavy effect
    for (var i = 0; i < size.width; i += 20) {
      final x = i.toDouble();
      final y = curveHeight + sin(x * 0.05 + progress * 3) * curveHeight;
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant FluidDropdownClipper oldClipper) {
    return progress != oldClipper.progress || isOpen != oldClipper.isOpen;
  }
}
