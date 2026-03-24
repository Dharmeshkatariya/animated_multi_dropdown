import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class FloatingGlassMultiDropdownStrategy<T> extends BaseDropdownStrategy<T> {
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
    final floatAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    final effectiveHighlightColor = config.highlightColor;
    final glassColor = effectiveHighlightColor.withValuesOpacity(0.15);

    final displayValue = buildDisplayValue(
      value: value,
      config: config,
      itemBuilder: itemBuilder,
      onChanged: onChanged,
      hint: hint,
      hintStyle: hintStyle,
      selectedItemStyle: selectedItemStyle,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: floatAnim,
            builder: (context, _) {
              return Transform(
                transform: CustomMatrixUtils.gravityWell(
                  progress: floatAnim.value,
                  startY: 15,
                  endY: 0,
                  startScale: 0,
                  endScale: 1,
                ),
                child: Opacity(
                  opacity: floatAnim.value * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          glassColor.withValuesOpacity(0.8),
                          Colors.transparent,
                        ],
                        radius: 2.0,
                        center: Alignment.topCenter,
                        stops: const [0.1, 0.9],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
                onToggle();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: config.borderRadius,
                    border: Border.all(
                      color: Colors.white.withValuesOpacity(isOpen ? 0.5 : 0.3),
                      width: isOpen ? 2.0 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValuesOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: effectiveHighlightColor.withValuesOpacity(
                          isOpen ? 0.2 : 0.1,
                        ),
                        blurRadius: isOpen ? 40 : 30,
                        spreadRadius: isOpen ? 3 : 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        config.leadingIcon!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(child: displayValue),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        child: icon ??
                            Icon(
                              Icons.expand_more_rounded,
                              color: Colors.white.withValuesOpacity(0.8),
                              size: 28,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              axisAlignment: -1.0,
              sizeFactor: floatAnim,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: config.dropdownBorderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20 * floatAnim.value,
                      sigmaY: 20 * floatAnim.value,
                    ),
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      constraints: BoxConstraints(
                        maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      decoration: BoxDecoration(
                        color: glassColor.withValuesOpacity(0.7 * floatAnim.value),
                        border: Border.all(
                          color: Colors.white.withValuesOpacity(0.3 * floatAnim.value),
                          width: 1,
                        ),
                        borderRadius: config.dropdownBorderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: effectiveHighlightColor.withValuesOpacity(0.2 * floatAnim.value),
                            blurRadius: 30,
                            spreadRadius: 1,
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
                                  final isSelected = isItemSelected(item);
                                  final delay = index * 0.05;
                                  final itemAnim = Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: controller,
                                      curve: Interval(
                                        delay.clamp(0.0, 0.7),
                                        (delay + 0.5).clamp(0.1, 1.0),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: itemAnim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.2),
                                        end: Offset.zero,
                                      ).animate(itemAnim),
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
                                          splashColor: Colors.white.withValuesOpacity(0.15),
                                          highlightColor: Colors.white.withValuesOpacity(0.08),
                                          child: Container(
                                            padding: itemPadding ?? config.itemPadding,
                                            decoration: BoxDecoration(
                                              border: index < items.length - 1 && showDivider
                                                  ? Border(
                                                bottom: BorderSide(
                                                  color: dividerColor ??
                                                      Colors.white.withValuesOpacity(0.1),
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
                                                      color: Colors.white.withValuesOpacity(0.95),
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
          ],
        ),
      ],
    );
  }
}