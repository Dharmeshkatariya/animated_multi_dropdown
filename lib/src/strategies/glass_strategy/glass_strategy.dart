import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_Down_strategy.dart';

class MultiGlassDropdownStrategy<T> extends BaseDropdownStrategy<T> {
  @override
  Widget buildDropdown({
    required BuildContext context,
    required List<T> items,
    required dynamic value,
    required ValueChanged<T> onChanged,
    required Widget Function(T item) itemBuilder,
    Widget? hint,
    Widget? icon,
    required AnimationController controller,
    required bool isOpen,
    required MultiDropDownConfig config,
    required VoidCallback onToggle,
    bool showDivider = true,
    Color? dividerColor,
    double? dividerThickness,
    EdgeInsets? padding,
    EdgeInsets? itemPadding,
    TextStyle? hintStyle,
    TextStyle? selectedItemStyle,
    TextStyle? itemStyle,
    Color? dropdownBackgroundColor,
    BoxShadow? shadow,
    List<BoxShadow>? shadows,
    double? elevation,
    double? maxDropdownHeight,
    bool showCheckmark = true,
    Widget? customCheckmark,
    double? dropdownWidth,
    required bool Function(T) isItemSelected,
    required Widget Function(bool, MultiDropDownConfig) buildSelectionIndicator,
    required Widget Function(MultiDropDownConfig) buildSearchField,
  }) {
    final opacityAnimation = createOpacityAnimation(controller);
    final heightAnimation = createHeightAnimation(controller, curve: config.curve);

    final displayValue = buildDisplayValue(
      value: value,
      config: config,
      itemBuilder: itemBuilder,
      onChanged: onChanged,
      hint: hint,
      hintStyle: hintStyle,
      selectedItemStyle: selectedItemStyle,
    );

    final effectiveBackgroundColor = dropdownBackgroundColor?.withValuesOpacity(0.13) ??
        config.backgroundColor.withValuesOpacity(0.13);

    final selector = buildSelector(
      child: displayValue,
      config: config,
      controller: controller,
      onToggle: onToggle,
      width: dropdownWidth,
      shadows: shadows,
      padding: padding,
      leadingIcon: config.leadingIcon,
      showChipSpace: config.selectionMode == SelectionMode.multiple &&
          value is List<T> &&
          (value).isNotEmpty,
    );

    final dropdownMenu = buildTransition(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: config.dropdownBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: config.blurIntensity,
              sigmaY: config.blurIntensity,
            ),
            child: buildDropdownMenu(
              context: context,
              items: items,
              onChanged: onChanged,
              itemBuilder: itemBuilder,
              isItemSelected: isItemSelected,
              config: config,
              buildSearchField: buildSearchField,
              controller: controller,
              maxHeight: maxDropdownHeight,
              width: dropdownWidth,
              itemPadding: itemPadding,
              selectedItemStyle: selectedItemStyle,
              itemStyle: itemStyle,
              showDivider: showDivider,
              dividerColor: dividerColor,
              dividerThickness: dividerThickness,
              backgroundColor: effectiveBackgroundColor,
              shadows: shadows,
              elevation: elevation,
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [selector, dropdownMenu],
    );
  }
}