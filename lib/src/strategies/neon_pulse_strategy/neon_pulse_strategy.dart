import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:animated_multi_dropdown/src/utils/custom_matrix_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_down_strategy.dart';
class NeonPulseMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.8), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuint),
    );

    final effectiveHighlightColor = config.highlightColor;
    final textGlow = <Shadow>[
      Shadow(color: effectiveHighlightColor, blurRadius: 10),
      Shadow(color: effectiveHighlightColor, blurRadius: 20),
      const Shadow(color: Colors.white, blurRadius: 5),
    ];

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
      animation: pulseAnimation,
      builder: (context, _) {
        return GestureDetector(
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
              borderRadius: config.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: effectiveHighlightColor.withValuesOpacity(
                    0.5 * pulseAnimation.value,
                  ),
                  blurRadius: 20 * pulseAnimation.value,
                  spreadRadius: 2,
                ),
                ...(shadows ?? config.shadows),
              ],
            ),
            child: ClipRRect(
              borderRadius: config.borderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    borderRadius: config.borderRadius,
                    border: Border.all(
                      color: effectiveHighlightColor.withValuesOpacity(0.7),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        effectiveHighlightColor.withValuesOpacity(0.2),
                        effectiveHighlightColor.withValuesOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        config.leadingIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: displayValue),
                      _buildRotatingIcon(controller, config, effectiveHighlightColor, textGlow),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    final dropdownMenu = SizeTransition(
      sizeFactor: heightAnimation,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ClipRRect(
          borderRadius: config.dropdownBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: dropdownWidth ?? config.dropdownWidth,
              constraints: BoxConstraints(
                maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValuesOpacity(0.7),
                borderRadius: config.dropdownBorderRadius,
                border: Border.all(
                  color: effectiveHighlightColor.withValuesOpacity(0.3),
                  width: 1,
                ),
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
                          final delay = index * 0.07;
                          final itemAnim = Tween(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: controller,
                              curve: Interval(
                                delay,
                                delay + 0.4,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                          );

                          return FadeTransition(
                            opacity: itemAnim,
                            child: Transform(
                              transform: CustomMatrixUtils.staggerTransform(
                                progress: itemAnim.value,
                                startY: 20,
                                endY: 0,
                                startScale: 0,
                                endScale: 1,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (config.enableHapticFeedback) {
                                    HapticFeedback.lightImpact();
                                  }
                                  onChanged(item);
                                  if (config.selectionMode == SelectionMode.single) {
                                    onToggle();
                                  }
                                },
                                splashColor: effectiveHighlightColor.withValuesOpacity(0.2),
                                highlightColor: effectiveHighlightColor.withValuesOpacity(0.1),
                                child: Container(
                                  padding: itemPadding ?? config.itemPadding,
                                  decoration: BoxDecoration(
                                    border: index < items.length - 1 && showDivider
                                        ? Border(
                                      bottom: BorderSide(
                                        color: dividerColor ??
                                            effectiveHighlightColor.withValuesOpacity(0.1),
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
                                          style: (isSelected
                                              ? selectedItemStyle ?? config.selectedItemStyle
                                              : itemStyle ?? config.itemStyle)
                                              .copyWith(
                                            shadows: isSelected ? textGlow : null,
                                          ),
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
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [selector, dropdownMenu],
    );
  }

  Widget _buildRotatingIcon(
      AnimationController controller,
      MultiDropDownConfig config,
      Color color,
      List<Shadow> textGlow,
      ) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: Icon(
        Icons.arrow_drop_down,
        color: color,
        shadows: textGlow,
      ),
    );
  }
}