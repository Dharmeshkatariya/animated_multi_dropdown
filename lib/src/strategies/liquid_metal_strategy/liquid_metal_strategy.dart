import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:animated_multi_dropdown/src/utils/custom_matrix_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_down_strategy.dart';

class LiquidMetalMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final metalAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final opacityAnimation = createOpacityAnimation(
      controller,
      interval: const Interval(0.3, 1.0),
    );

    final effectiveHighlightColor = config.highlightColor;
    final metalGradient = LinearGradient(
      colors: [
        effectiveHighlightColor,
        effectiveHighlightColor.withValuesOpacity(0.8),
        Colors.white.withValuesOpacity(0.9),
        effectiveHighlightColor.withValuesOpacity(0.8),
        effectiveHighlightColor,
      ],
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
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

    final selector = GestureDetector(
      onTap: () {
        if (config.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onToggle();
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: config.selectorHeight,
          minWidth: dropdownWidth ?? config.selectorWidth,
        ),
        decoration: BoxDecoration(
          gradient: metalGradient,
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
              _buildRotatingIcon(controller, config),
            ],
          ),
        ),
      ),
    );

    final dropdownMenu = AnimatedBuilder(
      animation: metalAnim,
      builder: (context, _) {
        return Transform(
          transform: CustomMatrixUtils.molecularBond(
            progress: metalAnim.value,
            startOffset: 20,
            endOffset: 0,
          ),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Material(
                elevation: elevation ?? config.elevation,
                borderRadius: config.dropdownBorderRadius,
                child: ClipRRect(
                  borderRadius: config.dropdownBorderRadius,
                  child: Container(
                    width: dropdownWidth ?? config.dropdownWidth,
                    constraints: BoxConstraints(
                      maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                    ),
                    decoration: BoxDecoration(
                      gradient: metalGradient,
                      borderRadius: config.dropdownBorderRadius,
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

                                return Transform(
                                  transform: CustomMatrixUtils.staggerTransform(
                                    progress: itemAnim.value,
                                    startY: 10,
                                    endY: 0,
                                    startScale: 0,
                                    endScale: 1,
                                  ),
                                  child: FadeTransition(
                                    opacity: itemAnim,
                                    child: Material(
                                      color: Colors.transparent,
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
                                        splashColor: Colors.white.withValuesOpacity(0.2),
                                        highlightColor: Colors.white.withValuesOpacity(0.1),
                                        child: Container(
                                          padding: itemPadding ?? config.itemPadding,
                                          decoration: BoxDecoration(
                                            border: index < items.length - 1 && showDivider
                                                ? Border(
                                              bottom: BorderSide(
                                                color: dividerColor ??
                                                    Colors.white.withValuesOpacity(0.2),
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
                                                  style: (isSelected
                                                      ? selectedItemStyle ??
                                                      config.selectedItemStyle
                                                      : itemStyle ?? config.itemStyle)
                                                      .copyWith(
                                                    color: Colors.white,
                                                  ),
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
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [selector, dropdownMenu],
    );
  }

  Widget _buildRotatingIcon(AnimationController controller, MultiDropDownConfig config) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: const Icon(
        Icons.arrow_drop_down_rounded,
        color: Colors.white,
      ),
    );
  }
}