import 'dart:math';
import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/morphing_gradient_painter.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';
class MorphingGlassMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final morphAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint),
    );

    final heightAnim = createHeightAnimation(
      controller,
      curve: const Interval(0.3, 0.95, curve: Curves.elasticOut),
    );

    final accentColor = config.highlightColor;
    final gradientColors = [
      accentColor.withValuesOpacity(0.15),
      accentColor.withValuesOpacity(0.05),
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

    return Stack(
      children: [
        AnimatedBuilder(
          animation: morphAnim,
          builder: (context, _) {
            return CustomPaint(
              painter: MorphingGradientPainter(
                progress: morphAnim.value.clamp(0.0, 1.0),
                colors: gradientColors,
              ),
            );
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: ClipRRect(
                borderRadius: config.borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    constraints: BoxConstraints(
                      minHeight: config.selectorHeight,
                      minWidth: dropdownWidth ?? config.selectorWidth,
                    ),
                    padding: padding ?? config.padding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: config.borderRadius,
                      border: Border.all(
                        color: Colors.white.withValuesOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValuesOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (config.leadingIcon != null) ...[
                          config.leadingIcon!,
                          const SizedBox(width: 8),
                        ],
                        Expanded(child: displayValue),
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return Transform.rotate(
                              angle: controller.value * pi / 2,
                              child: icon ??
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.white.withValuesOpacity(0.8),
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: heightAnim,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: config.dropdownBorderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      constraints: BoxConstraints(
                        maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            gradientColors[0].withValuesOpacity(0.3),
                            gradientColors[1].withValuesOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: Colors.white.withValuesOpacity(0.15),
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
                                  final delay = index * 0.05;
                                  final itemAnim = Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: controller,
                                      curve: Interval(
                                        delay + 0.3,
                                        (delay + 0.8).clamp(0.3, 0.95),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: itemAnim,
                                    child: Transform(
                                      transform: CustomMatrixUtils.molecularBond(
                                        progress: itemAnim.value,
                                        startOffset: 20,
                                        endOffset: 0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          onChanged(item);
                                          if (config.selectionMode ==
                                              SelectionMode.single) {
                                            onToggle();
                                          }
                                        },
                                        splashColor: Colors.white.withValuesOpacity(0.1),
                                        highlightColor: Colors.white.withValuesOpacity(0.05),
                                        child: Container(
                                          padding: itemPadding ?? config.itemPadding,
                                          decoration: BoxDecoration(
                                            border: index < items.length - 1 && showDivider
                                                ? Border(
                                              bottom: BorderSide(
                                                color: Colors.white.withValuesOpacity(0.08),
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
                                                    color: Colors.white.withValuesOpacity(0.9),
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
            ),
          ],
        ),
      ],
    );
  }
}