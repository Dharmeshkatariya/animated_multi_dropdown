import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899);
  static const Color accentLight = Color(0xFFF472B6);
  static const Color accentDark = Color(0xFFDB2777);

  // Success Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  // Warning Colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  // Error Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Info Colors
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Glass Effect Colors
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassBlack = Color(0x33000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [primary, secondary];
  static const List<Color> secondaryGradient = [secondary, accent];
  static const List<Color> successGradient = [success, successLight];
  static const List<Color> warningGradient = [warning, warningLight];
  static const List<Color> errorGradient = [error, errorLight];
  static const List<Color> infoGradient = [info, infoLight];
  static const List<Color> cyberGradient = [
    Color(0xFFEC4899),
    Color(0xFF06B6D4)
  ];
  static const List<Color> sunsetGradient = [
    Color(0xFFF59E0B),
    Color(0xFFEF4444)
  ];
  static const List<Color> oceanGradient = [
    Color(0xFF06B6D4),
    Color(0xFF3B82F6)
  ];
  static const List<Color> forestGradient = [
    Color(0xFF10B981),
    Color(0xFF3B82F6)
  ];
  static const List<Color> midnightGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6)
  ];
}

class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> extraLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> glass = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> neon(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.5),
          blurRadius: 10,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 1,
        ),
      ];
}
