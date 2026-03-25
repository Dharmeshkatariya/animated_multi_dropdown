import 'dart:math';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class StaggeredVerticalMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final displayValue = buildDisplayValue(
      value: value,
      config: config,
      itemBuilder: itemBuilder,
      onChanged: onChanged,
      hint: hint,
      hintStyle: hintStyle,
      selectedItemStyle: selectedItemStyle,
    );

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

    if (!isOpen) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [selector],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        selector,
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildSearchField(config),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(items.length, (index) {
                      final start = min(0.1 + (0.1 * index), 0.9);
                      final end = min(0.5 + (0.1 * index), 1.0);
                      final itemAnim = Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: Interval(
                            start,
                            end,
                            curve: config.curve,
                          ),
                        ),
                      );

                      final item = items[index];
                      final selected = isItemSelected(item);

                      return ScaleTransition(
                        scale: itemAnim,
                        child: FadeTransition(
                          opacity: itemAnim,
                          child: Transform(
                            transform: CustomMatrixUtils.staggerTransform(
                              progress: itemAnim.value,
                              startY: 20,
                              endY: 0,
                              startScale: 0,
                              endScale: 1,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (config.enableHapticFeedback) {
                                  HapticFeedback.lightImpact();
                                }
                                onChanged(item);
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: dropdownWidth ?? config.selectorWidth,
                                ),
                                padding: itemPadding ?? config.itemPadding,
                                decoration: BoxDecoration(
                                  color: dropdownBackgroundColor ??
                                      config.backgroundColor,
                                  borderRadius: config.dropdownBorderRadius,
                                  border: Border.all(
                                    color: selected
                                        ? config.highlightColor
                                        : Colors.grey.withValuesOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValuesOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (config.selectionMode ==
                                        SelectionMode.multiple ||
                                        (config.selectionMode ==
                                            SelectionMode.single &&
                                            config.showCheckmark))
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: buildSelectionIndicator(
                                          selected,
                                          config,
                                        ),
                                      ),
                                    Expanded(
                                      child: DefaultTextStyle.merge(
                                        style: selected
                                            ? selectedItemStyle ?? config.selectedItemStyle
                                            : itemStyle ?? config.itemStyle,
                                        child: itemBuilder(item),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}