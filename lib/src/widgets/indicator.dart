import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_multi_dropdown/src/models/selection_mode.dart';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';

/// Type of selection indicator to display
enum IndicatorType {
  // Checkbox styles
  /// Classic checkbox with checkmark
  classic,

  /// Modern checkbox with checkmark
  checkmark,

  /// Checkbox with a dot indicator
  dot,

  /// Square checkbox with custom border radius
  square,

  // Radio styles
  /// Classic radio button (filled circle)
  radioClassic,

  /// Radio button with checkmark
  radioCheckmark,

  /// Radio button with dot indicator
  radioDot,

  /// Square radio button
  radioSquare,

  // Special styles
  /// Gradient dot indicator
  gradient,

  /// Simple tick icon
  tick,

  /// Filled circle
  filled,

  /// Outlined circle with optional checkmark
  outlined,

  /// Neumorphic style indicator
  neumorphic,

  /// Switch style indicator
  switchStyle,

  /// Toggle button style
  toggle,

  /// Custom indicator (requires customBuilder)
  custom,
}

/// Configuration class for selection indicators
class IndicatorConfig {
  // ==================== BASIC PROPERTIES ====================

  /// Type of indicator to display
  final IndicatorType type;

  /// Whether this is a radio button (single selection)
  final bool isRadio;

  /// Whether this is a checkbox (multiple selection)
  final bool isCheckbox;

  // ==================== COLOR PROPERTIES ====================

  /// Color when selected
  final Color activeColor;

  /// Color when not selected
  final Color inactiveColor;

  /// Optional gradient colors for gradient indicator
  final List<Color>? gradientColors;

  // ==================== SIZE & SHAPE PROPERTIES ====================

  /// Size of the indicator in pixels
  final double size;

  /// Border radius for square indicators
  final BorderRadius borderRadius;

  /// Border width for outlined indicators
  final double borderWidth;

  // ==================== VISUAL ELEMENTS ====================

  /// Whether to show a checkmark when selected
  final bool showCheckmark;

  /// Whether to show a dot when selected
  final bool showDot;

  /// Size of the dot as a fraction of indicator size (0.0 to 1.0)
  final double dotSize;

  // ==================== ANIMATION ====================

  /// Whether to animate changes
  final bool animateChanges;

  // ==================== CUSTOM INDICATOR ====================

  /// Custom builder for custom indicator type
  final WidgetBuilder? customBuilder;

  // ==================== CONSTRUCTOR ====================

  const IndicatorConfig({
    required this.type,
    this.isRadio = false,
    this.isCheckbox = false,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.gradientColors,
    this.size = 20.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.borderWidth = 2.0,
    this.showCheckmark = true,
    this.showDot = true,
    this.dotSize = 0.6,
    this.animateChanges = true,
    this.customBuilder,
  }) : assert(
          type != IndicatorType.custom || customBuilder != null,
          'Custom builder must be provided for custom indicator type',
        );

  // ==================== FACTORY METHODS ====================

