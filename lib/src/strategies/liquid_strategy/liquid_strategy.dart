import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/liquid_wave_clipper.dart';
import '../base_drop_down_strategy.dart';

class MultiLiquidDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final waveAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    final opacityAnimation = createOpacityAnimation(
      controller,
      interval: const Interval(0.2, 0.8),
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
      animation: waveAnimation,
      builder: (context, _) {
        return ClipPath(
          clipper: LiquidWaveClipper(waveAnimation.value),
          child: buildSelector(
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
            customDecoration: BoxDecoration(
              gradient: config.gradient ??
                  LinearGradient(
                    colors: config.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              borderRadius: config.borderRadius,
              boxShadow: shadows ?? config.shadows,
            ),
          ),
        );
      },
    );

    final dropdownMenu = SizeTransition(
      sizeFactor: heightAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
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
            backgroundColor: Colors.transparent,
            shadows: config.shadows,
            elevation: elevation,
            customDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: config.gradientColors
                    .map((c) => c.withValuesOpacity(0.8))
                    .toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: config.dropdownBorderRadius,
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
}
