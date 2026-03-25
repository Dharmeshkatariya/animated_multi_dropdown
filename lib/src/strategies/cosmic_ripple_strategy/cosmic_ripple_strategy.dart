import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:animated_multi_dropdown/src/utils/custom_matrix_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/cosmic_ripple_painter.dart';
import '../base_drop_down_strategy.dart';

class CosmicRippleMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final rippleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuad),
    );

    final color = config.highlightColor;

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
            animation: rippleAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: CosmicRipplePainter(
                  progress: rippleAnimation.value,
                  color: color,
                  controllerValue: controller.value,
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValuesOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValuesOpacity(0.5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValuesOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        config.leadingIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: displayValue),
                      _buildRotatingIcon(controller, config, color),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: heightAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  child: ClipRRect(
                    borderRadius: config.dropdownBorderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 + (5 * rippleAnimation.value),
                        sigmaY: 5 + (5 * rippleAnimation.value),
                      ),
                      child: Container(
                        width: dropdownWidth ?? config.dropdownWidth,
                        decoration: BoxDecoration(
                          color: dropdownBackgroundColor ??
                              Colors.black.withValuesOpacity(0.5),
                          borderRadius: config.dropdownBorderRadius,
                          border: Border.all(
                            color: color.withValuesOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            buildSearchField(config),
                            ...items.map((item) {
                              final index = items.indexOf(item);
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

                              final selected = isItemSelected(item);

                              return FadeTransition(
                                opacity: itemAnim,
                                child: Transform(
                                  transform: CustomMatrixUtils.staggerTransform(
                                    progress: itemAnim.value,
                                    startY: 10,
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
                                      if (config.selectionMode ==
                                          SelectionMode.single) {
                                        onToggle();
                                      }
                                    },
                                    child: Container(
                                      padding: itemPadding ?? const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.white.withValuesOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                      child: Row(
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
                                              style: const TextStyle(
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 2,
                                                  ),
                                                ],
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
                            }),
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

  Widget _buildRotatingIcon(AnimationController controller, MultiDropDownConfig config, Color color) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: Icon(
        Icons.arrow_drop_down,
        color: color,
      ),
    );
  }
}