
import 'package:flutter/material.dart';
import '../widgets/indicator.dart';
import 'selection_mode.dart';

/// Configuration class for customizing the dropdown appearance and behavior
class MultiDropDownConfig {
  // ==================== ANIMATION PROPERTIES ====================

  /// Duration of the opening animation
  final Duration duration;

  /// Duration of the closing animation
  final Duration reverseDuration;

  /// Animation curve for opening
  final Curve curve;

  /// Animation curve for closing
  final Curve reverseCurve;

  // ==================== APPEARANCE PROPERTIES ====================

  /// Background color of the selector
  final Color backgroundColor;

  /// Highlight color for selection and focus
  final Color highlightColor;

  /// Blur intensity for glass effects
  final double blurIntensity;

  /// Gradient colors for gradient backgrounds
  final List<Color> gradientColors;

  /// Custom gradient for background
  final Gradient? gradient;

  /// Depth for 3D effects
  final double depth;

  /// Color for glow effects
  final Color glowColor;

  /// Intensity of the glow effect
  final double glowIntensity;

  /// Border radius of the selector
  final BorderRadius borderRadius;

  /// Border radius of the dropdown menu
  final BorderRadius dropdownBorderRadius;

  /// Background color of the dropdown menu
  final Color dropdownBackgroundColor;

  /// Border of the selector
  final Border border;

  /// Border of the dropdown menu
  final Border dropdownBorder;

  // ==================== SHADOW PROPERTIES ====================

  /// Spread radius for shadows
  final double spreadRadius;

  /// Blur radius for shadows
  final double blurRadius;

  /// Offset for shadows
  final Offset shadowOffset;

  /// Color for shadows
  final Color shadowColor;

  /// List of shadows for the selector
  final List<BoxShadow> shadows;

  /// List of shadows for the dropdown
  final List<BoxShadow> dropdownShadows;

  /// Elevation for material design
  final double elevation;

  // ==================== SIZING PROPERTIES ====================

  /// Maximum height of the dropdown menu
  final double maxDropdownHeight;

  /// Width of the dropdown menu
  final double dropdownWidth;

  /// Height of the selector
  final double selectorHeight;

  /// Width of the selector
  final double selectorWidth;

  // ==================== DIVIDER PROPERTIES ====================

  /// Whether to show dividers between items
  final bool showDivider;

  /// Color of the dividers
  final Color dividerColor;

  /// Thickness of the dividers
  final double dividerThickness;

  // ==================== PADDING PROPERTIES ====================

  /// Padding for the selector content
  final EdgeInsets padding;

  /// Padding for each dropdown item
  final EdgeInsets itemPadding;

  // ==================== TEXT STYLES ====================

  /// Text style for hint text
  final TextStyle hintStyle;

  /// Text style for selected items
  final TextStyle selectedItemStyle;

  /// Text style for regular items
  final TextStyle itemStyle;

  // ==================== SELECTION PROPERTIES ====================

  /// Selection mode (single or multiple)
  final SelectionMode selectionMode;

  /// Type of selection indicator
  final IndicatorType selectedIndicator;

  /// Size of the selection indicator
  final double indicatorSize;

  /// Color of the indicator when selected
  final Color indicatorActiveColor;

  /// Color of the indicator when not selected
  final Color indicatorInactiveColor;

  /// Whether to show a checkmark next to selected items
  final bool showCheckmark;

  /// Custom checkmark widget
  final Widget? customCheckmark;

  /// Custom indicator widget
  final Widget? customIndicator;

  // ==================== CHIP PROPERTIES ====================

  /// Whether to show selected items as chips in multi-select mode
  final bool showSelectedItemsAsChips;

  /// Padding for chips
  final EdgeInsets chipPadding;

  /// Spacing between chips
  final double chipSpacing;

  /// Run spacing for chips
  final double chipRunSpacing;

  /// Border radius for chips
  final BorderRadius? chipBorderRadius;

  /// Background color for chips
  final Color? chipColor;

  /// Background color for selected chips
  final Color? chipSelectedColor;

  /// Text style for chip labels
  final TextStyle? chipLabelStyle;

  /// Text style for selected chip labels
  final TextStyle? chipSelectedLabelStyle;

  /// Delete icon for chips
  final Widget? chipDeleteIcon;

