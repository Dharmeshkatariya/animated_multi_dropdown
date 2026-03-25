import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:animated_multi_dropdown/src/utils/custom_matrix_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_down_strategy.dart';

class HolographicFanMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final fanAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    final color = config.highlightColor;
    final hologramColors = [
      color,
      color.withValuesOpacity(0.7),
      color.withValuesOpacity(0.4),
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

    final selector = GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hologramColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValuesOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: displayValue),
              _buildRotatingIcon(controller, config),
            ],
          ),
        ),
      ),
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
          animation: fanAnimation,
          builder: (context, _) {
            return Transform(
              alignment: Alignment.topCenter,
              transform: CustomMatrixUtils.fanSpread(
                progress: fanAnimation.value,
                startX: 10,
                endX: 0,
                startRotation: -0.5,
                endRotation: 0,
              ),
              child: Opacity(
                opacity: fanAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValuesOpacity(0.2),
                                color.withValuesOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withValuesOpacity(0.2),
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
                                    alignment: Alignment.centerLeft,
                                    transform: CustomMatrixUtils.fanSpread(
                                      progress: itemAnim.value,
                                      startX: 10,
                                      endX: 0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        onChanged(item);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white
                                                  .withValuesOpacity(0.1),
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
                                                padding: const EdgeInsets.only(
                                                    right: 12),
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
      child: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
    );
  }
}
