import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/bond_painter.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class MolecularMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final bondAnimation = Tween(
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

    final selector = Stack(
      children: [
        AnimatedBuilder(
          animation: bondAnimation,
          builder: (context, _) {
            return CustomPaint(
              painter: BondPainter(
                progress: bondAnimation.value,
                color: config.highlightColor,
                isOpen: isOpen,
              ),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: config.selectorHeight,
                  minWidth: dropdownWidth ?? config.selectorWidth,
                ),
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  borderRadius: config.borderRadius,
                  boxShadow: shadows ?? config.shadows,
                ),
                child: Padding(
                  padding: padding ?? config.padding,
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        config.leadingIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: displayValue),
                      const SizedBox(width: 8),
                      _buildRotatingIcon(controller, config),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
          animation: bondAnimation,
          builder: (context, _) {
            return Transform(
              transform: CustomMatrixUtils.molecularBond(
                progress: bondAnimation.value,
                startOffset: 20,
                endOffset: 0,
              ),
              child: Opacity(
                opacity: bondAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                    ),
                    child: Material(
                      elevation: elevation ?? 4,
                      borderRadius: config.dropdownBorderRadius,
                      child: ClipRRect(
                        borderRadius: config.dropdownBorderRadius,
                        child: Container(
                          width: dropdownWidth ?? config.dropdownWidth,
                          color:
                              dropdownBackgroundColor ?? config.backgroundColor,
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
                                          curve: config.curve,
                                        ),
                                      ),
                                    );

                                    return ScaleTransition(
                                      scale: itemAnim,
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
                                        child: Container(
                                          padding:
                                              itemPadding ?? config.itemPadding,
                                          decoration: BoxDecoration(
                                            border: showDivider &&
                                                    index < items.length - 1
                                                ? Border(
                                                    bottom: BorderSide(
                                                      color: dividerColor ??
                                                          config.dividerColor,
                                                      width: dividerThickness ??
                                                          config
                                                              .dividerThickness,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              if (config.selectionMode ==
                                                      SelectionMode.multiple ||
                                                  (config.selectionMode ==
                                                          SelectionMode
                                                              .single &&
                                                      config.showCheckmark))
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 12,
                                                  ),
                                                  child:
                                                      buildSelectionIndicator(
                                                    selected,
                                                    config,
                                                  ),
                                                ),
                                              Expanded(
                                                child: DefaultTextStyle.merge(
                                                  style: selected
                                                      ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                      : itemStyle ??
                                                          config.itemStyle,
                                                  child: itemBuilder(item),
                                                ),
                                              ),
                                            ],
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
                ),
              ),
            );
          },
        ),
      ],
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
}
