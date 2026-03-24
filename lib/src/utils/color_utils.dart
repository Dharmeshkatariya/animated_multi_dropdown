import 'package:flutter/material.dart';

/// Utility class for color operations with modern Flutter APIs
class ColorUtils {
  // Private constructor to prevent instantiation
  ColorUtils._();

  /// Gets the alpha component (0-1) from a color using modern API
  static double getAlpha(Color color) {
    return color.a;
  }

  /// Gets the red component (0-1) from a color using modern API
  static double getRed(Color color) {
    return color.r;
  }

  /// Gets the green component (0-1) from a color using modern API
  static double getGreen(Color color) {
    return color.g;
  }

  /// Gets the blue component (0-1) from a color using modern API
  static double getBlue(Color color) {
    return color.b;
  }

  /// Creates a color with opacity using modern withValues() method
  static Color withOpacity(Color color, double opacity) {
    final clampedOpacity = opacity.clamp(0.0, 1.0);
    return color.withValues(alpha: clampedOpacity);
  }

  /// Creates a color with modified alpha (alias for withOpacity)
  static Color withAlpha(Color color, double alpha) {
    return withOpacity(color, alpha);
  }

  /// Creates a color with opacity using the modern approach
  static Color? withOpacityNullable(Color? color, double opacity) {
    if (color == null) return null;
    return withOpacity(color, opacity);
  }

  /// Blends two colors with a given factor (0.0 = color1, 1.0 = color2)
  static Color blendColors(Color color1, Color color2, double factor) {
    final clampedFactor = factor.clamp(0.0, 1.0);
    final inverseFactor = 1.0 - clampedFactor;

    final alpha1 = color1.a;
    final alpha2 = color2.a;
    final red1 = color1.r;
    final red2 = color2.r;
    final green1 = color1.g;
    final green2 = color2.g;
    final blue1 = color1.b;
    final blue2 = color2.b;

    return Color.fromARGB(
      ((alpha1 * inverseFactor + alpha2 * clampedFactor) * 255).round(),
      ((red1 * inverseFactor + red2 * clampedFactor) * 255).round(),
      ((green1 * inverseFactor + green2 * clampedFactor) * 255).round(),
      ((blue1 * inverseFactor + blue2 * clampedFactor) * 255).round(),
    );
  }

  /// Darkens a color by a percentage (0.0 = original, 1.0 = black)
  static Color darken(Color color, double amount) {
    final factor = amount.clamp(0.0, 1.0);
    return Color.fromARGB(
      (color.a * 255).round(),
      (color.r * 255 * (1 - factor)).round(),
      (color.g * 255 * (1 - factor)).round(),
      (color.b * 255 * (1 - factor)).round(),
    );
  }

  /// Lightens a color by a percentage (0.0 = original, 1.0 = white)
  static Color lighten(Color color, double amount) {
    final factor = amount.clamp(0.0, 1.0);
    return Color.fromARGB(
      (color.a * 255).round(),
      ((color.r * 255) + (255 - (color.r * 255)) * factor).round(),
      ((color.g * 255) + (255 - (color.g * 255)) * factor).round(),
      ((color.b * 255) + (255 - (color.b * 255)) * factor).round(),
    );
  }

  /// Creates a color with modified values using modern API
  static Color withValues({
    required Color color,
    double? alpha,
    double? red,
    double? green,
    double? blue,
  }) {
    return Color.fromARGB(
      ((alpha ?? color.a) * 255).round(),
      ((red ?? color.r) * 255).round(),
      ((green ?? color.g) * 255).round(),
      ((blue ?? color.b) * 255).round(),
    );
  }

  /// Creates a color from hex string (e.g., "#FF0000" or "FF0000")
  static Color fromHex(String hexString) {
    String hex = hexString.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) hex = 'FF${hex.padLeft(6, '0')}';
    return Color(int.parse(hex, radix: 16));
  }

  /// Converts color to hex string using modern API
  static String toHex(Color color, {bool includeAlpha = true}) {
    final alpha = includeAlpha ? (color.a * 255).toInt().toRadixString(16).padLeft(2, '0') : '';
    final red = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final green = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final blue = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue';
  }

  /// Gets the luminance of a color (0.0 to 1.0)
  static double getLuminance(Color color) {
    return color.computeLuminance();
  }

  /// Checks if a color is dark based on luminance
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Gets a contrasting text color (black or white) for a background color
  static Color getContrastingTextColor(Color backgroundColor) {
    return isDark(backgroundColor) ? Colors.white : Colors.black;
  }
}

/// Extension methods for Color to make usage more convenient
extension ColorExtension on Color {
  /// Returns the alpha component (0-1)
  double get alpha => a;

  /// Returns the red component (0-1)
  double get red => r;

  /// Returns the green component (0-1)
  double get green => g;

  /// Returns the blue component (0-1)
  double get blue => b;

  /// Returns a new color with the specified opacity
  Color withValuesOpacity(double opacity) {
    return ColorUtils.withOpacity(this, opacity);
  }

  /// Returns a darker version of this color
  Color darken(double amount) {
    return ColorUtils.darken(this, amount);
  }

  /// Returns a lighter version of this color
  Color lighten(double amount) {
    return ColorUtils.lighten(this, amount);
  }

  /// Blends this color with another color
  Color blendWith(Color other, double factor) {
    return ColorUtils.blendColors(this, other, factor);
  }

  /// Returns the hex string representation of this color
  String toHex({bool includeAlpha = true}) {
    return ColorUtils.toHex(this, includeAlpha: includeAlpha);
  }

  /// Checks if this color is dark
  bool get isDark => ColorUtils.isDark(this);

  /// Gets a contrasting text color (black or white)
  Color get contrastingTextColor => ColorUtils.getContrastingTextColor(this);
}

/// Extension for nullable colors
extension NullableColorExtension on Color? {
  /// Returns the color with opacity, or null if the color is null
  Color? withValuesOpacity(double opacity) {
    if (this == null) return null;
    return ColorUtils.withOpacity(this!, opacity);
  }
}