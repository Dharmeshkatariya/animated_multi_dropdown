import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_down_strategy.dart';

class FoldableMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    Widget Function()? noDataBuilder,
  }) {
    final foldAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    const itemHeight = 55.0;

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        selector,
        AnimatedBuilder(
          animation: foldAnimation,
          builder: (context, _) {
            final totalHeight = items.length * itemHeight;
            final visibleHeight = totalHeight * foldAnimation.value;
            final maxHeight = maxDropdownHeight ?? config.maxDropdownHeight;

            return SizedBox(
              height: visibleHeight.clamp(0.0, maxHeight),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: foldAnimation.value,
                  child: Container(
                    width: dropdownWidth ?? config.dropdownWidth,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: dropdownBackgroundColor ?? config.backgroundColor,
                      borderRadius: config.dropdownBorderRadius,
                      boxShadow: shadows ?? config.shadows,
                    ),
                    child: Column(
                      children: [
                        buildSearchField(config),
                        Expanded(
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final selected = isItemSelected(item);

                              return InkWell(
                                onTap: () {
                                  if (config.enableHapticFeedback) {
                                    HapticFeedback.lightImpact();
                                  }
                                  onChanged(item);
                                  if (config.selectionMode ==
                                      SelectionMode.single) {
                                    onToggle();
                                  }
                                },
                                borderRadius: index == items.length - 1
                                    ? BorderRadius.only(
                                        bottomLeft: config
                                            .dropdownBorderRadius.bottomLeft,
                                        bottomRight: config
                                            .dropdownBorderRadius.bottomRight,
                                        topLeft: Radius.zero,
                                        topRight: Radius.zero,
                                      )
                                    : null,
                                child: Container(
                                  height: itemHeight,
                                  padding: itemPadding ?? config.itemPadding,
                                  decoration: BoxDecoration(
                                    border:
                                        showDivider && index < items.length - 1
                                            ? Border(
                                                bottom: BorderSide(
                                                  color: dividerColor ??
                                                      config.dividerColor,
                                                  width: dividerThickness ??
                                                      config.dividerThickness,
                                                ),
                                              )
                                            : null,
                                  ),
                                  child: Row(
                                    children: [
                                      if (config.selectionMode ==
                                              SelectionMode.multiple ||
                                          (config.selectionMode ==
                                                  SelectionMode.single &&
                                              config.showCheckmark))
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: buildSelectionIndicator(
                                              selected, config),
                                        ),
                                      Expanded(
                                        child: DefaultTextStyle.merge(
                                          style: selected
                                              ? selectedItemStyle ??
                                                  config.selectedItemStyle
                                              : itemStyle ?? config.itemStyle,
                                          child: itemBuilder(item),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
