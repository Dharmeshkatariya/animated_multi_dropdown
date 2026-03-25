import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/multi_dropdown_config.dart';
import '../models/selection_mode.dart';
import '../utils/color_utils.dart';
import '../widgets/custom_text.dart';
import '../widgets/indicator.dart';
import 'multi_dropdown_animation_strategy.dart';

abstract class BaseDropDownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
  // ==================== COMMON UI BUILDERS ====================

  /// Builds the display value (single or multiple selection)
  Widget buildDisplayValue({
    required dynamic value,
    required MultiDropDownConfig config,
    required Widget Function(T) itemBuilder,
    required ValueChanged<T> onChanged,
    Widget? hint,
    TextStyle? hintStyle,
    TextStyle? selectedItemStyle,
  }) {
    if (config.selectionMode == SelectionMode.multiple) {
      final selectedItems = value is List<T> ? value : [];
      if (selectedItems.isEmpty) {
        return CustomText(
          text: 'Select...',
          style: hintStyle ?? config.hintStyle,
          alignment: Alignment.centerLeft,
        );
      }
      return Wrap(
        spacing: config.chipSpacing,
        runSpacing: config.chipRunSpacing,
        children: selectedItems.map((item) {
          return Container(
            padding: config.chipPadding,
            decoration: BoxDecoration(
              color: config.chipColor ?? Colors.grey[200],
              borderRadius: config.chipBorderRadius ?? BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  style: config.chipLabelStyle ??
                      const TextStyle(color: Colors.black),
                  child: itemBuilder(item),
                ),
                GestureDetector(
                  onTap: () {
                    onChanged(item);
                    if (config.enableHapticFeedback) {
                      HapticFeedback.lightImpact();
                    }
                  },
                  child: config.chipDeleteIcon ??
                      const Icon(Icons.close, size: 16),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return value != null
          ? CustomText(
              style: selectedItemStyle ?? config.selectedItemStyle,
              child: itemBuilder(value as T),
            )
          : CustomText(
              text: 'Select...',
              style: hintStyle ?? config.hintStyle,
              child: hint,
            );
    }
  }

  /// Builds the selector container
  Widget buildSelector({
    required Widget child,
    required MultiDropDownConfig config,
    required AnimationController controller,
    required VoidCallback onToggle,
    double? width,
    List<BoxShadow>? shadows,
    EdgeInsets? padding,
    Widget? leadingIcon,
    bool showChipSpace = false,
    Decoration? customDecoration,
  }) {
    return GestureDetector(
      onTap: () {
        if (config.enableHapticFeedback) HapticFeedback.lightImpact();
        onToggle();
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: config.selectorHeight,
          minWidth: width ?? config.selectorWidth,
        ),
        decoration: customDecoration ??
            BoxDecoration(
              borderRadius: config.borderRadius,
              border: config.border,
              boxShadow: shadows ?? config.shadows,
              gradient: config.gradient,
            ),
        child: ClipRRect(
          borderRadius: config.borderRadius,
          child: Container(
            padding: padding ?? config.padding,
            decoration: BoxDecoration(
              color: config.backgroundColor.withValuesOpacity(0.13),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (leadingIcon != null) ...[
                      leadingIcon,
                      const SizedBox(width: 8)
                    ],
                    Expanded(child: child),
                    const SizedBox(width: 8),
                    _buildRotatingIcon(controller, config),
                  ],
                ),
                if (showChipSpace) const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRotatingIcon(
      AnimationController controller, MultiDropDownConfig config) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: Icon(
        Icons.arrow_drop_down,
        color: config.highlightColor,
      ),
    );
  }

  /// Builds the dropdown menu with items
  Widget buildDropdownMenu({
    required BuildContext context,
    required List<T> items,
    required ValueChanged<T> onChanged,
    required Widget Function(T) itemBuilder,
    required bool Function(T) isItemSelected,
    required MultiDropDownConfig config,
    required Widget Function(MultiDropDownConfig) buildSearchField,
    required AnimationController controller,
    double? maxHeight,
    double? width,
    EdgeInsets? itemPadding,
    TextStyle? selectedItemStyle,
    TextStyle? itemStyle,
    bool showDivider = true,
    Color? dividerColor,
    double? dividerThickness,
    Color? backgroundColor,
    List<BoxShadow>? shadows,
    double? elevation,
    Decoration? customDecoration,
    Widget Function()? noDataBuilder,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? config.maxDropdownHeight,
      ),
      child: Container(
        width: width ?? config.dropdownWidth,
        decoration: customDecoration ??
            BoxDecoration(
              color: backgroundColor ?? config.dropdownBackgroundColor,
              borderRadius: config.dropdownBorderRadius,
              border: config.dropdownBorder,
              boxShadow: shadows ?? config.dropdownShadows,
            ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSearchField(config),
              if (items.isEmpty && noDataBuilder != null)
                Expanded(child: noDataBuilder())
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = isItemSelected(item);
                      return _buildDropdownItem(
                        item: item,
                        isSelected: selected,
                        config: config,
                        itemBuilder: itemBuilder,
                        onTap: () => onChanged(item),
                        itemPadding: itemPadding,
                        selectedItemStyle: selectedItemStyle,
                        itemStyle: itemStyle,
                        showDivider: showDivider,
                        dividerColor: dividerColor,
                        dividerThickness: dividerThickness,
                        index: index,
                        totalItems: items.length,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem<U>({
    required U item,
    required bool isSelected,
    required MultiDropDownConfig config,
    required Widget Function(U) itemBuilder,
    required VoidCallback onTap,
    EdgeInsets? itemPadding,
    TextStyle? selectedItemStyle,
    TextStyle? itemStyle,
    bool showDivider = true,
    Color? dividerColor,
    double? dividerThickness,
    int index = 0,
    int totalItems = 0,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: config.highlightColor.withValuesOpacity(0.2),
      highlightColor: config.highlightColor.withValuesOpacity(0.1),
      child: Container(
        padding: itemPadding ?? config.itemPadding,
        decoration: BoxDecoration(
          border: showDivider && index < totalItems - 1
              ? Border(
                  bottom: BorderSide(
                    color: dividerColor ?? config.dividerColor,
                    width: dividerThickness ?? config.dividerThickness,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            if (config.selectionMode == SelectionMode.multiple ||
                (config.selectionMode == SelectionMode.single &&
                    config.showCheckmark))
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: buildSelectionIndicator(isSelected, config),
              ),
            Expanded(
              child: DefaultTextStyle.merge(
                style: isSelected
                    ? selectedItemStyle ?? config.selectedItemStyle
                    : itemStyle ?? config.itemStyle,
                child: itemBuilder(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Uses the IndicatorWidget from the widgets folder
  /// Public method for building selection indicator
  Widget buildSelectionIndicator(bool isSelected, MultiDropDownConfig config) {
    // Check for custom indicator first
    if (config.customCheckmark != null) {
      return config.customCheckmark!;
    }

    // Use the indicator configuration from the config
    final indicatorConfig = config.indicatorConfig;

    // FIXED: Determine if this is a radio-style indicator based on the type, not selection mode
    final isRadioStyle = indicatorConfig.type.toString().contains('radio') ||
        indicatorConfig.type == IndicatorType.toggle ||
        indicatorConfig.type == IndicatorType.switchStyle ||
        indicatorConfig.type == IndicatorType.radioClassic ||
        indicatorConfig.type == IndicatorType.radioCheckmark ||
        indicatorConfig.type == IndicatorType.radioDot ||
        indicatorConfig.type == IndicatorType.radioSquare;

    final isCheckboxStyle = !isRadioStyle &&
        indicatorConfig.type != IndicatorType.toggle &&
        indicatorConfig.type != IndicatorType.switchStyle;

    // Create indicator configuration with proper flags based on type
    final configForIndicator = IndicatorConfig(
      type: indicatorConfig.type,
      activeColor: indicatorConfig.activeColor,
      inactiveColor: indicatorConfig.inactiveColor,
      gradientColors: indicatorConfig.gradientColors,
      size: indicatorConfig.size,
      borderRadius: indicatorConfig.borderRadius,
      borderWidth: indicatorConfig.borderWidth,
      showCheckmark: indicatorConfig.showCheckmark,
      showDot: indicatorConfig.showDot,
      dotSize: indicatorConfig.dotSize,
      isRadio: isRadioStyle,
      isCheckbox: isCheckboxStyle,
      animateChanges: indicatorConfig.animateChanges,
      customBuilder: indicatorConfig.customBuilder,
    );

    return IndicatorWidget(
      isSelected: isSelected,
      isEnabled: true,
      config: configForIndicator,
      isRadioGroup: isRadioStyle,
    );
  }

  // ==================== COMMON ANIMATIONS ====================

  /// Creates a height animation for the dropdown
  Animation<double> createHeightAnimation(
    AnimationController controller, {
    Curve? curve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve ?? Curves.easeOut),
    );
  }

  /// Creates an opacity animation for the dropdown
  Animation<double> createOpacityAnimation(
    AnimationController controller, {
    Interval? interval,
    double begin = 0.0,
    double end = 1.0,
  }) {
    final effectiveInterval = interval ?? const Interval(0.3, 1.0);
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: effectiveInterval),
    );
  }

  /// Creates a combined transition (size + fade)
  Widget buildTransition({
    required AnimationController controller,
    required Widget child,
    Curve? curve,
    Interval? opacityInterval,
    bool useSizeTransition = true,
    bool useFadeTransition = true,
  }) {
    Widget result = child;

    if (useSizeTransition) {
      result = SizeTransition(
        sizeFactor: createHeightAnimation(controller, curve: curve),
        child: result,
      );
    }

    if (useFadeTransition) {
      result = FadeTransition(
        opacity: createOpacityAnimation(controller, interval: opacityInterval),
        child: result,
      );
    }

    return result;
  }

  // ==================== DEFAULT TOGGLE ====================

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}
