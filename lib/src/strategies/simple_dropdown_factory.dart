import 'package:flutter/material.dart';
import '../widgets/custom_animated_multi_dropdown.dart';
import '../models/multi_dropdown_config.dart';
import '../models/selection_mode.dart';
import '../models/dropdown_animation_type.dart';
import '../widgets/indicator.dart';

/// Simple dropdown factory for creating dropdowns with minimal configuration
class SimpleDropdownFactory {
  /// Creates a simple single selection dropdown
  static Widget single<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Widget? hint,
    DropdownAnimationType animationType = DropdownAnimationType.glass,
    Color? highlightColor,
    BorderRadius? borderRadius,
    double? height,
    double? width,
    bool showCheckmark = true,
    IndicatorType indicatorType = IndicatorType.radioClassic,
    double? indicatorSize,
    Widget Function(BuildContext, bool isSelected, Color activeColor)? customIndicatorBuilder,
  }) {
    // Create a custom builder that captures the selection state
    WidgetBuilder? customBuilder;
    if (customIndicatorBuilder != null) {
      customBuilder = (context) {
        // This is a simplified approach - in reality, you'd need to access the selection state
        // from the dropdown's context. For now, we'll use a ValueNotifier approach
        return _CustomIndicatorWidget(
          builder: customIndicatorBuilder,
          highlightColor: highlightColor ?? Colors.blue,
        );
      };
    }

    return CustomAnimatedMultiDropDown<T>(
      animationType: animationType,
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: hint ?? (hintText != null ? Text(hintText) : null),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.single,
        highlightColor: highlightColor ?? Colors.blue,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        selectorHeight: height ?? 48,
        selectorWidth: width ?? double.infinity,
        showCheckmark: showCheckmark,
        indicatorConfig: IndicatorConfig(
          type: indicatorType,
          activeColor: highlightColor ?? Colors.blue,
          size: indicatorSize ?? 20,
          isRadio: true,
          isCheckbox: false,
          customBuilder: customBuilder,
        ),
      ),
    );
  }

  /// Creates a simple multiple selection dropdown
  static Widget multiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Widget? hint,
    DropdownAnimationType animationType = DropdownAnimationType.liquid,
    Color? highlightColor,
    BorderRadius? borderRadius,
    double? height,
    double? width,
    bool showChips = true,
    bool enableSearch = false,
    IndicatorType indicatorType = IndicatorType.checkmark,
    double? indicatorSize,
    Widget Function(BuildContext, bool isSelected, Color activeColor)? customIndicatorBuilder,
  }) {
    // Create a custom builder that captures the selection state
    WidgetBuilder? customBuilder;
    if (customIndicatorBuilder != null) {
      customBuilder = (context) {
        return _CustomIndicatorWidget(
          builder: customIndicatorBuilder,
          highlightColor: highlightColor ?? Colors.green,
        );
      };
    }

    return CustomAnimatedMultiDropDown<T>(
      animationType: animationType,
      items: items,
      value: value ?? [],
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: hint ?? (hintText != null ? Text(hintText) : null),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.multiple,
        highlightColor: highlightColor ?? Colors.green,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        selectorHeight: height ?? 48,
        selectorWidth: width ?? double.infinity,
        showSelectedItemsAsChips: showChips,
        enableSearch: enableSearch,
        indicatorConfig: IndicatorConfig(
          type: indicatorType,
          activeColor: highlightColor ?? Colors.green,
          size: indicatorSize ?? 20,
          isRadio: false,
          isCheckbox: true,
          customBuilder: customBuilder,
        ),
      ),
    );
  }

  /// Creates a single selection dropdown with radio button style
  static Widget radio<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
    double? size,
  }) {
    return single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      highlightColor: activeColor ?? Colors.blue,
      indicatorType: IndicatorType.radioClassic,
      indicatorSize: size,
    );
  }

  /// Creates a single selection dropdown with toggle style
  static Widget toggle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return CustomAnimatedMultiDropDown<T>(
      animationType: DropdownAnimationType.glass,
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: Text(hintText ?? 'Select an option'),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.single,
        highlightColor: activeColor ?? Colors.blue,
        selectorHeight: 56,
        indicatorConfig: IndicatorConfig.toggle(
          activeColor: activeColor ?? Colors.blue,
          size: 28,
        ),
      ),
    );
  }

  /// Creates a single selection dropdown with switch style
  static Widget switchStyle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return CustomAnimatedMultiDropDown<T>(
      animationType: DropdownAnimationType.liquid,
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: Text(hintText ?? 'Select an option'),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.single,
        highlightColor: activeColor ?? Colors.blue,
        selectorHeight: 56,
        indicatorConfig: IndicatorConfig.switchStyle(
          activeColor: activeColor ?? Colors.blue,
          size: 32,
        ),
      ),
    );
  }

  /// Creates a multiple selection dropdown with dot checkbox style
  static Widget dotCheckbox<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return multiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select items',
      highlightColor: activeColor ?? Colors.blue,
      indicatorType: IndicatorType.dot,
    );
  }

  /// Creates a multiple selection dropdown with gradient checkbox
  static Widget gradientCheckbox<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    required List<Color> gradientColors,
    String? hintText,
  }) {
    return CustomAnimatedMultiDropDown<T>(
      animationType: DropdownAnimationType.liquid,
      items: items,
      value: value ?? [],
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: Text(hintText ?? 'Select items'),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.multiple,
        highlightColor: gradientColors.first,
        indicatorConfig: IndicatorConfig.gradient(
          colors: gradientColors,
          size: 24,
          isRadio: false,
        ),
      ),
    );
  }

  /// Creates a single selection dropdown with gradient radio
  static Widget gradientRadio<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    required List<Color> gradientColors,
    String? hintText,
  }) {
    return CustomAnimatedMultiDropDown<T>(
      animationType: DropdownAnimationType.glass,
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: Text(hintText ?? 'Select an option'),
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.single,
        highlightColor: gradientColors.first,
        indicatorConfig: IndicatorConfig.gradient(
          colors: gradientColors,
          size: 24,
          isRadio: true,
        ),
      ),
    );
  }

  /// Creates a single selection dropdown with custom star icon indicator
  static Widget customStarSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      highlightColor: activeColor ?? Colors.amber,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: color,
          size: 24,
        );
      },
    );
  }

  /// Creates a single selection dropdown with custom heart icon indicator
  static Widget customHeartSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      highlightColor: activeColor ?? Colors.red,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? Icons.favorite : Icons.favorite_border,
            color: color,
            size: 24,
          ),
        );
      },
    );
  }

  /// Creates a single selection dropdown with custom diamond icon indicator
  static Widget customDiamondSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      highlightColor: activeColor ?? Colors.blue,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return Icon(
          isSelected ? Icons.diamond : Icons.diamond_outlined,
          color: color,
          size: 24,
        );
      },
    );
  }

  /// Creates a multiple selection dropdown with custom star icon indicator
  static Widget customStarMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return multiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select items',
      highlightColor: activeColor ?? Colors.amber,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: color,
          size: 24,
        );
      },
    );
  }

  /// Creates a multiple selection dropdown with custom heart icon indicator
  static Widget customHeartMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return multiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select favorites',
      highlightColor: activeColor ?? Colors.red,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? Icons.favorite : Icons.favorite_border,
            color: color,
            size: 24,
          ),
        );
      },
    );
  }

  /// Creates a multiple selection dropdown with custom diamond icon indicator
  static Widget customDiamondMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
    Color? activeColor,
  }) {
    return multiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select items',
      highlightColor: activeColor ?? Colors.blue,
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return Icon(
          isSelected ? Icons.diamond : Icons.diamond_outlined,
          color: color,
          size: 24,
        );
      },
    );
  }

  /// Creates a single selection dropdown with custom styling
  static Widget styledSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    required SimpleDropdownStyle style,
  }) {
    WidgetBuilder? customBuilder;
    if (style.customIndicatorBuilder != null) {
      customBuilder = (context) {
        return _CustomIndicatorWidget(
          builder: style.customIndicatorBuilder!,
          highlightColor: style.highlightColor,
        );
      };
    }

    return CustomAnimatedMultiDropDown<T>(
      animationType: style.animationType,
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: style.hint,
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.single,
        highlightColor: style.highlightColor,
        backgroundColor: style.backgroundColor,
        borderRadius: style.borderRadius,
        selectorHeight: style.height,
        selectorWidth: style.width,
        showCheckmark: style.showCheckmark,
        hintStyle: style.hintStyle ?? const TextStyle(),
        selectedItemStyle: style.selectedItemStyle ?? const TextStyle(),
        itemStyle: style.itemStyle ?? const TextStyle(),
        indicatorConfig: IndicatorConfig(
          type: style.indicatorType,
          activeColor: style.highlightColor,
          size: 20,
          isRadio: true,
          isCheckbox: false,
          customBuilder: customBuilder,
        ),
      ),
    );
  }

  /// Creates a multiple selection dropdown with custom styling
  static Widget styledMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    required SimpleDropdownStyle style,
  }) {
    WidgetBuilder? customBuilder;
    if (style.customIndicatorBuilder != null) {
      customBuilder = (context) {
        return _CustomIndicatorWidget(
          builder: style.customIndicatorBuilder!,
          highlightColor: style.highlightColor,
        );
      };
    }

    return CustomAnimatedMultiDropDown<T>(
      animationType: style.animationType,
      items: items,
      value: value ?? [],
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hint: style.hint,
      config: MultiDropDownConfig(
        selectionMode: SelectionMode.multiple,
        highlightColor: style.highlightColor,
        backgroundColor: style.backgroundColor,
        borderRadius: style.borderRadius,
        selectorHeight: style.height,
        selectorWidth: style.width,
        showSelectedItemsAsChips: style.showChips,
        enableSearch: style.enableSearch,
        hintStyle: style.hintStyle ?? const TextStyle(),
        selectedItemStyle: style.selectedItemStyle ?? const TextStyle(),
        itemStyle: style.itemStyle ?? const TextStyle(),
        chipColor: style.chipColor,
        chipLabelStyle: style.chipLabelStyle,
        indicatorConfig: IndicatorConfig(
          type: style.indicatorType,
          activeColor: style.highlightColor,
          size: 20,
          isRadio: false,
          isCheckbox: true,
          customBuilder: customBuilder,
        ),
      ),
    );
  }
}

