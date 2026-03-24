import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../base_drop_Down_strategy.dart';
import '../multi_dropdown_animation_strategy.dart';

class MultiNeonDropdownStrategy<T> extends BaseDropdownStrategy<T> {
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
    final glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 1.0),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    final expandAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));

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
      animation: glowAnimation,
      builder: (context, _) {
        return GestureDetector(
          onTap: onToggle,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: config.glowColor.withValuesOpacity(
                    glowAnimation.value * config.glowIntensity,
                  ),
                  blurRadius: 15 * glowAnimation.value,
                  spreadRadius: 2 * glowAnimation.value,
                ),
              ],
              border: Border.all(
                color: config.glowColor.withValuesOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(child: displayValue),
                  _buildRotatingIcon(controller, config),
                ],
              ),
            ),
          ),
        );
      },
    );

    final dropdownMenu = SizeTransition(
      sizeFactor: expandAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border.all(color: config.glowColor.withValuesOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: config.glowColor.withValuesOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: buildDropdownMenu(
            context: context,
            items: items,
            onChanged: onChanged,
            itemBuilder: itemBuilder,
            isItemSelected: isItemSelected,
            config: config,
            buildSearchField: buildSearchField,
            controller: controller,
            maxHeight: maxDropdownHeight,
            width: dropdownWidth,
            itemPadding: itemPadding,
            selectedItemStyle: selectedItemStyle,
            itemStyle: itemStyle,
            showDivider: showDivider,
            dividerColor: dividerColor,
            dividerThickness: dividerThickness,
            backgroundColor: Colors.black87,
            shadows: [BoxShadow(color: config.glowColor.withValuesOpacity(0.2), blurRadius: 20, spreadRadius: 2)],
            elevation: elevation,
          ),
        ),
      ),
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
      child: Icon(
        Icons.arrow_drop_down,
        color: config.glowColor,
      ),
    );
  }
}