  // ==================== SEARCH PROPERTIES ====================

  /// Whether to enable search functionality
  final bool enableSearch;

  /// Hint text for search field
  final String searchHintText;

  /// Text style for search input
  final TextStyle searchTextStyle;

  /// Background color of search field
  final Color searchBackgroundColor;

  /// Cursor color in search field
  final Color searchCursorColor;

  /// Decoration color for search field
  final Color searchDecorationColor;

  // ==================== MISCELLANEOUS ====================

  /// Leading icon to display in selector
  final Widget? leadingIcon;

  /// Whether to enable haptic feedback on interactions
  final bool enableHapticFeedback;

  const MultiDropDownConfig({
    // Animation defaults
    this.duration = const Duration(milliseconds: 400),
    this.reverseDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,

    // Appearance defaults
    this.backgroundColor = const Color(0x22FFFFFF),
    this.highlightColor = const Color(0xFF6200EE),
    this.blurIntensity = 5.0,
    this.gradientColors = const [Color(0xFF6200EE), Color(0xFFBB86FC)],
    this.gradient,
    this.depth = 5.0,
    this.glowColor = Colors.cyan,
    this.glowIntensity = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.dropdownBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.dropdownBackgroundColor = Colors.white,
    this.border = const Border.fromBorderSide(
      BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
    ),
    this.dropdownBorder = const Border.fromBorderSide(
      BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
    ),

    // Shadow defaults
    this.spreadRadius = 2.0,
    this.blurRadius = 10.0,
    this.shadowOffset = const Offset(0, 4),
    this.shadowColor = Colors.black,
    this.shadows = const [
      BoxShadow(
        color: Colors.black54,
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.dropdownShadows = const [
      BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
    ],
    this.elevation = 8.0,

    // Sizing defaults
    this.maxDropdownHeight = 200.0,
    this.dropdownWidth = double.infinity,
    this.selectorHeight = 48.0,
    this.selectorWidth = double.infinity,

    // Divider defaults
    this.showDivider = true,
    this.dividerColor = Colors.white,
    this.dividerThickness = 1.0,

    // Padding defaults
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.itemPadding = const EdgeInsets.all(16),

    // Text style defaults
    this.hintStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.selectedItemStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.itemStyle = const TextStyle(color: Colors.black, fontSize: 16),

    // Selection defaults
    this.selectionMode = SelectionMode.single,
    this.selectedIndicator = IndicatorType.checkmark,
    this.indicatorSize = 20.0,
    this.indicatorActiveColor = const Color(0xFF6200EE),
    this.indicatorInactiveColor = const Color(0xFFE0E0E0),
    this.showCheckmark = true,
    this.customCheckmark,
    this.customIndicator,

    // Chip defaults
    this.showSelectedItemsAsChips = true,
    this.chipPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.chipSpacing = 8.0,
    this.chipRunSpacing = 8.0,
    this.chipBorderRadius,
    this.chipColor,
    this.chipSelectedColor,
    this.chipLabelStyle,
    this.chipSelectedLabelStyle,
    this.chipDeleteIcon,

    // Search defaults
    this.enableSearch = false,
    this.searchHintText = 'Search...',
    this.searchTextStyle = const TextStyle(color: Colors.black),
    this.searchBackgroundColor = Colors.white,
    this.searchCursorColor = Colors.blue,
    this.searchDecorationColor = Colors.grey,

    // Miscellaneous defaults
    this.leadingIcon,
    this.enableHapticFeedback = false,
  });

  /// Creates a copy of this config with the given fields replaced
  MultiDropDownConfig copyWith({
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
    Color? backgroundColor,
    Color? highlightColor,
    double? blurIntensity,
    List<Color>? gradientColors,
    Gradient? gradient,
    double? depth,
    Color? glowColor,
    double? glowIntensity,
    BorderRadius? borderRadius,
    BorderRadius? dropdownBorderRadius,
    Color? dropdownBackgroundColor,
    Border? border,
    Border? dropdownBorder,
    double? spreadRadius,
    double? blurRadius,
    Offset? shadowOffset,
    Color? shadowColor,
    List<BoxShadow>? shadows,
    List<BoxShadow>? dropdownShadows,
    double? elevation,
    double? maxDropdownHeight,
    double? dropdownWidth,
    double? selectorHeight,
    double? selectorWidth,
    bool? showDivider,
    Color? dividerColor,
    double? dividerThickness,
    EdgeInsets? padding,
    EdgeInsets? itemPadding,
    TextStyle? hintStyle,
    TextStyle? selectedItemStyle,
    TextStyle? itemStyle,
    SelectionMode? selectionMode,
    IndicatorType? selectedIndicator,
    double? indicatorSize,
    Color? indicatorActiveColor,
    Color? indicatorInactiveColor,
    bool? showCheckmark,
    Widget? customCheckmark,
    Widget? customIndicator,
    bool? showSelectedItemsAsChips,
    EdgeInsets? chipPadding,
    double? chipSpacing,
    double? chipRunSpacing,
    BorderRadius? chipBorderRadius,
    Color? chipColor,
    Color? chipSelectedColor,
    TextStyle? chipLabelStyle,
    TextStyle? chipSelectedLabelStyle,
    Widget? chipDeleteIcon,
    bool? enableSearch,
    String? searchHintText,
    TextStyle? searchTextStyle,
    Color? searchBackgroundColor,
    Color? searchCursorColor,
    Color? searchDecorationColor,
    Widget? leadingIcon,
    bool? enableHapticFeedback,
  }) {
    return MultiDropDownConfig(
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      highlightColor: highlightColor ?? this.highlightColor,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      gradientColors: gradientColors ?? this.gradientColors,
      gradient: gradient ?? this.gradient,
      depth: depth ?? this.depth,
      glowColor: glowColor ?? this.glowColor,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      borderRadius: borderRadius ?? this.borderRadius,
      dropdownBorderRadius: dropdownBorderRadius ?? this.dropdownBorderRadius,
      dropdownBackgroundColor: dropdownBackgroundColor ?? this.dropdownBackgroundColor,
      border: border ?? this.border,
      dropdownBorder: dropdownBorder ?? this.dropdownBorder,
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowColor: shadowColor ?? this.shadowColor,
      shadows: shadows ?? this.shadows,
      dropdownShadows: dropdownShadows ?? this.dropdownShadows,
      elevation: elevation ?? this.elevation,
      maxDropdownHeight: maxDropdownHeight ?? this.maxDropdownHeight,
      dropdownWidth: dropdownWidth ?? this.dropdownWidth,
      selectorHeight: selectorHeight ?? this.selectorHeight,
      selectorWidth: selectorWidth ?? this.selectorWidth,
      showDivider: showDivider ?? this.showDivider,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      padding: padding ?? this.padding,
      itemPadding: itemPadding ?? this.itemPadding,
      hintStyle: hintStyle ?? this.hintStyle,
      selectedItemStyle: selectedItemStyle ?? this.selectedItemStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedIndicator: selectedIndicator ?? this.selectedIndicator,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      indicatorActiveColor: indicatorActiveColor ?? this.indicatorActiveColor,
      indicatorInactiveColor: indicatorInactiveColor ?? this.indicatorInactiveColor,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      customCheckmark: customCheckmark ?? this.customCheckmark,
      customIndicator: customIndicator ?? this.customIndicator,
      showSelectedItemsAsChips: showSelectedItemsAsChips ?? this.showSelectedItemsAsChips,
      chipPadding: chipPadding ?? this.chipPadding,
      chipSpacing: chipSpacing ?? this.chipSpacing,
      chipRunSpacing: chipRunSpacing ?? this.chipRunSpacing,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipColor: chipColor ?? this.chipColor,
      chipSelectedColor: chipSelectedColor ?? this.chipSelectedColor,
      chipLabelStyle: chipLabelStyle ?? this.chipLabelStyle,
      chipSelectedLabelStyle: chipSelectedLabelStyle ?? this.chipSelectedLabelStyle,
      chipDeleteIcon: chipDeleteIcon ?? this.chipDeleteIcon,
      enableSearch: enableSearch ?? this.enableSearch,
      searchHintText: searchHintText ?? this.searchHintText,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      searchBackgroundColor: searchBackgroundColor ?? this.searchBackgroundColor,
      searchCursorColor: searchCursorColor ?? this.searchCursorColor,
      searchDecorationColor: searchDecorationColor ?? this.searchDecorationColor,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }
}