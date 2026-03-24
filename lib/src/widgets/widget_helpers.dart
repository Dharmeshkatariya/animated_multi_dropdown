import 'package:animated_multi_dropdown/src/widgets/custom_text.dart';
import 'package:animated_multi_dropdown/src/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/multi_dropdown_config.dart';
import '../models/selection_mode.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DropdownWidgetHelpers {
  static Widget buildDisplayValue<T>({
    required dynamic value,
    required bool isMultiple,
    required Widget Function(T item) itemBuilder,
    required MultiDropDownConfig config,
    Widget? hint,
    TextStyle? hintStyle,
    TextStyle? selectedItemStyle,
    required ValueChanged<T> onChanged,
  }) {
    if (isMultiple) {
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
              color: config.chipColor ?? AppColors.grey200,
              borderRadius: config.chipBorderRadius ?? BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: '',
                  style: config.chipLabelStyle ?? AppTextStyles.bodyMedium,
                  child: itemBuilder(item),
                ),
                if (config.chipDeleteIcon != null)
                  GestureDetector(
                    onTap: () {
                      onChanged(item);
                      if (config.enableHapticFeedback) {
                        HapticFeedback.lightImpact();
                      }
                    },
                    child: config.chipDeleteIcon!,
                  )
                else
                  GestureDetector(
                    onTap: () {
                      onChanged(item);
                      if (config.enableHapticFeedback) {
                        HapticFeedback.lightImpact();
                      }
                    },
                    child: const Icon(Icons.close,
                        size: 16, color: AppColors.grey600),
                  ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return value != null
          ? CustomText(
              text: '',
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

  /// Builds a dropdown item row
  static Widget buildDropdownItem<T>({
    required T item,
    required bool isSelected,
    required MultiDropDownConfig config,
    required Widget Function(T) itemBuilder,
    required Widget Function(bool, MultiDropDownConfig) buildSelectionIndicator,
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
      splashColor: config.highlightColor.withOpacity(0.2),
      highlightColor: config.highlightColor.withOpacity(0.1),
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

  /// Builds a search field
  static Widget buildSearchField({
    required MultiDropDownConfig config,
    required TextEditingController controller,
    required FocusNode focusNode,
    VoidCallback? onChanged,
  }) {
    if (!config.enableSearch) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: config.searchTextStyle,
        cursorColor: config.searchCursorColor,
        onChanged: (value) => onChanged?.call(),
        decoration: InputDecoration(
          hintText: config.searchHintText,
          hintStyle: config.searchTextStyle.copyWith(
            color: config.searchDecorationColor,
          ),
          prefixIcon: Icon(Icons.search, color: config.searchDecorationColor),
          filled: true,
          fillColor: config.searchBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  /// Builds an animated rotation icon
  static Widget buildRotatingIcon({
    required AnimationController controller,
    Widget? icon,
    Color? color,
  }) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: icon ??
          Icon(
            Icons.arrow_drop_down,
            color: color ?? AppColors.primary,
          ),
    );
  }

  /// Maps dropdown config to appropriate indicator type
 static IndicatorType _getIndicatorType(MultiDropDownConfig config) {
    // For multiple selection, use checkbox styles
    if (config.selectionMode == SelectionMode.multiple) {
      switch (config.selectedIndicator) {
        case IndicatorType.checkmark:
          return IndicatorType.checkmark;
        case IndicatorType.dot:
          return IndicatorType.dot;
        case IndicatorType.square:
          return IndicatorType.square;
        case IndicatorType.classic:
          return IndicatorType.classic;
        case IndicatorType.gradient:
          return IndicatorType.gradient;
        case IndicatorType.tick:
          return IndicatorType.tick;
        case IndicatorType.neumorphic:
          return IndicatorType.neumorphic;
        case IndicatorType.switchStyle:
          return IndicatorType.switchStyle;
        case IndicatorType.toggle:
          return IndicatorType.toggle;
        default:
          return IndicatorType.checkmark;
      }
    }
    // For single selection, use radio styles
    else {
      switch (config.selectedIndicator) {
        case IndicatorType.radioClassic:
          return IndicatorType.radioClassic;
        case IndicatorType.radioCheckmark:
          return IndicatorType.radioCheckmark;
        case IndicatorType.radioDot:
          return IndicatorType.radioDot;
        case IndicatorType.radioSquare:
          return IndicatorType.radioSquare;
        case IndicatorType.gradient:
          return IndicatorType.gradient;
        case IndicatorType.neumorphic:
          return IndicatorType.neumorphic;
        case IndicatorType.toggle:
          return IndicatorType.toggle;
        default:
          return IndicatorType.radioClassic;
      }
    }
  }

 static Widget buildSelectionIndicator({
  required  bool isSelected, required MultiDropDownConfig config
}) {
    if (config.customIndicator != null) {
      return config.customIndicator!;
    }

    return IndicatorWidget(
      isSelected: isSelected,
      isEnabled: true,
      config: IndicatorConfig(
        type: _getIndicatorType(config),
        activeColor: config.indicatorActiveColor,
        inactiveColor: config.indicatorInactiveColor,
        size: config.indicatorSize,
        borderRadius: config.borderRadius,
        showCheckmark: true,
        showDot: true,
        dotSize: 0.6,
        isRadio: config.selectionMode == SelectionMode.single,
        isCheckbox: config.selectionMode == SelectionMode.multiple,
        animateChanges: true,
      ),
      isRadioGroup: config.selectionMode == SelectionMode.single,
    );
  }

}
