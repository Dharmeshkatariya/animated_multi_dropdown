import 'package:animated_multi_dropdown/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/multi_dropdown_config.dart';
import '../../models/selection_mode.dart';
import '../../painters/cyber_grid_painter.dart';
import '../../utils/custom_matrix_utils.dart';
import '../base_drop_down_strategy.dart';

class CyberNeonMultiDropdownStrategy<T> extends BaseDropDownStrategy<T> {
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
    final gridAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final effectiveHighlightColor = config.highlightColor;
    const neonBlue = Colors.cyanAccent;
    final textGlow = [
      Shadow(color: effectiveHighlightColor, blurRadius: 10),
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
        AnimatedBuilder(
          animation: gridAnim,
          builder: (context, _) {
            return CustomPaint(
              painter: CyberGridPainter(
                progress: gridAnim.value,
                color1: effectiveHighlightColor,
                color2: neonBlue,
              ),
            );
          },
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  minHeight: config.selectorHeight,
                  minWidth: dropdownWidth ?? config.selectorWidth,
                ),
                padding: padding ?? config.padding,
                decoration: BoxDecoration(
                  color: Colors.black.withValuesOpacity(0.7),
                  borderRadius: config.borderRadius,
                  border: Border.all(
                    color: effectiveHighlightColor.withValuesOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveHighlightColor.withValuesOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (config.leadingIcon != null) ...[
                      IconTheme.merge(
                        data: IconThemeData(
                          color: effectiveHighlightColor,
                          shadows: textGlow,
                        ),
                        child: config.leadingIcon!,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(child: displayValue),
                    _buildRotatingIcon(
                        controller, config, effectiveHighlightColor, textGlow),
                  ],
                ),
              ),
            ),
            if (isOpen)
              AnimatedBuilder(
                animation: gridAnim,
                builder: (context, _) {
                  return ClipPath(
                    clipper: _CyberClipper(progress: gridAnim.value),
                    child: Transform(
                      transform: CustomMatrixUtils.molecularBond(
                        progress: gridAnim.value,
                        startOffset: 20,
                        endOffset: 0,
                      ),
                      child: Opacity(
                        opacity: gridAnim.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: dropdownWidth ?? config.dropdownWidth,
                            constraints: BoxConstraints(
                              maxHeight:
                                  maxDropdownHeight ?? config.maxDropdownHeight,
                            ),
                            decoration: BoxDecoration(
                              color: dropdownBackgroundColor ??
                                  Colors.black.withValuesOpacity(0.8),
                              border: Border.all(
                                color: effectiveHighlightColor
                                    .withValuesOpacity(0.3),
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
                                        final itemAnim = Tween(
                                          begin: 0.0,
                                          end: 1.0,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: controller,
                                            curve: Interval(
                                              delay,
                                              delay + 0.4,
                                              curve: Curves.easeOutBack,
                                            ),
                                          ),
                                        );

                                        return FadeTransition(
                                          opacity: itemAnim,
                                          child: Transform(
                                            transform: CustomMatrixUtils
                                                .staggerTransform(
                                              progress: itemAnim.value,
                                              startY: 15,
                                              endY: 0,
                                              startScale: 0,
                                              endScale: 1,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  if (config
                                                      .enableHapticFeedback) {
                                                    HapticFeedback
                                                        .lightImpact();
                                                  }
                                                  onChanged(item);
                                                  if (config.selectionMode ==
                                                      SelectionMode.single) {
                                                    onToggle();
                                                  }
                                                },
                                                splashColor:
                                                    effectiveHighlightColor
                                                        .withValuesOpacity(0.2),
                                                highlightColor: neonBlue
                                                    .withValuesOpacity(0.1),
                                                child: Container(
                                                  padding: itemPadding ??
                                                      config.itemPadding,
                                                  decoration: BoxDecoration(
                                                    border: index <
                                                                items.length -
                                                                    1 &&
                                                            showDivider
                                                        ? Border(
                                                            bottom: BorderSide(
                                                              color: dividerColor ??
                                                                  effectiveHighlightColor
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
                                                              config
                                                                  .showCheckmark))
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 12,
                                                          ),
                                                          child:
                                                              buildSelectionIndicator(
                                                            isSelected,
                                                            config,
                                                          ),
                                                        ),
                                                      Expanded(
                                                        child: DefaultTextStyle
                                                            .merge(
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
                                                          child:
                                                              itemBuilder(item),
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
                  );
                },
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
        Icons.arrow_drop_down_rounded,
        color: color,
        shadows: textGlow,
      ),
    );
  }
}

class _CyberClipper extends CustomClipper<Path> {
  final double progress;

  _CyberClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  @override
  bool shouldReclip(_CyberClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
