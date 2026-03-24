import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_Down_strategy.dart';

class FloatingCardsMultiDropdownStrategy<T> extends BaseDropdownStrategy<T> {
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
    final floatAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

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
        AnimatedBuilder(
          animation: floatAnimation,
          builder: (context, _) {
            return Transform(
              transform: CustomMatrixUtils.floatingCard(
                progress: floatAnimation.value,
                startOffset: 20,
                endOffset: 0,
              ),
              child: Opacity(
                opacity: floatAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        children: [
                          buildSearchField(config),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final isSelected = isItemSelected(item);
                                final delay = index * 0.05;
                                final itemAnim = Tween(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: controller,
                                    curve: Interval(
                                      delay,
                                      delay + 0.3,
                                      curve: Curves.easeOutBack,
                                    ),
                                  ),
                                );

                                return ScaleTransition(
                                  scale: itemAnim,
                                  child: Card(
                                    margin: EdgeInsets.only(
                                      bottom: index == items.length - 1 ? 0 : 8,
                                    ),
                                    elevation: elevation ?? 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: config.dropdownBorderRadius,
                                      side: BorderSide(
                                        color: isSelected
                                            ? config.highlightColor
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: InkWell(
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
                                      borderRadius: config.dropdownBorderRadius,
                                      child: Padding(
                                        padding: itemPadding ?? config.itemPadding,
                                        child: Row(
                                          children: [
                                            if (config.selectionMode ==
                                                SelectionMode.multiple ||
                                                (config.selectionMode ==
                                                    SelectionMode.single &&
                                                    config.showCheckmark))
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 12,
                                                ),
                                                child: buildSelectionIndicator(
                                                  isSelected,
                                                  config,
                                                ),
                                              ),
                                            Expanded(
                                              child: DefaultTextStyle.merge(
                                                style: isSelected
                                                    ? selectedItemStyle ??
                                                    config.selectedItemStyle
                                                    : itemStyle ?? config.itemStyle,
                                                child: itemBuilder(item),
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
                          ),
                        ],
                      ),
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