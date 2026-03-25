import 'dart:math';
import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:animated_multi_dropdown/src/utils/custom_matrix_utils.dart';
import 'package:flutter/material.dart';
import '../models/multi_dropdown_config.dart';
import '../painters/glitch_painter.dart';
import '../painters/liquid_wave_clipper.dart';
import 'base_drop_down_strategy.dart';

/// Mixin for glass morphism effect
mixin GlassEffectMixin<T> on BaseDropDownStrategy<T> {
  Widget applyGlassEffect(Widget child, MultiDropDownConfig config) {
    return ClipRRect(
      borderRadius: config.borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: config.blurIntensity,
          sigmaY: config.blurIntensity,
        ),
        child: child,
      ),
    );
  }
}

/// Mixin for wave animation effects
mixin WaveEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createWaveAnimation(AnimationController controller, MultiDropDownConfig config) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: config.curve));
  }

  Widget applyLiquidWaveClipper(Widget child, Animation<double> animation) {
    return ClipPath(
      clipper: LiquidWaveClipper(animation.value),
      child: child,
    );
  }
}

/// Mixin for neon glow effect
mixin NeonEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createGlowAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 1.0),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  Animation<double> createExpandAnimation(AnimationController controller) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  BoxDecoration getNeonDecoration(Color color, double intensity) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: color.withValuesOpacity(0.5 * intensity),
          blurRadius: 15,
          spreadRadius: 2,
        ),
      ],
      border: Border.all(color: color.withValuesOpacity(0.7), width: 1.5),
    );
  }
}

/// Mixin for 3D bounce effect
mixin Bounce3DEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createRotateAnimation(AnimationController controller) {
    return Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
  }

  Animation<double> createDepthAnimation(AnimationController controller, double depth) {
    return Tween(begin: 0.0, end: depth).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
  }

  Matrix4 get3DTransform(Animation<double> depthAnimation) {
    return CustomMatrixUtils.translate(
      z: depthAnimation.value,
    )..setEntry(3, 2, 0.001);
  }
}

/// Mixin for staggered animation
mixin StaggeredEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createStaggeredItemAnimation(
      AnimationController controller,
      int index,
      MultiDropDownConfig config,
      ) {
    final start = min(0.1 + (0.1 * index), 0.9);
    final end = min(0.5 + (0.1 * index), 1.0);
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: config.curve),
      ),
    );
  }
}

/// Mixin for foldable animation
mixin FoldableEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createFoldAnimation(AnimationController controller, MultiDropDownConfig config) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: config.curve),
    );
  }

  double calculateVisibleHeight(int itemCount, double animationValue, double itemHeight, double maxHeight) {
    final totalHeight = itemCount * itemHeight;
    final visibleHeight = totalHeight * animationValue;
    return visibleHeight.clamp(0.0, maxHeight);
  }
}

/// Mixin for cyberpunk glitch effect
mixin CyberpunkEffectMixin<T> on BaseDropDownStrategy<T> {
  Animation<double> createGlitchAnimation(AnimationController controller) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );
  }

  Widget applyGlitchPainter(Widget child, Animation<double> animation, Color color1, Color color2) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return CustomPaint(
                painter: GlitchPainter(
                  progress: animation.value.clamp(0.0, 1.0),
                  color1: color1,
                  color2: color2,
                ),
              );
            },
          ),
        ),
        child,
      ],
    );
  }
}