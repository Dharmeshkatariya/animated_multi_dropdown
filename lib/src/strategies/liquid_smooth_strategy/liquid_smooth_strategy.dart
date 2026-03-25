import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/fluid_liquid_backdrown_painter.dart';
import '../../painters/fluid_clipper.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class LiquidSmoothMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final effectiveHighlightColor = config.highlightColor;
    final dropdownAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.fastEaseInToSlowEaseOut,
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
            animation: controller,
            builder: (context, _) {
              return CustomPaint(
                painter: FluidLiquidBackdrownPainter(
                  progress: dropdownAnim.value.clamp(0.0, 1.0),
                  color: effectiveHighlightColor,
                  isOpen: isOpen,
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
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastEaseInToSlowEaseOut,
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    color: effectiveHighlightColor.withValuesOpacity(
                      isOpen ? 0.15 : 0.1,
                    ),
                    borderRadius: config.borderRadius,
                    border: Border.all(
                      color: Colors.white.withValuesOpacity(isOpen ? 0.4 : 0.2),
                      width: isOpen ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: effectiveHighlightColor.withValuesOpacity(
                          isOpen ? 0.3 : 0.1,
                        ),
                        blurRadius: isOpen ? 25 : 15,
                        spreadRadius: isOpen ? 1.5 : 0.5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        IconTheme.merge(
                          data: IconThemeData(
                            color: Colors.white.withValuesOpacity(0.9),
                            size: 24,
                          ),
                          child: config.leadingIcon!,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(child: displayValue),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child: icon ??
                            Icon(
                              Icons.expand_more_rounded,
                              color: Colors.white.withValuesOpacity(0.9),
                              size: 28,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isOpen)
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final progress = dropdownAnim.value.clamp(0.0, 1.0);
                  return ClipPath(
                    clipper: FluidDropdownClipper(
                      progress: progress,
                      isOpen: isOpen,
                    ),
                    child: Transform(
                      transform: CustomMatrixUtils.molecularBond(
                        progress: progress,
                        startOffset: 30,
                        endOffset: 0,
                      ),
                      child: Opacity(
                        opacity: progress,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: dropdownWidth ?? config.dropdownWidth,
                            constraints: BoxConstraints(
                              maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                            ),
                            decoration: BoxDecoration(
                              color: effectiveHighlightColor.withValuesOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withValuesOpacity(progress * 0.3),
                                width: 1,
                              ),
                              borderRadius: config.dropdownBorderRadius,
                              boxShadow: [
                                BoxShadow(
                                  color: effectiveHighlightColor.withValuesOpacity(0.2 * progress),
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
                                      physics: const BouncingScrollPhysics(),
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
                                              curve: Curves.elasticOut.flipped,
                                            ),
                                          ),
                                        );

                                        return AnimatedBuilder(
                                          animation: itemAnim,
                                          builder: (context, _) {
                                            final itemProgress = itemAnim.value.clamp(0.0, 1.0);
                                            return Transform(
                                              transform: CustomMatrixUtils.staggerTransform(
                                                progress: itemProgress,
                                                startY: 20,
                                                endY: 0,
                                                startScale: 0,
                                                endScale: 1,
                                              ),
                                              child: Opacity(
                                                opacity: itemProgress,
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
                                                    splashColor:
                                                    Colors.white.withValuesOpacity(0.15),
                                                    highlightColor:
                                                    Colors.white.withValuesOpacity(0.08),
                                                    child: Container(
                                                      padding: itemPadding ?? config.itemPadding,
                                                      decoration: BoxDecoration(
                                                        border: index < items.length - 1 &&
                                                            showDivider
                                                            ? Border(
                                                          bottom: BorderSide(
                                                            color: dividerColor ??
                                                                Colors.white
                                                                    .withValuesOpacity(0.15),
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
                                                                  : itemStyle ??
                                                                  config.itemStyle)
                                                                  .copyWith(
                                                                color: Colors.white
                                                                    .withValuesOpacity(0.95),
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
                },
              ),
          ],
        ),
      ],
    );
  }
}