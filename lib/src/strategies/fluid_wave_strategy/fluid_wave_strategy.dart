import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/fluid_wave_painter.dart';
import '../base_drop_down_strategy.dart';

class FluidWaveMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final waveAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuad),
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

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: FluidWavePainter(
                  progress: waveAnimation.value,
                  color: config.highlightColor.withValuesOpacity(0.1),
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
                child: Stack(
                  children: [
                    // Liquid fill background
                    AnimatedBuilder(
                      animation: waveAnimation,
                      builder: (context, _) {
                        return ClipRRect(
                          borderRadius: config.borderRadius,
                          child: SizedBox(
                            height: config.selectorHeight,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: waveAnimation.value,
                              child: Container(
                                color: config.highlightColor.withValuesOpacity(0.1),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
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
                  ],
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
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      decoration: BoxDecoration(
                        color: dropdownBackgroundColor ?? config.backgroundColor,
                        boxShadow: shadows ?? config.shadows,
                      ),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRotatingIcon(AnimationController controller, MultiDropDownConfig config) {
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
      onTap: onTap,
      splashColor: config.highlightColor.withValuesOpacity(0.2),
      highlightColor: config.highlightColor.withValuesOpacity(0.1),
      child: Container(
        padding: itemPadding ?? config.itemPadding,
        decoration: BoxDecoration(
          border: showDivider && index < totalItems - 1
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