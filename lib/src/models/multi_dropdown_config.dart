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

  /// Whether to show a checkmark next to selected items
  final bool showCheckmark;

  /// Custom checkmark widget
  final Widget? customCheckmark;

  /// Configuration for the selection indicator
  final IndicatorConfig indicatorConfig;

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

  // ==================== CONSTRUCTOR ====================

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
    this.showCheckmark = true,
    this.customCheckmark,
    this.indicatorConfig = const IndicatorConfig(
      type: IndicatorType.checkmark,
      size: 20.0,
      activeColor: Color(0xFF6200EE),
      inactiveColor: Color(0xFFE0E0E0),
    ),

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

  // ==================== HELPER GETTERS ====================

  /// Returns whether the indicator should use radio style
  bool get isRadioIndicator => selectionMode == SelectionMode.single;

  /// Returns whether the indicator should use checkbox style
  bool get isCheckboxIndicator => selectionMode == SelectionMode.multiple;

  // ==================== COPY WITH METHOD ====================

  /// Creates a copy of this config with the given fields replaced
  MultiDropDownConfig copyWith({
    // Animation
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,

    // Appearance
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

    // Shadow
    double? spreadRadius,
    double? blurRadius,
    Offset? shadowOffset,
    Color? shadowColor,
    List<BoxShadow>? shadows,
    List<BoxShadow>? dropdownShadows,
    double? elevation,

    // Sizing
    double? maxDropdownHeight,
    double? dropdownWidth,
    double? selectorHeight,
    double? selectorWidth,

    // Divider
    bool? showDivider,
    Color? dividerColor,
    double? dividerThickness,

    // Padding
    EdgeInsets? padding,
    EdgeInsets? itemPadding,

    // Text
    TextStyle? hintStyle,
    TextStyle? selectedItemStyle,
    TextStyle? itemStyle,

    // Selection
    SelectionMode? selectionMode,
    bool? showCheckmark,
    Widget? customCheckmark,

    // Indicator
    IndicatorConfig? indicatorConfig,

    // Chip
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

    // Search
    bool? enableSearch,
    String? searchHintText,
    TextStyle? searchTextStyle,
    Color? searchBackgroundColor,
    Color? searchCursorColor,
    Color? searchDecorationColor,

    // Miscellaneous
    Widget? leadingIcon,
    bool? enableHapticFeedback,
  }) {
    return MultiDropDownConfig(
      // Animation
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,

      // Appearance
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
      dropdownBackgroundColor:
          dropdownBackgroundColor ?? this.dropdownBackgroundColor,
      border: border ?? this.border,
      dropdownBorder: dropdownBorder ?? this.dropdownBorder,

      // Shadow
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowColor: shadowColor ?? this.shadowColor,
      shadows: shadows ?? this.shadows,
      dropdownShadows: dropdownShadows ?? this.dropdownShadows,
      elevation: elevation ?? this.elevation,

      // Sizing
      maxDropdownHeight: maxDropdownHeight ?? this.maxDropdownHeight,
      dropdownWidth: dropdownWidth ?? this.dropdownWidth,
      selectorHeight: selectorHeight ?? this.selectorHeight,
      selectorWidth: selectorWidth ?? this.selectorWidth,

      // Divider
      showDivider: showDivider ?? this.showDivider,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerThickness: dividerThickness ?? this.dividerThickness,

      // Padding
      padding: padding ?? this.padding,
      itemPadding: itemPadding ?? this.itemPadding,

      // Text
      hintStyle: hintStyle ?? this.hintStyle,
      selectedItemStyle: selectedItemStyle ?? this.selectedItemStyle,
      itemStyle: itemStyle ?? this.itemStyle,

      // Selection
      selectionMode: selectionMode ?? this.selectionMode,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      customCheckmark: customCheckmark ?? this.customCheckmark,

      // Indicator
      indicatorConfig: indicatorConfig ?? this.indicatorConfig,

      // Chip
      showSelectedItemsAsChips:
          showSelectedItemsAsChips ?? this.showSelectedItemsAsChips,
      chipPadding: chipPadding ?? this.chipPadding,
      chipSpacing: chipSpacing ?? this.chipSpacing,
      chipRunSpacing: chipRunSpacing ?? this.chipRunSpacing,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipColor: chipColor ?? this.chipColor,
      chipSelectedColor: chipSelectedColor ?? this.chipSelectedColor,
      chipLabelStyle: chipLabelStyle ?? this.chipLabelStyle,
      chipSelectedLabelStyle:
          chipSelectedLabelStyle ?? this.chipSelectedLabelStyle,
      chipDeleteIcon: chipDeleteIcon ?? this.chipDeleteIcon,

      // Search
      enableSearch: enableSearch ?? this.enableSearch,
      searchHintText: searchHintText ?? this.searchHintText,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      searchBackgroundColor:
          searchBackgroundColor ?? this.searchBackgroundColor,
      searchCursorColor: searchCursorColor ?? this.searchCursorColor,
      searchDecorationColor:
          searchDecorationColor ?? this.searchDecorationColor,

      // Miscellaneous
      leadingIcon: leadingIcon ?? this.leadingIcon,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }

  // ==================== INDICATOR PRESET METHODS ====================

  /// Creates a copy with classic checkbox indicator
  MultiDropDownConfig withClassicCheckbox({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.checkbox(
        activeColor: activeColor ?? indicatorConfig.activeColor,
      ).copyWith(type: IndicatorType.classic),
    );
  }

  /// Creates a copy with modern checkbox indicator
  MultiDropDownConfig withModernCheckbox({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.checkbox(
        activeColor: activeColor ?? indicatorConfig.activeColor,
      ),
    );
  }

  /// Creates a copy with dot checkbox indicator
  MultiDropDownConfig withDotCheckbox({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.dotCheckbox(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: indicatorConfig.size,
      ),
    );
  }

  /// Creates a copy with square checkbox indicator
  MultiDropDownConfig withSquareCheckbox({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.squareCheckbox(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: indicatorConfig.size,
      ),
    );
  }

  /// Creates a copy with classic radio indicator
  MultiDropDownConfig withClassicRadio({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.radio(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: indicatorConfig.size,
      ).copyWith(type: IndicatorType.radioClassic),
    );
  }

  /// Creates a copy with checkmark radio indicator
  MultiDropDownConfig withCheckmarkRadio({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.radio(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: indicatorConfig.size,
      ).copyWith(type: IndicatorType.radioCheckmark),
    );
  }

  /// Creates a copy with dot radio indicator
  MultiDropDownConfig withDotRadio({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.dotRadio(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: indicatorConfig.size,
      ),
    );
  }

  /// Creates a copy with toggle indicator
  MultiDropDownConfig withToggle({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.toggle(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: 28,
      ),
    );
  }

  /// Creates a copy with switch indicator
  MultiDropDownConfig withSwitch({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.switchStyle(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: 32,
      ),
    );
  }

  /// Creates a copy with gradient indicator
  MultiDropDownConfig withGradient({
    required List<Color> colors,
    double? size,
  }) {
    return copyWith(
      indicatorConfig: IndicatorConfig.gradient(
        colors: colors,
        size: size ?? indicatorConfig.size,
        isRadio: selectionMode == SelectionMode.single,
      ),
    );
  }

  /// Creates a copy with neumorphic indicator
  MultiDropDownConfig withNeumorphic({Color? activeColor}) {
    return copyWith(
      indicatorConfig: IndicatorConfig.neumorphic(
        activeColor: activeColor ?? indicatorConfig.activeColor,
        size: 24,
        isRadio: selectionMode == SelectionMode.single,
      ),
    );
  }

  /// Creates a copy with custom indicator
  MultiDropDownConfig withCustomIndicator({
    required WidgetBuilder builder,
    double? size,
  }) {
    return copyWith(
      indicatorConfig: IndicatorConfig.custom(
        builder: builder,
        size: size ?? indicatorConfig.size,
      ),
    );
  }
}
