import 'dart:math';
import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/glitch_painter.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class CyberpunkMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final glitchAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final heightAnimation = createHeightAnimation(
      controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    );

    final color = config.highlightColor;
    const neonBlue = Colors.cyanAccent;
    final textGlow = <Shadow>[
      Shadow(color: color, blurRadius: 10),
      const Shadow(color: neonBlue, blurRadius: 5),
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
        Positioned.fill(
          child: AnimatedBuilder(
            animation: glitchAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: GlitchPainter(
                  progress: glitchAnimation.value.clamp(0.0, 1.0),
                  color1: color,
                  color2: neonBlue,
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
                constraints: BoxConstraints(
                  minHeight: config.selectorHeight,
                  minWidth: dropdownWidth ?? config.selectorWidth,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValuesOpacity(0.7),
                  borderRadius: config.borderRadius,
                  border:
                      Border.all(color: color.withValuesOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValuesOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: neonBlue.withValuesOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(2, 2),
                    ),
                  ],
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
                      _buildRotatingIcon(controller, config, color, textGlow),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: heightAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: config.dropdownBorderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      constraints: BoxConstraints(
                        maxHeight:
                            maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValuesOpacity(0.5),
                        border: Border.all(
                          color: neonBlue.withValuesOpacity(0.3),
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
                                        delay,
                                        delay + 0.3,
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  );

                                  return AnimatedBuilder(
                                    animation: itemAnim,
                                    builder: (context, _) {
                                      final opacity =
                                          itemAnim.value.clamp(0.0, 1.0);
                                      final glitchOffset =
                                          sin(itemAnim.value * 20) * 2;
                                      return Transform(
                                        transform: CustomMatrixUtils.translate(
                                          x: glitchOffset,
                                        ),
                                        child: Opacity(
                                          opacity: opacity,
                                          child: InkWell(
                                            onTap: () {
                                              onChanged(item);
                                              if (config.selectionMode ==
                                                  SelectionMode.single) {
                                                onToggle();
                                              }
                                            },
                                            splashColor:
                                                color.withValuesOpacity(0.3),
                                            highlightColor:
                                                neonBlue.withValuesOpacity(0.1),
                                            child: Container(
                                              padding: itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                    index < items.length - 1 &&
                                                            showDivider
                                                        ? Border(
                                                            bottom: BorderSide(
                                                              color: neonBlue
                                                                  .withValuesOpacity(
                                                                      0.1),
                                                            ),
                                                          )
                                                        : null,
                                              ),
                                              child: Row(
                                                children: [
                                                  if (config.selectionMode ==
                                                          SelectionMode
                                                              .multiple ||
                                                      (config.selectionMode ==
                                                              SelectionMode
                                                                  .single &&
                                                          config.showCheckmark))
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 12,
                                                      ),
                                                      child:
                                                          buildSelectionIndicator(
                                                        isSelected,
                                                        config,
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child:
                                                        DefaultTextStyle.merge(
                                                      style: (isSelected
                                                              ? selectedItemStyle ??
                                                                  config
                                                                      .selectedItemStyle
                                                              : itemStyle ??
                                                                  config
                                                                      .itemStyle)
                                                          .copyWith(
                                                        color: Colors.white,
                                                        shadows: isSelected
                                                            ? textGlow
                                                            : null,
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
