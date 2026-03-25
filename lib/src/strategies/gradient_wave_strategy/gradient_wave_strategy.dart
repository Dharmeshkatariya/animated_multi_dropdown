import 'dart:ui';
import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/gradient_wave_painter.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class GradientWaveMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final waveAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final heightAnim = createHeightAnimation(
      controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    );

    final effectiveHighlightColor = config.highlightColor;
    final colors = [
      effectiveHighlightColor,
      Colors.deepPurpleAccent,
      Colors.blueAccent,
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
            animation: waveAnim,
            builder: (context, _) {
              return CustomPaint(
                painter: GradientWavePainter(
                  progress: waveAnim.value,
                  colors: colors,
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
              child: ClipPath(
                clipper: GradientWaveClipper(progress: waveAnim.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: config.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: colors[0].withValuesOpacity(0.4),
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
                      _buildRotatingIcon(controller, config),
                    ],
                  ),
                ),
              ),
            ),
            if (isOpen)
              SizeTransition(
                sizeFactor: heightAnim,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: config.dropdownBorderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: dropdownWidth ?? config.dropdownWidth,
                        constraints: BoxConstraints(
                          maxHeight:
                              maxDropdownHeight ?? config.maxDropdownHeight,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors[0].withValuesOpacity(0.3),
                              colors[1].withValuesOpacity(0.2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border.all(
                            color: Colors.white.withValuesOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: config.dropdownBorderRadius,
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
                                    final end = (delay + 0.8).clamp(0.0, 1.0);
                                    final itemAnim = Tween(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: controller,
                                        curve: Interval(
                                          (delay + 0.3).clamp(0.0, 1.0),
                                          end,
                                          curve: Curves.easeOutBack,
                                        ),
                                      ),
                                    );

                                    return FadeTransition(
                                      opacity: itemAnim,
                                      child: Transform(
                                        transform:
                                            CustomMatrixUtils.staggerTransform(
                                          progress: itemAnim.value,
                                          startY: 20,
                                          endY: 0,
                                          startScale: 0,
                                          endScale: 1,
                                        ),
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
                                            splashColor: colors[0]
                                                .withValuesOpacity(0.2),
                                            highlightColor: colors[1]
                                                .withValuesOpacity(0.1),
                                            child: Container(
                                              padding: itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                    index < items.length - 1 &&
                                                            showDivider
                                                        ? Border(
                                                            bottom: BorderSide(
                                                              color: dividerColor ??
                                                                  Colors.white
                                                                      .withValuesOpacity(
                                                                          0.1),
                                                              width: dividerThickness ??
                                                                  config
                                                                      .dividerThickness,
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

  Widget _buildRotatingIcon(
      AnimationController controller, MultiDropDownConfig config) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack),
      ),
      child: const Icon(
        Icons.arrow_drop_down_rounded,
        color: Colors.white,
      ),
    );
  }
}
