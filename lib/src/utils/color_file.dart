import 'package:flutter/material.dart';
import 'color_utils.dart';

/// Predefined color constants for common use cases
class ColorFile {
  // Glass effect colors
  static Color glassWhite = ColorUtils.withOpacity(Colors.white, 0.13);
  static Color glassBlack = ColorUtils.withOpacity(Colors.black, 0.13);
  static Color glassPrimary = ColorUtils.withOpacity(Colors.blue, 0.13);

  // Hover and splash effects
  static Color hoverColor(Color baseColor) =>
      ColorUtils.withOpacity(baseColor, 0.1);

  static Color splashColor(Color baseColor) =>
      ColorUtils.withOpacity(baseColor, 0.2);

  static Color disabledColor(Color baseColor) =>
      ColorUtils.withOpacity(baseColor, 0.5);

  // Shadow colors
  static const shadowLight = Color(0x1A000000);
  static const shadowMedium = Color(0x33000000);
  static const shadowDark = Color(0x4D000000);

  // Gradient helpers
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient secondaryGradient = const LinearGradient(
    colors: [Colors.purple, Colors.pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Helper class for creating box decorations with modern APIs
class BoxDecorationHelper {
  /// Creates a glass effect decoration
  static BoxDecoration glass({
    required Color color,
    double opacity = 0.13,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: ColorUtils.withOpacity(color, opacity),
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );
  }

  /// Creates a gradient decoration
  static BoxDecoration gradient({
    required List<Color> colors,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );
  }

  /// Creates a shadow decoration
  static BoxDecoration shadow({
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: ColorUtils.withOpacity(Colors.black, 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
    );
  }
}
