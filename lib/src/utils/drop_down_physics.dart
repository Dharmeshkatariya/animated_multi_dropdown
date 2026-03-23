import 'dart:math' as math;

abstract class DropdownPhysics {
  double transform(double animationValue);

  double opacity(double animationValue);

  Duration get duration;
}

class LocomotivePhysics extends DropdownPhysics {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 1.7) * math.pow(1 - t, 2.1) + t;
  }

  @override
  double opacity(double t) {
    return math.min(t * 2, 1);
  }

  @override
  Duration get duration => const Duration(milliseconds: 800);
}

class ElasticPhysics extends DropdownPhysics {
  @override
  double transform(double t) {
    return math.sin(13 * math.pi / 2 * t) * math.pow(2, -10 * t) + 1;
  }

  @override
  double opacity(double t) {
    return t < 0.5 ? 0 : (t - 0.5) * 2;
  }

  @override
  Duration get duration => const Duration(milliseconds: 1200);
}

class SmoothStepPhysics extends DropdownPhysics {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t);
  }

  @override
  double opacity(double t) {
    return t;
  }

  @override
  Duration get duration => const Duration(milliseconds: 500);
}
