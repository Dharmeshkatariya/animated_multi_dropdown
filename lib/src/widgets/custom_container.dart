import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final Alignment? alignment;
  final BoxConstraints? constraints;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final VoidCallback? onTap;
  final bool isGlass;
  final double? blurSigma;
  final Color? glassColor;

  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.alignment,
    this.constraints,
    this.boxShadow,
    this.clipBehavior = Clip.none,
    this.transform,
    this.transformAlignment,
    this.gradient,
    this.decorationImage,
    this.onTap,
    this.isGlass = false,
    this.blurSigma,
    this.glassColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      width: width,
      height: height,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: isGlass ? null : (color ?? AppColors.white),
        border: border ??
            (borderColor != null ? Border.all(color: borderColor!) : null),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: boxShadow ?? (isGlass ? AppShadows.glass : null),
        gradient: gradient,
        image: decorationImage,
      ),
      child: child,
    );

    if (isGlass) {
      container = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma ?? 10,
            sigmaY: blurSigma ?? 10,
          ),
          child: Container(
            color: glassColor ?? AppColors.glassWhite,
            child: container,
          ),
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

// Predefined containers
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: padding ?? const EdgeInsets.all(20),
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      isGlass: true,
      blurSigma: blur ?? 10,
      glassColor: AppColors.glassWhite,
      child: child,
    );
  }
}

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  const GradientContainer({
    super.key,
    required this.child,
    required this.colors,
    this.padding,
    this.borderRadius,
    this.begin,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: padding ?? const EdgeInsets.all(20),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: colors,
        begin: begin ?? Alignment.topLeft,
        end: end ?? Alignment.bottomRight,
      ),
      child: child,
    );
  }
}