/// Wrapper widget for custom indicators that captures selection state
class _CustomIndicatorWidget extends StatefulWidget {
  final Widget Function(BuildContext, bool, Color) builder;
  final Color highlightColor;

  const _CustomIndicatorWidget({
    required this.builder,
    required this.highlightColor,
  });

  @override
  State<_CustomIndicatorWidget> createState() => _CustomIndicatorWidgetState();
}

class _CustomIndicatorWidgetState extends State<_CustomIndicatorWidget> {
  bool _isSelected = false;
  Color _color = Colors.blue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is a simplified approach - in a real implementation,
    // you'd need to listen to the dropdown's selection state
    _color = widget.highlightColor;
  }

  @override
  Widget build(BuildContext context) {
    // In a real implementation, you'd get the selection state from the parent
    // For now, this is a placeholder that shows how it would work
    return widget.builder(context, _isSelected, _color);
  }
}
/// Style configuration for simple dropdowns
class SimpleDropdownStyle {
  final DropdownAnimationType animationType;
  final Color highlightColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final double height;
  final double width;
  final bool showCheckmark;
  final bool showChips;
  final bool enableSearch;
  final IndicatorType indicatorType;
  final Widget? hint;
  final TextStyle? hintStyle;
  final TextStyle? selectedItemStyle;
  final TextStyle? itemStyle;
  final Color? chipColor;
  final TextStyle? chipLabelStyle;
  final Widget Function(BuildContext, bool isSelected, Color activeColor)? customIndicatorBuilder;

