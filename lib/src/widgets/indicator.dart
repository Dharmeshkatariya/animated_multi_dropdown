import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum IndicatorType {
  classic, // Classic checkbox with checkmark
  checkmark, // Circular checkbox with checkmark
  dot, // Checkbox with a dot indicator
  square, // Square checkbox with custom border radius
  radioClassic, // Classic radio button (filled circle)
  radioCheckmark, // Radio button with checkmark
  radioDot, // Radio button with dot indicator
  radioSquare, // Square radio button
  gradient, // Gradient dot indicator
  tick, // Simple tick icon
  filled, // Filled circle
  outlined, // Outlined circle with optional checkmark
  custom, // Custom indicator
  neumorphic, // Neumorphic style indicator
  switchStyle, // Switch style indicator
  toggle, // Toggle button style
}

class IndicatorConfig {
  final IndicatorType type;
  final Color activeColor;
  final Color inactiveColor;
  final List<Color>? gradientColors;
  final double size;
  final BorderRadius borderRadius;
  final double borderWidth;
  final WidgetBuilder? customBuilder;
  final bool showCheckmark;
  final bool showDot;
  final double dotSize;
  final bool isRadio; // Explicit radio style
  final bool isCheckbox; // Explicit checkbox style
  final bool animateChanges;

  const IndicatorConfig({
    required this.type,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.gradientColors,
    this.size = 24.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.borderWidth = 2.0,
    this.customBuilder,
    this.showCheckmark = true,
    this.showDot = true,
    this.dotSize = 0.5,
    this.isRadio = false,
    this.isCheckbox = false,
    this.animateChanges = true,
  }) : assert(
          type != IndicatorType.custom || customBuilder != null,
          'Custom builder must be provided for custom indicator type',
        );

  IndicatorConfig copyWith({
    IndicatorType? type,
    Color? activeColor,
    Color? inactiveColor,
    List<Color>? gradientColors,
    double? size,
    BorderRadius? borderRadius,
    double? borderWidth,
    WidgetBuilder? customBuilder,
    bool? showCheckmark,
    bool? showDot,
    double? dotSize,
    bool? isRadio,
    bool? isCheckbox,
    bool? animateChanges,
  }) {
    return IndicatorConfig(
      type: type ?? this.type,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      gradientColors: gradientColors ?? this.gradientColors,
      size: size ?? this.size,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      customBuilder: customBuilder ?? this.customBuilder,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      showDot: showDot ?? this.showDot,
      dotSize: dotSize ?? this.dotSize,
      isRadio: isRadio ?? this.isRadio,
      isCheckbox: isCheckbox ?? this.isCheckbox,
      animateChanges: animateChanges ?? this.animateChanges,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IndicatorConfig &&
        other.type == type &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        listEquals(other.gradientColors, gradientColors) &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.borderWidth == borderWidth &&
        other.showCheckmark == showCheckmark &&
        other.showDot == showDot &&
        other.dotSize == dotSize &&
        other.isRadio == isRadio &&
        other.isCheckbox == isCheckbox;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      activeColor,
      inactiveColor,
      gradientColors,
      size,
      borderRadius,
      borderWidth,
      showCheckmark,
      showDot,
      dotSize,
      isRadio,
      isCheckbox,
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
  Widget _buildNeumorphicIndicator(Color color) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        borderRadius: config.borderRadius,
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