  /// Creates a classic checkbox indicator
  factory IndicatorConfig.checkbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
    BorderRadius? borderRadius,
  }) {
    return IndicatorConfig(
      type: IndicatorType.checkmark,
      isCheckbox: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(4)),
    );
  }

  /// Creates a classic radio indicator
  factory IndicatorConfig.radio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioClassic,
      isRadio: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.zero,
    );
  }

  /// Creates a dot style checkbox indicator
  factory IndicatorConfig.dotCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.dot,
      isCheckbox: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      showCheckmark: false,
      showDot: true,
      dotSize: 0.6,
    );
  }

  /// Creates a dot style radio indicator
  factory IndicatorConfig.dotRadio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioDot,
      isRadio: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      showCheckmark: false,
      showDot: true,
      dotSize: 0.6,
    );
  }

  /// Creates a gradient indicator
  factory IndicatorConfig.gradient({
    required List<Color> colors,
    double? size,
    bool isRadio = false,
  }) {
    return IndicatorConfig(
      type: IndicatorType.gradient,
      isRadio: isRadio,
      isCheckbox: !isRadio,
      activeColor: colors.first,
      inactiveColor: Colors.grey,
      gradientColors: colors,
      size: size ?? 20,
    );
  }

  /// Creates a toggle style indicator
  factory IndicatorConfig.toggle({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.toggle,
      isRadio: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 24,
    );
  }

  /// Creates a switch style indicator
  factory IndicatorConfig.switchStyle({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.switchStyle,
      isRadio: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 28,
    );
  }

  /// Creates a neumorphic style indicator
  factory IndicatorConfig.neumorphic({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
    bool isRadio = false,
  }) {
    return IndicatorConfig(
      type: IndicatorType.neumorphic,
      isRadio: isRadio,
      isCheckbox: !isRadio,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 24,
    );
  }

  /// Creates a square checkbox indicator
  factory IndicatorConfig.squareCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.square,
      isCheckbox: true,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
    );
  }

  /// Creates a custom indicator
  factory IndicatorConfig.custom({
    required WidgetBuilder builder,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.custom,
      size: size ?? 20,
      customBuilder: builder,
    );
  }

  // ==================== COPY WITH METHOD ====================

  /// Creates a copy of this config with the given fields replaced
  IndicatorConfig copyWith({
    IndicatorType? type,
    bool? isRadio,
    bool? isCheckbox,
    Color? activeColor,
    Color? inactiveColor,
    List<Color>? gradientColors,
    double? size,
    BorderRadius? borderRadius,
    double? borderWidth,
    bool? showCheckmark,
    bool? showDot,
    double? dotSize,
    bool? animateChanges,
    WidgetBuilder? customBuilder,
  }) {
    return IndicatorConfig(
      type: type ?? this.type,
      isRadio: isRadio ?? this.isRadio,
      isCheckbox: isCheckbox ?? this.isCheckbox,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      gradientColors: gradientColors ?? this.gradientColors,
      size: size ?? this.size,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      showDot: showDot ?? this.showDot,
      dotSize: dotSize ?? this.dotSize,
      animateChanges: animateChanges ?? this.animateChanges,
      customBuilder: customBuilder ?? this.customBuilder,
    );
  }

  // ==================== HELPER METHODS ====================

  /// Returns the effective indicator style based on selection mode
  static IndicatorConfig forSelectionMode({
    required SelectionMode mode,
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    if (mode == SelectionMode.single) {
      return IndicatorConfig.radio(
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        size: size,
      );
    } else {
      return IndicatorConfig.checkbox(
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        size: size,
      );
    }
  }

  // ==================== EQUALITY & HASHCODE ====================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IndicatorConfig &&
        other.type == type &&
        other.isRadio == isRadio &&
        other.isCheckbox == isCheckbox &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        listEquals(other.gradientColors, gradientColors) &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.borderWidth == borderWidth &&
        other.showCheckmark == showCheckmark &&
        other.showDot == showDot &&
        other.dotSize == dotSize &&
        other.animateChanges == animateChanges;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      isRadio,
      isCheckbox,
      activeColor,
      inactiveColor,
      gradientColors,
      size,
      borderRadius,
      borderWidth,
      showCheckmark,
      showDot,
      dotSize,
      animateChanges,
    );
  }
}

