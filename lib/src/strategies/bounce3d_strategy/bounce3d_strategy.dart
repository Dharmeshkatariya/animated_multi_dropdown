import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_Down_strategy.dart';

class MultiBounce3DDropdownStrategy<T> extends BaseDropdownStrategy<T> {
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
    final rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    );

    final depthAnimation = Tween(begin: 0.0, end: config.depth).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    final displayValue = buildDisplayValue(
      value: value,
      config: config,
      itemBuilder: itemBuilder,
      onChanged: onChanged,
      hint: hint,
      hintStyle: hintStyle,
      selectedItemStyle: selectedItemStyle,
    );

    final selector = AnimatedBuilder(
      animation: depthAnimation,
      builder: (context, _) {
        return Transform(
          transform: CustomMatrixUtils.bounce3D(
            depth: depthAnimation.value,
            perspective: 0.001,
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: config.selectorHeight,
              minWidth: dropdownWidth ?? config.selectorWidth,
            ),
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: config.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValuesOpacity(0.3),
                  blurRadius: depthAnimation.value,
                  offset: Offset(0, depthAnimation.value),
                ),
              ],
            ),
            child: Container(
              padding: padding ?? config.padding,
              decoration: BoxDecoration(
                color: config.backgroundColor,
                borderRadius: config.borderRadius,
                border: Border.all(
                  color: config.highlightColor.withValuesOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: displayValue),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: rotateAnimation,
                    child: icon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: config.highlightColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    final dropdownMenu = SizeTransition(
      sizeFactor: heightAnimation,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: config.dropdownBorderRadius,
          child: Container(
            width: dropdownWidth ?? config.dropdownWidth,
            constraints: BoxConstraints(
              maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
            ),
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: config.dropdownBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValuesOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [selector, dropdownMenu],
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
      onTap: () {
        if (config.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
      splashColor: config.highlightColor.withValuesOpacity(0.3),
      highlightColor: config.highlightColor.withValuesOpacity(0.1),
      child: Container(
        padding: itemPadding ?? config.itemPadding,
        decoration: BoxDecoration(
          border: index < totalItems - 1 && showDivider
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
                (config.selectionMode == SelectionMode.single && config.showCheckmark))
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildSelectionIndicator(isSelected, config),
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

  Widget _buildSelectionIndicator(bool isSelected, MultiDropDownConfig config) {
    if (config.customIndicator != null) {
      return config.customIndicator!;
    }

    final isRadioStyle = config.selectedIndicator.toString().contains('radio');

    return Container(
      width: config.indicatorSize,
      height: config.indicatorSize,
      decoration: BoxDecoration(
        shape: isRadioStyle ? BoxShape.circle : BoxShape.rectangle,
        color: isSelected ? config.indicatorActiveColor : config.indicatorInactiveColor,
        borderRadius: !isRadioStyle ? BorderRadius.circular(4) : null,
      ),
      child: isSelected
          ? Icon(
        isRadioStyle ? Icons.radio_button_checked : Icons.check,
        size: config.indicatorSize * 0.7,
        color: Colors.white,
      )
          : null,
    );
  }
}