  const SimpleDropdownStyle({
    this.animationType = DropdownAnimationType.glass,
    this.highlightColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.height = 48,
    this.width = double.infinity,
    this.showCheckmark = true,
    this.showChips = true,
    this.enableSearch = false,
    this.indicatorType = IndicatorType.checkmark,
    this.hint,
    this.hintStyle,
    this.selectedItemStyle,
    this.itemStyle,
    this.chipColor,
    this.chipLabelStyle,
    this.customIndicatorBuilder,
  });

  /// Creates a style with modern glass effect
  factory SimpleDropdownStyle.glass({
    Color? highlightColor,
    Color? backgroundColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.glass,
      highlightColor: highlightColor ?? Colors.blue,
      backgroundColor: backgroundColor ?? Colors.white,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Creates a style with liquid wave effect
  factory SimpleDropdownStyle.liquid({
    Color? highlightColor,
    Color? backgroundColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.liquid,
      highlightColor: highlightColor ?? Colors.teal,
      backgroundColor: backgroundColor ?? Colors.white,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Creates a style with neon effect
  factory SimpleDropdownStyle.neon({
    Color? highlightColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.neon,
      highlightColor: highlightColor ?? Colors.pink,
      backgroundColor: Colors.black,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      selectedItemStyle: const TextStyle(color: Colors.white),
      itemStyle: const TextStyle(color: Colors.white70),
      indicatorType: IndicatorType.radioCheckmark,
    );
  }

  /// Creates a style with cyberpunk effect
  factory SimpleDropdownStyle.cyberpunk({
    Color? highlightColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.cyberpunk,
      highlightColor: highlightColor ?? Colors.pinkAccent,
      backgroundColor: Colors.black87,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(8),
      selectedItemStyle: const TextStyle(color: Colors.white),
      itemStyle: const TextStyle(color: Colors.white70),
      indicatorType: IndicatorType.radioCheckmark,
    );
  }

  /// Creates a style with bouncy 3D effect
  factory SimpleDropdownStyle.bouncy3d({
    Color? highlightColor,
    Color? backgroundColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.bouncy3d,
      highlightColor: highlightColor ?? Colors.orange,
      backgroundColor: backgroundColor ?? Colors.white,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Creates a style with toggle effect
  factory SimpleDropdownStyle.toggle({
    Color? highlightColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.glass,
      highlightColor: highlightColor ?? Colors.blue,
      height: height ?? 56,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType: IndicatorType.toggle,
    );
  }

  /// Creates a style with switch effect
  factory SimpleDropdownStyle.switchStyle({
    Color? highlightColor,
    double? height,
    double? width,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.liquid,
      highlightColor: highlightColor ?? Colors.blue,
      height: height ?? 56,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType: IndicatorType.switchStyle,
    );
  }

  /// Creates a style with gradient effect
  factory SimpleDropdownStyle.gradient({
    required List<Color> colors,
    double? height,
    double? width,
    bool isMultiple = false,
  }) {
    return SimpleDropdownStyle(
      animationType: isMultiple
          ? DropdownAnimationType.liquid
          : DropdownAnimationType.glass,
      highlightColor: colors.first,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType:
      isMultiple ? IndicatorType.checkmark : IndicatorType.radioClassic,
    );
  }

  /// Creates a style with dot effect
  factory SimpleDropdownStyle.dot({
    Color? highlightColor,
    double? height,
    double? width,
    bool isMultiple = true,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.liquid,
      highlightColor: highlightColor ?? Colors.blue,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType: isMultiple ? IndicatorType.dot : IndicatorType.radioDot,
    );
  }

  /// Creates a style with custom star indicator
  factory SimpleDropdownStyle.star({
    Color? highlightColor,
    double? height,
    double? width,
    bool isMultiple = false,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.glass,
      highlightColor: highlightColor ?? Colors.amber,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: color,
          size: 24,
        );
      },
    );
  }

  /// Creates a style with custom heart indicator
  factory SimpleDropdownStyle.heart({
    Color? highlightColor,
    double? height,
    double? width,
    bool isMultiple = false,
  }) {
    return SimpleDropdownStyle(
      animationType: DropdownAnimationType.liquid,
      highlightColor: highlightColor ?? Colors.red,
      height: height ?? 48,
      width: width ?? double.infinity,
      borderRadius: BorderRadius.circular(12),
      indicatorType: IndicatorType.custom,
      customIndicatorBuilder: (context, isSelected, color) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? Icons.favorite : Icons.favorite_border,
            color: color,
            size: 24,
          ),
        );
      },
    );
  }
}