class IndicatorWidget extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;
  final IndicatorConfig config;
  final bool isRadioGroup; // For proper radio button behavior

  const IndicatorWidget({
    super.key,
    required this.isSelected,
    required this.isEnabled,
    required this.config,
    this.isRadioGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    if (config.type == IndicatorType.custom) {
      return config.customBuilder!(context);
    }

    final effectiveColor = isEnabled
        ? (isSelected ? config.activeColor : config.inactiveColor)
        : (isSelected
            ? config.activeColor.withValuesOpacity(0.5)
            : config.inactiveColor.withValuesOpacity(0.5));

    final isRadioStyle = config.isRadio ||
        config.type.toString().contains('radio') ||
        isRadioGroup;

    return AnimatedContainer(
      duration: config.animateChanges
          ? const Duration(milliseconds: 200)
          : Duration.zero,
      child: _buildIndicator(effectiveColor, isRadioStyle),
    );
  }

  Widget _buildIndicator(Color color, bool isRadioStyle) {
    switch (config.type) {
      case IndicatorType.classic:
        return _buildClassicIndicator(color, isRadioStyle);
      case IndicatorType.checkmark:
        return _buildCheckmarkIndicator(color, isRadioStyle);
      case IndicatorType.dot:
        return _buildDotIndicator(color, isRadioStyle);
      case IndicatorType.square:
        return _buildSquareIndicator(color, isRadioStyle);
      case IndicatorType.radioClassic:
        return _buildClassicRadio(color);
      case IndicatorType.radioCheckmark:
        return _buildCheckmarkRadio(color);
      case IndicatorType.radioDot:
        return _buildDotRadio(color);
      case IndicatorType.radioSquare:
        return _buildSquareRadio(color);
      case IndicatorType.gradient:
        return _buildGradientIndicator();
      case IndicatorType.tick:
        return _buildTickIndicator(color);
      case IndicatorType.filled:
        return _buildFilledIndicator(color);
      case IndicatorType.outlined:
        return _buildOutlinedIndicator(color);
      case IndicatorType.neumorphic:
        return _buildNeumorphicIndicator(color);
      case IndicatorType.switchStyle:
        return _buildSwitchIndicator(color);
      case IndicatorType.toggle:
        return _buildToggleIndicator(color);
      case IndicatorType.custom:
        return const SizedBox.shrink(); // Handled in build()
    }
  }

  // ========================
  // Common Indicator Builders
  // ========================

  Widget _buildBaseIndicator({
    required Color color,
    bool isRadio = false,
    bool filled = false,
    Widget? child,
  }) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: isRadio ? null : config.borderRadius,
        shape: isRadio ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: child,
    );
  }

  Widget _buildInnerIndicator({
    required bool isSelected,
    required Color color,
    bool isRadio = false,
    bool isCheckmark = false,
    bool isDot = false,
  }) {
    if (!isSelected) return const SizedBox.shrink();

    if (isCheckmark && config.showCheckmark) {
      return Icon(
        Icons.check,
        size: config.size * 0.7,
        color: Colors.white,
      );
    }

    if (isDot && config.showDot) {
      return Center(
        child: Container(
          width: config.size * config.dotSize,
          height: config.size * config.dotSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: isRadio ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isRadio ? null : BorderRadius.circular(2),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ========================
  // Specific Indicator Types
  // ========================

  // Classic checkbox/radio
  Widget _buildClassicIndicator(Color color, bool isRadio) {
    return _buildBaseIndicator(
      color: color,
      isRadio: isRadio,
      child: _buildInnerIndicator(
        isSelected: isSelected,
        color: color,
        isRadio: isRadio,
        isCheckmark: !isRadio,
      ),
    );
  }

  // Checkmark style
  Widget _buildCheckmarkIndicator(Color color, bool isRadio) {
    return _buildBaseIndicator(
      color: color,
      isRadio: isRadio,
      child: _buildInnerIndicator(
        isSelected: isSelected,
        color: color,
        isRadio: isRadio,
        isCheckmark: true,
      ),
    );
  }

  // Dot style
  Widget _buildDotIndicator(Color color, bool isRadio) {
    return _buildBaseIndicator(
      color: color,
      isRadio: isRadio,
      child: _buildInnerIndicator(
        isSelected: isSelected,
        color: color,
        isRadio: isRadio,
        isDot: true,
      ),
    );
  }

  // Square style
  Widget _buildSquareIndicator(Color color, bool isRadio) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: config.borderRadius,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: isSelected
          ? Center(
              child: Icon(
                Icons.check,
                size: config.size * 0.7,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  // Radio indicators
  Widget _buildClassicRadio(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? config.size * 0.6 : 0,
          height: isSelected ? config.size * 0.6 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckmarkRadio(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? color.withValuesOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: config.size * 0.7,
              color: color,
            )
          : null,
    );
  }

  Widget _buildDotRadio(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? color.withValuesOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? config.size * 0.6 : 0,
          height: isSelected ? config.size * 0.6 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildSquareRadio(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        borderRadius: config.borderRadius,
        color: isSelected ? color.withValuesOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? config.size * 0.6 : 0,
          height: isSelected ? config.size * 0.6 : 0,
          decoration: BoxDecoration(
            borderRadius: config.borderRadius,
            color: color,
          ),
        ),
      ),
    );
  }

  // Gradient style
  Widget _buildGradientIndicator() {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected && config.gradientColors != null
            ? LinearGradient(
                colors: config.gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : config.inactiveColor,
        border: Border.all(
          color: isSelected ? Colors.transparent : config.inactiveColor,
          width: config.borderWidth,
        ),
      ),
    );
  }

  // Tick style
  Widget _buildTickIndicator(Color color) {
    return Icon(
      isSelected ? Icons.check : Icons.check_box_outline_blank,
      color: color,
      size: config.size,
    );
  }

  // Filled style
  Widget _buildFilledIndicator(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // Outlined style
  Widget _buildOutlinedIndicator(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? color.withValuesOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: color,
          width: config.borderWidth,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: config.size * 0.6,
              color: color,
            )
          : null,
    );
  }

  // Neumorphic style

  // Alternative neumorphic style with square shape (no borderRadius conflict)
  Widget _buildNeumorphicIndicator(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: config.borderRadius, // This works with rectangle shape
        color: Colors.grey[200],
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? config.size * 0.6 : 0,
          height: isSelected ? config.size * 0.6 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  // Switch style
  Widget _buildSwitchIndicator(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: config.size * 1.8,
      height: config.size * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(config.size),
        color: isSelected ? color : Colors.grey[300],
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: config.size * 0.7,
            height: config.size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValuesOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggle style
  Widget _buildToggleIndicator(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: config.size * 1.5,
      height: config.size,
      decoration: BoxDecoration(
        borderRadius: config.borderRadius,
        color: isSelected ? color : Colors.grey[300],
        border: Border.all(
          color: isSelected ? color : Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isSelected ? config.size * 0.5 : 0,
            right: isSelected ? 0 : config.size * 0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: config.borderRadius,
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValuesOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef IndicatorBuilder = Widget Function(
  BuildContext context,
  bool isSelected,
  bool isEnabled,
  IndicatorConfig config,
);

class CustomIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;
  final IndicatorConfig config;
  final IndicatorBuilder? builder;
  final bool isRadioGroup;

  const CustomIndicator({
    super.key,
    required this.isSelected,
    required this.isEnabled,
    required this.config,
    this.builder,
    this.isRadioGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return builder?.call(context, isSelected, isEnabled, config) ??
        config.customBuilder?.call(context) ??
        IndicatorWidget(
          isSelected: isSelected,
          isEnabled: isEnabled,
          config: config,
          isRadioGroup: isRadioGroup,
        );
  }
}

class IndicatorPresets {
  /// Classic checkbox indicator
  static IndicatorConfig classicCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.classic,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.circular(4),
      showCheckmark: true,
      isRadio: false,
      isCheckbox: true,
    );
  }

  /// Modern checkbox with checkmark
  static IndicatorConfig modernCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.checkmark,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.circular(6),
      showCheckmark: true,
      isRadio: false,
      isCheckbox: true,
    );
  }

  /// Dot style checkbox
  static IndicatorConfig dotCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.dot,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.circular(4),
      showDot: true,
      dotSize: 0.6,
      isRadio: false,
      isCheckbox: true,
    );
  }

  /// Square checkbox
  static IndicatorConfig squareCheckbox({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.square,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.circular(4),
      showCheckmark: true,
      isRadio: false,
      isCheckbox: true,
    );
  }

  /// Classic radio button
  static IndicatorConfig classicRadio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioClassic,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      showCheckmark: false,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Radio with checkmark
  static IndicatorConfig checkmarkRadio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioCheckmark,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      showCheckmark: true,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Dot radio
  static IndicatorConfig dotRadio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioDot,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      showDot: true,
      dotSize: 0.6,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Square radio
  static IndicatorConfig squareRadio({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.radioSquare,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 20,
      borderRadius: BorderRadius.circular(4),
      showCheckmark: true,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Gradient indicator
  static IndicatorConfig gradient({
    required List<Color> colors,
    double? size,
    bool isRadio = false,
  }) {
    return IndicatorConfig(
      type: IndicatorType.gradient,
      activeColor: colors.first,
      inactiveColor: Colors.grey,
      gradientColors: colors,
      size: size ?? 20,
      isRadio: isRadio,
      isCheckbox: !isRadio,
    );
  }

  /// Toggle switch style
  static IndicatorConfig toggle({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.toggle,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 24,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Switch style
  static IndicatorConfig switchStyle({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    return IndicatorConfig(
      type: IndicatorType.switchStyle,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 28,
      isRadio: true,
      isCheckbox: false,
    );
  }

  /// Neumorphic style
  static IndicatorConfig neumorphic({
    Color? activeColor,
    Color? inactiveColor,
    double? size,
    bool isRadio = false,
  }) {
    return IndicatorConfig(
      type: IndicatorType.neumorphic,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.grey,
      size: size ?? 24,
      isRadio: isRadio,
      isCheckbox: !isRadio,
    );
  }
}
