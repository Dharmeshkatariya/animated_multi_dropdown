import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/multi_dropdown_config.dart';
import '../models/selection_mode.dart';
import '../painters/bond_painter.dart';
import '../painters/cosmic_ripple_painter.dart';
import '../painters/cyber_grid_painter.dart';
import '../painters/fluid_clipper.dart';
import '../painters/fluid_liquid_backdrown_painter.dart';
import '../painters/fluid_wave_painter.dart';
import '../painters/glitch_painter.dart';
import '../painters/gradient_wave_painter.dart';
import '../painters/gravity_well_painter.dart';
import '../painters/holo_gram_painter.dart';
import '../painters/liquid_swipe_painter.dart';
import '../painters/liquid_wave_clipper.dart';
import '../painters/morphing.dart';
import '../painters/morphing_gradient_painter.dart';
import '../widgets/custom_animated_multi_dropdown.dart';

class MultiGlassDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    final heightAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final dropDownBorderRadius = config.dropdownBorderRadius;

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item); // This will remove the item
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
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
              borderRadius: config.borderRadius,
              border: config.border,
              boxShadow: shadows ?? config.shadows,
              gradient: config.gradient,
            ),
            child: ClipRRect(
              borderRadius: config.borderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: config.blurIntensity,
                  sigmaY: config.blurIntensity,
                ),
                child: Container(
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    color:
                    dropdownBackgroundColor?.withOpacity(0.13) ??
                        config.backgroundColor.withOpacity(0.13),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (config.leadingIcon != null) ...[
                            config.leadingIcon!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(child: buildDisplayValue()),
                          const SizedBox(width: 8),
                          RotationTransition(
                            turns: Tween(
                              begin: 0.0,
                              end: 0.5,
                            ).animate(controller),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: config.highlightColor,
                                ),
                          ),
                        ],
                      ),
                      // Additional space for chips if needed
                      if (config.selectionMode == SelectionMode.multiple &&
                          value is List<T> &&
                          (value).isNotEmpty)
                        const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: heightAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                ),
                child: ClipRRect(
                  borderRadius: dropDownBorderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: config.blurIntensity,
                      sigmaY: config.blurIntensity,
                    ),
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      decoration: BoxDecoration(
                        color:
                        dropdownBackgroundColor?.withOpacity(0.13) ??
                            config.backgroundColor.withOpacity(0.13),
                        borderRadius: dropDownBorderRadius,
                        border: config.dropdownBorder,
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildSearchField(config),
                            Flexible(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final selected = isItemSelected(item);

                                  return InkWell(
                                    onTap: () {
                                      if (config.enableHapticFeedback) {
                                        HapticFeedback.lightImpact();
                                      }
                                      onChanged(item);
                                    },
                                    splashColor: config.highlightColor
                                        .withOpacity(0.2),
                                    highlightColor: config.highlightColor
                                        .withOpacity(0.1),
                                    child: Container(
                                      padding:
                                      itemPadding ?? config.itemPadding,
                                      decoration: BoxDecoration(
                                        border:
                                        index < items.length - 1 &&
                                            showDivider
                                            ? Border(
                                          bottom: BorderSide(
                                            color:
                                            dividerColor ??
                                                config.dividerColor,
                                            width:
                                            dividerThickness ??
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
                                                selected,
                                                config,
                                              ),
                                            ),
                                          Expanded(
                                            child: DefaultTextStyle.merge(
                                              style:
                                              selected
                                                  ? selectedItemStyle ??
                                                  config
                                                      .selectedItemStyle
                                                  : itemStyle ??
                                                  config.itemStyle,
                                              child: itemBuilder(item),
                                            ),
                                          ),
                                        ],
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
          ),
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MultiLiquidDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final waveAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    final dropDownBorderRadius = config.dropdownBorderRadius;

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }

        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item); // This will remove the item
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onToggle();
          },
          child: AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, child) {
              return ClipPath(
                clipper: LiquidWaveClipper(waveAnimation.value),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                    config.gradient ??
                        LinearGradient(
                          colors: config.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                    borderRadius: config.borderRadius,
                    boxShadow: shadows ?? config.shadows,
                  ),
                  child: Container(
                    padding: padding ?? config.padding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            if (config.leadingIcon != null) ...[
                              config.leadingIcon!,
                              const SizedBox(width: 8),
                            ],
                            Expanded(child: buildDisplayValue()),
                            const SizedBox(width: 8),
                            RotationTransition(
                              turns: Tween(
                                begin: 0.0,
                                end: 0.5,
                              ).animate(controller),
                              child:
                              icon ??
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        // Additional space for chips if needed
                        if (config.selectionMode == SelectionMode.multiple &&
                            value is List<T> &&
                            (value).isNotEmpty)
                          const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizeTransition(
          sizeFactor: heightAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                ),
                child: ClipRRect(
                  borderRadius: dropDownBorderRadius,
                  child: Container(
                    width: dropdownWidth ?? config.dropdownWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                        config.gradientColors
                            .map((c) => c.withOpacity(0.8))
                            .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: dropDownBorderRadius,
                      boxShadow: config.shadows,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildSearchField(config),
                          Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final selected = isItemSelected(item);

                                return InkWell(
                                  onTap: () {
                                    if (config.enableHapticFeedback) {
                                      HapticFeedback.lightImpact();
                                    }
                                    onChanged(item);
                                  },
                                  splashColor: config.highlightColor
                                      .withOpacity(0.3),
                                  highlightColor: config.highlightColor
                                      .withOpacity(0.1),
                                  child: Container(
                                    padding: itemPadding ?? config.itemPadding,
                                    decoration: BoxDecoration(
                                      border:
                                      index < items.length - 1 &&
                                          showDivider
                                          ? Border(
                                        bottom: BorderSide(
                                          color:
                                          dividerColor ??
                                              config.dividerColor,
                                          width:
                                          dividerThickness ??
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
                                              selected,
                                              config,
                                            ),
                                          ),
                                        Expanded(
                                          child: DefaultTextStyle.merge(
                                            style:
                                            selected
                                                ? selectedItemStyle ??
                                                config.selectedItemStyle
                                                : itemStyle ??
                                                config.itemStyle,
                                            child: itemBuilder(item),
                                          ),
                                        ),
                                      ],
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
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MultiNeonDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main selector with neon effect
        GestureDetector(
          onTap: onToggle,
          child: AnimatedBuilder(
            animation: glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: config.glowColor.withOpacity(
                        glowAnimation.value * (config.glowIntensity ?? 0.8),
                      ),
                      blurRadius: 15 * glowAnimation.value,
                      spreadRadius: 2 * glowAnimation.value,
                    ),
                  ],
                  border: Border.all(
                    color: config.glowColor.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: buildDisplayValue()),
                          RotationTransition(
                            turns: Tween(
                              begin: 0.0,
                              end: 0.5,
                            ).animate(controller),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: config.glowColor,
                            ),
                          ),
                        ],
                      ),
                      if (config.selectionMode == SelectionMode.multiple &&
                          value is List<T> &&
                          (value).length > 1)
                        const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Dropdown items
        SizeTransition(
          sizeFactor: expandAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                border: Border.all(color: config.glowColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: config.glowColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildSearchField(config),
                  ...items
                      .map(
                        (item) => GestureDetector(
                      onTap: () {
                        onChanged(item);
                        if (config.selectionMode == SelectionMode.single) {
                          onToggle();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: config.glowColor.withOpacity(0.1),
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
                                  isItemSelected(item),
                                  config,
                                ),
                              ),
                            Expanded(child: itemBuilder(item)),
                          ],
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MultiBounce3DDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    final depthAnimation = Tween(begin: 0.0, end: config.depth).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onToggle();
          },
          child: AnimatedBuilder(
            animation: depthAnimation,
            builder: (context, child) {
              return Transform(
                transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.0, 0.0, depthAnimation.value),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  decoration: BoxDecoration(
                    color: config.backgroundColor,
                    borderRadius: config.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: depthAnimation.value,
                        offset: Offset(0, depthAnimation.value),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: padding ?? config.padding,
                    decoration: BoxDecoration(
                      color: config.backgroundColor,
                      borderRadius: config.borderRadius,
                      border: Border.all(
                        color: config.highlightColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (config.leadingIcon != null) ...[
                              config.leadingIcon!,
                              const SizedBox(width: 8),
                            ],
                            Expanded(child: buildDisplayValue()),
                            RotationTransition(
                              turns: rotateAnimation,
                              child:
                              icon ??
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: config.highlightColor,
                                  ),
                            ),
                          ],
                        ),
                        if (config.selectionMode == SelectionMode.multiple &&
                            value is List<T> &&
                            (value).isNotEmpty)
                          const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizeTransition(
          sizeFactor: heightAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipRRect(
              borderRadius: config.dropdownBorderRadius,
              child: Container(
                width: dropdownWidth ?? config.dropdownWidth,
                constraints: BoxConstraints(
                  maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                ),
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  borderRadius: config.dropdownBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    children: [
                      buildSearchField(config),
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final selected = isItemSelected(item);

                            return InkWell(
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
                              splashColor: config.highlightColor.withOpacity(
                                0.3,
                              ),
                              highlightColor: config.highlightColor.withOpacity(
                                0.1,
                              ),
                              child: Container(
                                padding: itemPadding ?? config.itemPadding,
                                decoration: BoxDecoration(
                                  border:
                                  index < items.length - 1 && showDivider
                                      ? Border(
                                    bottom: BorderSide(
                                      color:
                                      dividerColor ??
                                          config.dividerColor,
                                      width:
                                      dividerThickness ??
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
                                          selected,
                                          config,
                                        ),
                                      ),
                                    Expanded(
                                      child: DefaultTextStyle.merge(
                                        style:
                                        selected
                                            ? selectedItemStyle ??
                                            config.selectedItemStyle
                                            : itemStyle ?? config.itemStyle,
                                        child: itemBuilder(item),
                                      ),
                                    ),
                                  ],
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
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class FloatingCardsMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final floatAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector
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
            child: Padding(
              padding: padding ?? config.padding,
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: buildDisplayValue()),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child:
                    icon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: config.highlightColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isOpen)
          AnimatedBuilder(
            animation: floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - floatAnimation.value)),
                child: Opacity(
                  opacity: floatAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight:
                        maxDropdownHeight ?? config.maxDropdownHeight,
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

                                  return ScaleTransition(
                                    scale: itemAnim,
                                    child: Card(
                                      margin: EdgeInsets.only(
                                        bottom:
                                        index == items.length - 1 ? 0 : 8,
                                      ),
                                      elevation: elevation ?? 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        config.dropdownBorderRadius ??
                                            BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                          isSelected
                                              ? config.highlightColor
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
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
                                        borderRadius:
                                        config.dropdownBorderRadius ??
                                            BorderRadius.circular(8),
                                        child: Padding(
                                          padding:
                                          itemPadding ?? config.itemPadding,
                                          child: Row(
                                            children: [
                                              if (config.selectionMode ==
                                                  SelectionMode.multiple ||
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
                                                child: DefaultTextStyle.merge(
                                                  style:
                                                  isSelected
                                                      ? selectedItemStyle ??
                                                      config
                                                          .selectedItemStyle
                                                      : itemStyle ??
                                                      config.itemStyle,
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
              );
            },
          ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MorphingMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final morphAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final radiusAnimation = Tween(begin: 12.0, end: 24.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        AnimatedBuilder(
          animation: morphAnimation,
          builder: (context, child) {
            return Positioned.fill(
              child: CustomPaint(
                painter: MorphingPainter(
                  progress: morphAnimation.value,
                  color: config.highlightColor,
                ),
              ),
            );
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector
            GestureDetector(
              onTap: () {
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
                onToggle();
              },
              child: AnimatedBuilder(
                animation: radiusAnimation,
                builder: (context, child) {
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: config.selectorHeight,
                      minWidth: dropdownWidth ?? config.selectorWidth,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: config.backgroundColor,
                      borderRadius: BorderRadius.circular(
                        radiusAnimation.value,
                      ),
                      boxShadow: shadows ?? config.shadows,
                    ),
                    child: Padding(
                      padding: padding ?? config.padding,
                      child: Row(
                        children: [
                          if (config.leadingIcon != null) ...[
                            config.leadingIcon!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(child: buildDisplayValue()),
                          const SizedBox(width: 8),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: config.highlightColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dropdown items
            SizeTransition(
              sizeFactor: heightAnimation,
              child: ClipRRect(
                borderRadius:
                config.dropdownBorderRadius ?? BorderRadius.circular(12),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    color: dropdownBackgroundColor ?? Colors.white,
                    elevation: elevation ?? 4,
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

                              return InkWell(
                                onTap: () {
                                  if (config.enableHapticFeedback) {
                                    HapticFeedback.lightImpact();
                                  }
                                  onChanged(item);
                                },
                                child: Container(
                                  padding: itemPadding ?? config.itemPadding,
                                  decoration: BoxDecoration(
                                    border:
                                    showDivider && index < items.length - 1
                                        ? Border(
                                      bottom: BorderSide(
                                        color:
                                        dividerColor ??
                                            config.dividerColor,
                                        width:
                                        dividerThickness ??
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
                                            selected,
                                            config,
                                          ),
                                        ),
                                      Expanded(
                                        child: DefaultTextStyle.merge(
                                          style:
                                          selected
                                              ? selectedItemStyle ??
                                              config.selectedItemStyle
                                              : itemStyle ??
                                              config.itemStyle,
                                          child: itemBuilder(item),
                                        ),
                                      ),
                                    ],
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
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class StaggeredMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector
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
            child: Padding(
              padding: padding ?? config.padding,
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: buildDisplayValue()),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child:
                    icon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: config.highlightColor,
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
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildSearchField(config),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(items.length, (index) {
                            final start = min(0.1 + (0.1 * index), 0.9);
                            final end = min(0.5 + (0.1 * index), 1.0);
                            final itemAnim = Tween(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Interval(
                                  start,
                                  end,
                                  curve: config.curve,
                                ),
                              ),
                            );

                            final item = items[index];
                            final selected = isItemSelected(item);

                            return ScaleTransition(
                              scale: itemAnim,
                              child: FadeTransition(
                                opacity: itemAnim,
                                child: GestureDetector(
                                  onTap: () {
                                    if (config.enableHapticFeedback) {
                                      HapticFeedback.lightImpact();
                                    }
                                    onChanged(item);
                                  },
                                  child: Container(
                                    padding: itemPadding ?? config.itemPadding,
                                    decoration: BoxDecoration(
                                      color:
                                      dropdownBackgroundColor ??
                                          config.backgroundColor,
                                      borderRadius: config.dropdownBorderRadius,
                                      border: Border.all(
                                        color:
                                        selected
                                            ? config.highlightColor
                                            : Colors.grey.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                              selected,
                                              config,
                                            ),
                                          ),
                                        DefaultTextStyle.merge(
                                          style:
                                          selected
                                              ? selectedItemStyle ??
                                              config.selectedItemStyle
                                              : itemStyle ??
                                              config.itemStyle,
                                          child: itemBuilder(item),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class StaggeredVerticalMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector
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
            child: Padding(
              padding: padding ?? config.padding,
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: buildDisplayValue()),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child:
                    icon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: config.highlightColor,
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
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildSearchField(config),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(items.length, (index) {
                            final start = min(0.1 + (0.1 * index), 0.9);
                            final end = min(0.5 + (0.1 * index), 1.0);
                            final itemAnim = Tween(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Interval(
                                  start,
                                  end,
                                  curve: config.curve,
                                ),
                              ),
                            );

                            final item = items[index];
                            final selected = isItemSelected(item);

                            return ScaleTransition(
                              scale: itemAnim,
                              child: FadeTransition(
                                opacity: itemAnim,
                                child: GestureDetector(
                                  onTap: () {
                                    if (config.enableHapticFeedback) {
                                      HapticFeedback.lightImpact();
                                    }
                                    onChanged(item);
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth:
                                      dropdownWidth ?? config.selectorWidth,
                                    ),
                                    padding: itemPadding ?? config.itemPadding,
                                    decoration: BoxDecoration(
                                      color:
                                      dropdownBackgroundColor ??
                                          config.backgroundColor,
                                      borderRadius: config.dropdownBorderRadius,
                                      border: Border.all(
                                        color:
                                        selected
                                            ? config.highlightColor
                                            : Colors.grey.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                              selected,
                                              config,
                                            ),
                                          ),
                                        Expanded(
                                          child: DefaultTextStyle.merge(
                                            style:
                                            selected
                                                ? selectedItemStyle ??
                                                config.selectedItemStyle
                                                : itemStyle ??
                                                config.itemStyle,
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class FoldableMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final foldAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    const itemHeight = 55.0;

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector
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
            child: Padding(
              padding: padding ?? config.padding,
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: buildDisplayValue()),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child:
                    icon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: config.highlightColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Foldable dropdown
        AnimatedBuilder(
          animation: foldAnimation,
          builder: (context, child) {
            final totalHeight = items.length * itemHeight;
            final visibleHeight = totalHeight * foldAnimation.value;
            final maxHeight = maxDropdownHeight ?? config.maxDropdownHeight;

            return SizedBox(
              height: visibleHeight.clamp(0.0, maxHeight),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: foldAnimation.value,
                  child: Container(
                    width: dropdownWidth ?? config.dropdownWidth,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: dropdownBackgroundColor ?? config.backgroundColor,
                      borderRadius: config.dropdownBorderRadius,
                      boxShadow: shadows ?? config.shadows,
                    ),
                    child: Column(
                      children: [
                        buildSearchField(config),
                        Expanded(
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final selected = isItemSelected(item);

                              return InkWell(
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
                                borderRadius:
                                index == items.length - 1
                                    ? BorderRadius.only(
                                  bottomLeft:
                                  (config.dropdownBorderRadius
                                  as BorderRadius)
                                      .bottomLeft,
                                  bottomRight:
                                  config
                                      .dropdownBorderRadius
                                      .bottomRight,
                                  topLeft: Radius.zero,
                                  topRight: Radius.zero,
                                )
                                    : null,
                                child: Container(
                                  height: itemHeight,
                                  padding: itemPadding ?? config.itemPadding,
                                  decoration: BoxDecoration(
                                    border:
                                    showDivider && index < items.length - 1
                                        ? Border(
                                      bottom: BorderSide(
                                        color:
                                        dividerColor ??
                                            config.dividerColor,
                                        width:
                                        dividerThickness ??
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
                                            selected,
                                            config,
                                          ),
                                        ),
                                      Expanded(
                                        child: DefaultTextStyle.merge(
                                          style:
                                          selected
                                              ? selectedItemStyle ??
                                              config.selectedItemStyle
                                              : itemStyle ??
                                              config.itemStyle,
                                          child: itemBuilder(item),
                                        ),
                                      ),
                                    ],
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
            );
          },
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class FluidWaveMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuad),
      ),
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: FluidWavePainter(
                  progress: waveAnimation.value,
                  color: config.highlightColor.withOpacity(0.1),
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
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: config.borderRadius,
                          child: SizedBox(
                            height: config.selectorHeight,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: waveAnimation.value,
                              child: Container(
                                color: config.highlightColor.withOpacity(0.1),
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
                          Expanded(child: buildDisplayValue()),
                          const SizedBox(width: 8),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: config.highlightColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Wave-revealed dropdown
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
                        color:
                        dropdownBackgroundColor ?? config.backgroundColor,
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

                                return InkWell(
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
                                    padding: itemPadding ?? config.itemPadding,
                                    decoration: BoxDecoration(
                                      border:
                                      showDivider &&
                                          index < items.length - 1
                                          ? Border(
                                        bottom: BorderSide(
                                          color:
                                          dividerColor ??
                                              config.dividerColor,
                                          width:
                                          dividerThickness ??
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
                                              selected,
                                              config,
                                            ),
                                          ),
                                        Expanded(
                                          child: DefaultTextStyle.merge(
                                            style:
                                            selected
                                                ? selectedItemStyle ??
                                                config.selectedItemStyle
                                                : itemStyle ??
                                                config.itemStyle,
                                            child: itemBuilder(item),
                                          ),
                                        ),
                                      ],
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
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class HolographicFanMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final fanAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    final color = config.highlightColor;
    final hologramColors = [
      color,
      color.withOpacity(0.7),
      color.withOpacity(0.4),
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: const TextStyle(
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.white.withOpacity(0.2),
              label: DefaultTextStyle.merge(
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18, color: Colors.white),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: const TextStyle(
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: const TextStyle(
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
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
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: buildDisplayValue()),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isOpen)
          AnimatedBuilder(
            animation: fanAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.topCenter,
                transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-0.5 * fanAnimation.value),
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
                                  color.withOpacity(0.2),
                                  color.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
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
                                      transform:
                                      Matrix4.identity()..translate(
                                        10.0 * (1 - itemAnim.value),
                                        0.0,
                                        0.0,
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
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              if (config.selectionMode ==
                                                  SelectionMode.multiple ||
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
                                }).toList(),
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MolecularMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final bondAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onToggle();
          },
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: bondAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BondPainter(
                      progress: bondAnimation.value,
                      color: config.highlightColor,
                      isOpen: isOpen,
                    ),
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
                      child: Padding(
                        padding: padding ?? config.padding,
                        child: Row(
                          children: [
                            if (config.leadingIcon != null) ...[
                              config.leadingIcon!,
                              const SizedBox(width: 8),
                            ],
                            Expanded(child: buildDisplayValue()),
                            const SizedBox(width: 8),
                            RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5).animate(
                                CurvedAnimation(
                                  parent: controller,
                                  curve: Curves.easeInOutBack,
                                ),
                              ),
                              child:
                              icon ??
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: config.highlightColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (isOpen)
          AnimatedBuilder(
            animation: bondAnimation,
            builder: (context, child) {
              return Transform(
                transform:
                Matrix4.identity()
                  ..translate(0.0, 20 * (1 - bondAnimation.value), 0.0),
                child: Opacity(
                  opacity: bondAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                        maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      child: Material(
                        elevation: elevation ?? 4,
                        borderRadius: config.dropdownBorderRadius,
                        child: ClipRRect(
                          borderRadius: config.dropdownBorderRadius,
                          child: Container(
                            width: dropdownWidth ?? config.dropdownWidth,
                            color:
                            dropdownBackgroundColor ??
                                config.backgroundColor,
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
                                            curve: config.curve,
                                          ),
                                        ),
                                      );

                                      return ScaleTransition(
                                        scale: itemAnim,
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
                                          child: Container(
                                            padding:
                                            itemPadding ??
                                                config.itemPadding,
                                            decoration: BoxDecoration(
                                              border:
                                              showDivider &&
                                                  index <
                                                      items.length - 1
                                                  ? Border(
                                                bottom: BorderSide(
                                                  color:
                                                  dividerColor ??
                                                      config
                                                          .dividerColor,
                                                  width:
                                                  dividerThickness ??
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
                                                      selected,
                                                      config,
                                                    ),
                                                  ),
                                                Expanded(
                                                  child: DefaultTextStyle.merge(
                                                    style:
                                                    selected
                                                        ? selectedItemStyle ??
                                                        config
                                                            .selectedItemStyle
                                                        : itemStyle ??
                                                        config
                                                            .itemStyle,
                                                    child: itemBuilder(item),
                                                  ),
                                                ),
                                              ],
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
              );
            },
          ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class CosmicRippleMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final rippleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuad),
      ),
    );

    final color = config.highlightColor;

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: const TextStyle(
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.white.withOpacity(0.2),
              label: DefaultTextStyle.merge(
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18, color: Colors.white),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: const TextStyle(
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: const TextStyle(
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
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
                      Expanded(child: buildDisplayValue()),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeInOutBack,
                          ),
                        ),
                        child:
                        icon ?? Icon(Icons.arrow_drop_down, color: color),
                      ),
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
                    borderRadius:
                    config.dropdownBorderRadius ??
                        BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 + (5 * rippleAnimation.value),
                        sigmaY: 5 + (5 * rippleAnimation.value),
                      ),
                      child: Container(
                        width: dropdownWidth ?? config.dropdownWidth,
                        decoration: BoxDecoration(
                          color:
                          dropdownBackgroundColor ??
                              Colors.black.withOpacity(0.5),
                          borderRadius:
                          config.dropdownBorderRadius ??
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: color.withOpacity(0.3),
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
                                  transform:
                                  Matrix4.identity()..translate(
                                    0.0,
                                    10 * (1 - itemAnim.value),
                                    0.0,
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
                                      padding:
                                      itemPadding ??
                                          const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
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
                                                right: 12,
                                              ),
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
                            }).toList(),
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class GravityWellMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final gravityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: hintStyle ?? config.hintStyle,
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style:
                config.chipLabelStyle ??
                    const TextStyle(color: Colors.black),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: selectedItemStyle ?? config.selectedItemStyle,
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: hintStyle ?? config.hintStyle,
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: gravityAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: GravityWellPainter(
                  progress: gravityAnimation.value,
                  color: config.highlightColor,
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
                  color: Colors.white,
                  borderRadius: config.borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: config.highlightColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
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
                      Expanded(child: buildDisplayValue()),
                      const SizedBox(width: 8),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeInOutBack,
                          ),
                        ),
                        child:
                        icon ??
                            Icon(
                              Icons.arrow_drop_down,
                              color: config.highlightColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: gravityAnimation,
              builder: (context, child) {
                return Transform(
                  transform:
                  Matrix4.identity()
                    ..translate(0.0, 30 * (1 - gravityAnimation.value), 0.0)
                    ..scale(1.0, 0.5 + 0.5 * gravityAnimation.value, 1.0),
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Material(
                        elevation: elevation ?? config.elevation,
                        borderRadius: config.dropdownBorderRadius,
                        child: ClipRRect(
                          borderRadius: config.dropdownBorderRadius,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                              maxDropdownHeight ?? config.maxDropdownHeight,
                            ),
                            width: dropdownWidth ?? config.dropdownWidth,
                            color:
                            dropdownBackgroundColor ??
                                config.backgroundColor,
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

                                      return Transform(
                                        transform:
                                        Matrix4.identity()..translate(
                                          0.0,
                                          10 * (1 - itemAnim.value),
                                          0.0,
                                        ),
                                        child: FadeTransition(
                                          opacity: itemAnim,
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
                                            splashColor: config.highlightColor
                                                .withOpacity(0.2),
                                            highlightColor: config
                                                .highlightColor
                                                .withOpacity(0.1),
                                            child: Container(
                                              padding:
                                              itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                index < items.length - 1 &&
                                                    showDivider
                                                    ? Border(
                                                  bottom: BorderSide(
                                                    color:
                                                    dividerColor ??
                                                        config
                                                            .dividerColor,
                                                    width:
                                                    dividerThickness ??
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
                                                        selected,
                                                        config,
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: DefaultTextStyle.merge(
                                                      style:
                                                      selected
                                                          ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                          : itemStyle ??
                                                          config
                                                              .itemStyle,
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
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class NeonPulseMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.8), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuint),
      ),
    );

    final effectiveHighlightColor = config.highlightColor ?? Colors.cyan;
    final textGlow = <Shadow>[
      Shadow(color: effectiveHighlightColor, blurRadius: 10),
      Shadow(color: effectiveHighlightColor, blurRadius: 20),
      const Shadow(color: Colors.white, blurRadius: 5),
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(shadows: textGlow),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.black))
                    .copyWith(shadows: textGlow),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            shadows: textGlow,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            shadows: textGlow,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onToggle();
          },
          child: AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: config.selectorHeight,
                  minWidth: dropdownWidth ?? config.selectorWidth,
                ),
                decoration: BoxDecoration(
                  borderRadius: config.borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: effectiveHighlightColor.withOpacity(
                        0.5 * pulseAnimation.value,
                      ),
                      blurRadius: 20 * pulseAnimation.value,
                      spreadRadius: 2,
                    ),
                    ...(shadows ?? config.shadows ?? []),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: config.borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: padding ?? config.padding,
                      decoration: BoxDecoration(
                        borderRadius: config.borderRadius,
                        border: Border.all(
                          color: effectiveHighlightColor.withOpacity(0.7),
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            effectiveHighlightColor.withOpacity(0.2),
                            effectiveHighlightColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (config.leadingIcon != null) ...[
                            config.leadingIcon!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(child: buildDisplayValue()),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: effectiveHighlightColor,
                                  shadows: textGlow,
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
        SizeTransition(
          sizeFactor: heightAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ClipRRect(
              borderRadius: config.dropdownBorderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: dropdownWidth ?? config.dropdownWidth,
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: config.dropdownBorderRadius,
                    border: Border.all(
                      color: effectiveHighlightColor.withOpacity(0.3),
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
                              final delay = index * 0.07;
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
                                  transform:
                                  Matrix4.identity()..translate(
                                    0.0,
                                    20 * (1 - itemAnim.value),
                                    0.0,
                                  ),
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
                                    splashColor: effectiveHighlightColor
                                        .withOpacity(0.2),
                                    highlightColor: effectiveHighlightColor
                                        .withOpacity(0.1),
                                    child: Container(
                                      padding:
                                      itemPadding ?? config.itemPadding,
                                      decoration: BoxDecoration(
                                        border:
                                        index < items.length - 1 &&
                                            showDivider
                                            ? Border(
                                          bottom: BorderSide(
                                            color:
                                            dividerColor ??
                                                effectiveHighlightColor
                                                    .withOpacity(0.1),
                                            width:
                                            dividerThickness ??
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
                                              style:
                                              (isSelected
                                                  ? selectedItemStyle ??
                                                  config
                                                      .selectedItemStyle
                                                  : itemStyle ??
                                                  config.itemStyle)
                                                  ?.copyWith(
                                                shadows:
                                                isSelected
                                                    ? textGlow
                                                    : null,
                                              ) ??
                                                  TextStyle(
                                                    color: Colors.white,
                                                    shadows:
                                                    isSelected
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
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class GlassMorphismMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final blurAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    final heightAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final effectiveHighlightColor = config.highlightColor ?? Colors.white;
    final color =
        dropdownBackgroundColor ??
            config.backgroundColor ??
            Colors.white.withOpacity(0.2);

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: effectiveHighlightColor.withOpacity(0.9),
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: config.chipColor ?? Colors.grey[200],
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.black))
                    .copyWith(
                  color: effectiveHighlightColor.withOpacity(0.9),
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: effectiveHighlightColor.withOpacity(0.9),
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: effectiveHighlightColor.withOpacity(0.9),
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onToggle();
          },
          child: AnimatedBuilder(
            animation: blurAnimation,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: config.selectorHeight,
                  minWidth: dropdownWidth ?? config.selectorWidth,
                ),
                decoration: BoxDecoration(
                  borderRadius: config.borderRadius,
                  boxShadow: shadows ?? config.shadows,
                ),
                child: ClipRRect(
                  borderRadius: config.borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10 * blurAnimation.value,
                      sigmaY: 10 * blurAnimation.value,
                    ),
                    child: Container(
                      padding: padding ?? config.padding,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: config.borderRadius,
                        border: Border.all(
                          color: effectiveHighlightColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (config.leadingIcon != null) ...[
                            config.leadingIcon!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(child: buildDisplayValue()),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: effectiveHighlightColor.withOpacity(
                                    0.8,
                                  ),
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
        SizeTransition(
          sizeFactor: heightAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipRRect(
              borderRadius: config.dropdownBorderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: dropdownWidth ?? config.dropdownWidth,
                  constraints: BoxConstraints(
                    maxHeight: maxDropdownHeight ?? config.maxDropdownHeight,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: config.dropdownBorderRadius,
                    border: Border.all(
                      color: effectiveHighlightColor.withOpacity(0.2),
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
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              );

                              return FadeTransition(
                                opacity: itemAnim,
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
                                  splashColor: effectiveHighlightColor
                                      .withOpacity(0.1),
                                  highlightColor: effectiveHighlightColor
                                      .withOpacity(0.05),
                                  child: Container(
                                    padding: itemPadding ?? config.itemPadding,
                                    decoration: BoxDecoration(
                                      border:
                                      index < items.length - 1 &&
                                          showDivider
                                          ? Border(
                                        bottom: BorderSide(
                                          color:
                                          dividerColor ??
                                              effectiveHighlightColor
                                                  .withOpacity(0.1),
                                          width:
                                          dividerThickness ??
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
                                            style:
                                            (isSelected
                                                ? selectedItemStyle ??
                                                config
                                                    .selectedItemStyle
                                                : itemStyle ??
                                                config.itemStyle)
                                                ?.copyWith(
                                              color:
                                              effectiveHighlightColor
                                                  .withOpacity(0.9),
                                            ) ??
                                                TextStyle(
                                                  color: effectiveHighlightColor
                                                      .withOpacity(0.9),
                                                ),
                                            child: itemBuilder(item),
                                          ),
                                        ),
                                      ],
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
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class LiquidSwipeMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final swipeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    final effectiveHighlightColor = config.highlightColor;

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: swipeAnimation.value > 0.5 ? Colors.white : Colors.black,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor:
              swipeAnimation.value > 0.5
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey[200],
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.black))
                    .copyWith(
                  color:
                  swipeAnimation.value > 0.5
                      ? Colors.white
                      : Colors.black,
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  const Icon(Icons.close, size: 18),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: swipeAnimation.value > 0.5 ? Colors.white : Colors.black,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: swipeAnimation.value > 0.5 ? Colors.white : Colors.black,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: swipeAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: LiquidSwipePainter(
                  progress: swipeAnimation.value,
                  color: effectiveHighlightColor,
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
                  color: Colors.white,
                  borderRadius: config.borderRadius,
                  boxShadow: shadows ?? config.shadows,
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: swipeAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: config.borderRadius,
                          child: SizedBox(
                            height: config.selectorHeight,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: swipeAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      effectiveHighlightColor.withOpacity(0.8),
                                      effectiveHighlightColor.withOpacity(0.5),
                                    ],
                                  ),
                                ),
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
                          Expanded(child: buildDisplayValue()),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                            child:
                            icon ??
                                Icon(
                                  Icons.arrow_drop_down,
                                  color:
                                  swipeAnimation.value > 0.5
                                      ? Colors.white
                                      : effectiveHighlightColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: swipeAnimation,
              builder: (context, child) {
                return Transform(
                  transform:
                  Matrix4.identity()
                    ..translate(0.0, 20 * (1 - swipeAnimation.value), 0.0),
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Material(
                        elevation: elevation ?? config.elevation,
                        borderRadius: config.dropdownBorderRadius,
                        child: ClipRRect(
                          borderRadius: config.dropdownBorderRadius,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                              maxDropdownHeight ?? config.maxDropdownHeight,
                            ),
                            width: dropdownWidth ?? config.dropdownWidth,
                            color:
                            dropdownBackgroundColor ??
                                config.backgroundColor,
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

                                      return Transform(
                                        transform:
                                        Matrix4.identity()..translate(
                                          0.0,
                                          10 * (1 - itemAnim.value),
                                          0.0,
                                        ),
                                        child: FadeTransition(
                                          opacity: itemAnim,
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
                                            splashColor: effectiveHighlightColor
                                                .withOpacity(0.2),
                                            highlightColor:
                                            effectiveHighlightColor
                                                .withOpacity(0.1),
                                            child: Container(
                                              padding:
                                              itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                index < items.length - 1 &&
                                                    showDivider
                                                    ? Border(
                                                  bottom: BorderSide(
                                                    color:
                                                    dividerColor ??
                                                        config
                                                            .dividerColor,
                                                    width:
                                                    dividerThickness ??
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
                                                    child: DefaultTextStyle.merge(
                                                      style:
                                                      isSelected
                                                          ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                          : itemStyle ??
                                                          config
                                                              .itemStyle,
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
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class CyberpunkMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final glitchAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final heightAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    final color = config.highlightColor ?? Colors.pink;
    const neonBlue = Colors.cyanAccent;
    final textGlow = <Shadow>[
      Shadow(color: color, blurRadius: 10),
      Shadow(color: neonBlue, blurRadius: 5),
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white,
              shadows: textGlow,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.black.withOpacity(0.7),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(shadows: textGlow),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(4),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(
                    Icons.close,
                    size: 18,
                    color: color,
                    shadows: textGlow,
                  ),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white,
            shadows: textGlow,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white,
            shadows: textGlow,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        // Glitch effect background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: glitchAnimation,
            builder: (context, child) {
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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: config.borderRadius,
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: neonBlue.withOpacity(0.3),
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
                      Expanded(child: buildDisplayValue()),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeInOutBack,
                          ),
                        ),
                        child:
                        icon ??
                            Icon(
                              Icons.arrow_drop_down,
                              color: color,
                              shadows: textGlow,
                            ),
                      ),
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
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color: neonBlue.withOpacity(0.3),
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
                                    builder: (context, child) {
                                      final opacity = itemAnim.value.clamp(
                                        0.0,
                                        1.0,
                                      );
                                      final glitchOffset =
                                          sin(itemAnim.value * 20) * 2;
                                      return Transform(
                                        transform:
                                        Matrix4.identity()..translate(
                                          glitchOffset,
                                          0.0,
                                          0.0,
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
                                            splashColor: color.withOpacity(0.3),
                                            highlightColor: neonBlue
                                                .withOpacity(0.1),
                                            child: Container(
                                              padding:
                                              itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                index < items.length - 1 &&
                                                    showDivider
                                                    ? Border(
                                                  bottom: BorderSide(
                                                    color: neonBlue
                                                        .withOpacity(
                                                      0.1,
                                                    ),
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
                                                    child: DefaultTextStyle.merge(
                                                      style:
                                                      (isSelected
                                                          ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                          : itemStyle ??
                                                          config
                                                              .itemStyle)
                                                          ?.copyWith(
                                                        color:
                                                        Colors
                                                            .white,
                                                        shadows:
                                                        isSelected
                                                            ? textGlow
                                                            : null,
                                                      ) ??
                                                          TextStyle(
                                                            color: Colors.white,
                                                            shadows:
                                                            isSelected
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class MorphingGlassMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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

    final heightAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.95, curve: Curves.elasticOut),
      ),
    );

    final accentColor = config.highlightColor ?? Theme.of(context).primaryColor;
    final gradientColors = [
      accentColor.withOpacity(0.15),
      accentColor.withOpacity(0.05),
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.white.withOpacity(0.1),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(color: Colors.white.withOpacity(0.9)),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(16),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.white.withOpacity(0.8),
                  ),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        AnimatedBuilder(
          animation: morphAnim,
          builder: (context, child) {
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
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                        Expanded(child: buildDisplayValue()),
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: controller.value * pi / 2,
                              child:
                              icon ??
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.8),
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
                        maxHeight:
                        maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            gradientColors[0].withOpacity(0.3),
                            gradientColors[1].withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
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
                                      transform:
                                      Matrix4.identity()..translate(
                                        0.0,
                                        20 * (1 - itemAnim.value),
                                        0.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          onChanged(item);
                                          if (config.selectionMode ==
                                              SelectionMode.single) {
                                            onToggle();
                                          }
                                        },
                                        splashColor: Colors.white.withOpacity(
                                          0.1,
                                        ),
                                        highlightColor: Colors.white
                                            .withOpacity(0.05),
                                        child: Container(
                                          padding:
                                          itemPadding ?? config.itemPadding,
                                          decoration: BoxDecoration(
                                            border:
                                            index < items.length - 1 &&
                                                showDivider
                                                ? Border(
                                              bottom: BorderSide(
                                                color: Colors.white
                                                    .withOpacity(0.08),
                                              ),
                                            )
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              if (config.selectionMode ==
                                                  SelectionMode.multiple ||
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
                                                child: DefaultTextStyle.merge(
                                                  style:
                                                  (isSelected
                                                      ? selectedItemStyle ??
                                                      config
                                                          .selectedItemStyle
                                                      : itemStyle ??
                                                      config
                                                          .itemStyle)
                                                      ?.copyWith(
                                                    color: Colors.white
                                                        .withOpacity(
                                                      0.9,
                                                    ),
                                                  ) ??
                                                      TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class HologramMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final hologramAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    final effectiveHighlightColor = config.highlightColor ?? Colors.cyanAccent;
    final hologramColors = [
      effectiveHighlightColor.withOpacity(0.8),
      effectiveHighlightColor.withOpacity(0.3),
      Colors.transparent,
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white,
              shadows: [Shadow(color: effectiveHighlightColor, blurRadius: 10)],
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.black.withOpacity(0.7),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(
                  shadows: [
                    Shadow(
                      color: effectiveHighlightColor,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(4),
                side: BorderSide(
                  color: effectiveHighlightColor.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(Icons.close, color: effectiveHighlightColor),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(color: effectiveHighlightColor, blurRadius: 10),
            ],
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(color: effectiveHighlightColor, blurRadius: 10),
            ],
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        // Hologram scan lines background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: hologramAnim,
            builder: (context, child) {
              return CustomPaint(
                painter: HologramPainter(
                  progress: hologramAnim.value,
                  colors: hologramColors,
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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: config.borderRadius,
                  border: Border.all(
                    color: effectiveHighlightColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: shadows ?? config.shadows,
                ),
                child: Padding(
                  padding: padding ?? config.padding,
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: effectiveHighlightColor,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: config.leadingIcon!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: buildDisplayValue()),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeInOutBack,
                          ),
                        ),
                        child:
                        icon ??
                            Icon(
                              Icons.expand_more_rounded,
                              color: effectiveHighlightColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: hologramAnim,
              builder: (context, child) {
                return Transform(
                  transform:
                  Matrix4.identity()
                    ..translate(0.0, 20 * (1 - hologramAnim.value), 0.0)
                    ..scale(1.0, hologramAnim.value),
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Material(
                        elevation: elevation ?? config.elevation,
                        borderRadius: config.dropdownBorderRadius,
                        child: ClipRRect(
                          borderRadius: config.dropdownBorderRadius,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: dropdownWidth ?? config.dropdownWidth,
                              constraints: BoxConstraints(
                                maxHeight:
                                maxDropdownHeight ??
                                    config.maxDropdownHeight,
                              ),
                              decoration: BoxDecoration(
                                color:
                                dropdownBackgroundColor ??
                                    Colors.black.withOpacity(0.5),
                                border: Border.all(
                                  color: effectiveHighlightColor.withOpacity(
                                    0.3,
                                  ),
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
                                          final isSelected = isItemSelected(
                                            item,
                                          );
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
                                              transform:
                                              Matrix4.identity()..translate(
                                                0.0,
                                                10 * (1 - itemAnim.value),
                                                0.0,
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (config
                                                        .enableHapticFeedback) {
                                                      HapticFeedback.lightImpact();
                                                    }
                                                    onChanged(item);
                                                    if (config.selectionMode ==
                                                        SelectionMode.single) {
                                                      onToggle();
                                                    }
                                                  },
                                                  splashColor:
                                                  effectiveHighlightColor
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                  effectiveHighlightColor
                                                      .withOpacity(0.1),
                                                  child: Container(
                                                    padding:
                                                    itemPadding ??
                                                        config.itemPadding,
                                                    decoration: BoxDecoration(
                                                      border:
                                                      index <
                                                          items.length -
                                                              1 &&
                                                          showDivider
                                                          ? Border(
                                                        bottom: BorderSide(
                                                          color:
                                                          dividerColor ??
                                                              effectiveHighlightColor
                                                                  .withOpacity(
                                                                0.1,
                                                              ),
                                                          width:
                                                          dividerThickness ??
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
                                                          child: DefaultTextStyle.merge(
                                                            style:
                                                            (isSelected
                                                                ? selectedItemStyle ??
                                                                config.selectedItemStyle
                                                                : itemStyle ??
                                                                config.itemStyle)
                                                                ?.copyWith(
                                                              color:
                                                              Colors
                                                                  .white,
                                                            ) ??
                                                                TextStyle(
                                                                  color:
                                                                  Colors
                                                                      .white,
                                                                ),
                                                            child: itemBuilder(
                                                              item,
                                                            ),
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
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class LiquidMetalMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final metalAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve));

    final opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    final effectiveHighlightColor = config.highlightColor ?? Colors.blueGrey;
    final metalGradient = LinearGradient(
      colors: [
        effectiveHighlightColor,
        effectiveHighlightColor.withOpacity(0.8),
        Colors.white.withOpacity(0.9),
        effectiveHighlightColor.withOpacity(0.8),
        effectiveHighlightColor,
      ],
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2),
              ],
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: effectiveHighlightColor.withOpacity(0.7),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(Icons.close, color: Colors.white),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2),
            ],
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2),
            ],
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Column(
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
              gradient: metalGradient,
              borderRadius: config.borderRadius,
              boxShadow: shadows ?? config.shadows,
            ),
            child: Padding(
              padding: padding ?? config.padding,
              child: Row(
                children: [
                  if (config.leadingIcon != null) ...[
                    config.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: buildDisplayValue()),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                    child:
                    icon ??
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: metalAnim,
          builder: (context, child) {
            return Transform(
              transform:
              Matrix4.identity()
                ..translate(0.0, 20 * (1 - metalAnim.value), 0.0),
              child: Opacity(
                opacity: opacityAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Material(
                    elevation: elevation ?? config.elevation,
                    borderRadius: config.dropdownBorderRadius,
                    child: ClipRRect(
                      borderRadius: config.dropdownBorderRadius,
                      child: Container(
                        width: dropdownWidth ?? config.dropdownWidth,
                        constraints: BoxConstraints(
                          maxHeight:
                          maxDropdownHeight ?? config.maxDropdownHeight,
                        ),
                        decoration: BoxDecoration(
                          gradient: metalGradient,
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
                                          delay + 0.3,
                                          curve: Curves.easeOutBack,
                                        ),
                                      ),
                                    );

                                    return Transform(
                                      transform:
                                      Matrix4.identity()..translate(
                                        0.0,
                                        10 * (1 - itemAnim.value),
                                        0.0,
                                      ),
                                      child: FadeTransition(
                                        opacity: itemAnim,
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
                                            splashColor: Colors.white
                                                .withOpacity(0.2),
                                            highlightColor: Colors.white
                                                .withOpacity(0.1),
                                            child: Container(
                                              padding:
                                              itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                index < items.length - 1 &&
                                                    showDivider
                                                    ? Border(
                                                  bottom: BorderSide(
                                                    color:
                                                    dividerColor ??
                                                        Colors.white
                                                            .withOpacity(
                                                          0.2,
                                                        ),
                                                    width:
                                                    dividerThickness ??
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
                                                    child: DefaultTextStyle.merge(
                                                      style:
                                                      (isSelected
                                                          ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                          : itemStyle ??
                                                          config
                                                              .itemStyle)
                                                          ?.copyWith(
                                                        color:
                                                        Colors
                                                            .white,
                                                      ) ??
                                                          TextStyle(
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
            );
          },
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class GradientWaveMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final waveAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final heightAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    final effectiveHighlightColor =
        config.highlightColor ?? Theme.of(context).primaryColor;
    final colors = [
      effectiveHighlightColor,
      Colors.deepPurpleAccent,
      Colors.blueAccent,
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: colors[0].withOpacity(0.3),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(color: Colors.white),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(Icons.close, color: Colors.white.withOpacity(0.9)),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: waveAnim,
            builder: (context, child) {
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
                        color: colors[0].withOpacity(0.4),
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
                      Expanded(child: buildDisplayValue()),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeInOutBack,
                          ),
                        ),
                        child:
                        icon ??
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            ),
                      ),
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
                              colors[0].withOpacity(0.3),
                              colors[1].withOpacity(0.2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
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
                                        Matrix4.identity()..translate(
                                          0.0,
                                          20 * (1 - itemAnim.value),
                                          0.0,
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
                                            splashColor: colors[0].withOpacity(
                                              0.2,
                                            ),
                                            highlightColor: colors[1]
                                                .withOpacity(0.1),
                                            child: Container(
                                              padding:
                                              itemPadding ??
                                                  config.itemPadding,
                                              decoration: BoxDecoration(
                                                border:
                                                index < items.length - 1 &&
                                                    showDivider
                                                    ? Border(
                                                  bottom: BorderSide(
                                                    color:
                                                    dividerColor ??
                                                        Colors.white
                                                            .withOpacity(
                                                          0.1,
                                                        ),
                                                    width:
                                                    dividerThickness ??
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
                                                    child: DefaultTextStyle.merge(
                                                      style:
                                                      (isSelected
                                                          ? selectedItemStyle ??
                                                          config
                                                              .selectedItemStyle
                                                          : itemStyle ??
                                                          config
                                                              .itemStyle)
                                                          ?.copyWith(
                                                        color:
                                                        Colors
                                                            .white,
                                                      ) ??
                                                          const TextStyle(
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class CyberNeonMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final gridAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    final effectiveHighlightColor = config.highlightColor ?? Colors.pinkAccent;
    const neonBlue = Colors.cyanAccent;
    final textGlow = [
      Shadow(color: effectiveHighlightColor, blurRadius: 10),
      Shadow(color: neonBlue, blurRadius: 5),
    ];

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: textGlow,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: Colors.black.withOpacity(0.7),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(
                  color: effectiveHighlightColor,
                  shadows: textGlow,
                ),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: effectiveHighlightColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(
                    Icons.close,
                    color: effectiveHighlightColor,
                    shadows: textGlow,
                  ),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            shadows: textGlow,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            shadows: textGlow,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        AnimatedBuilder(
          animation: gridAnim,
          builder: (context, child) {
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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: config.borderRadius,
                  border: Border.all(
                    color: effectiveHighlightColor.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveHighlightColor.withOpacity(0.3),
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
                    Expanded(child: buildDisplayValue()),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeInOutBack,
                        ),
                      ),
                      child:
                      icon ??
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: effectiveHighlightColor,
                            shadows: textGlow,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen)
              AnimatedBuilder(
                animation: gridAnim,
                builder: (context, child) {
                  return ClipPath(
                    clipper: CyberClipper(progress: gridAnim.value),
                    child: Transform(
                      transform:
                      Matrix4.identity()
                        ..translate(0.0, 20 * (1 - gridAnim.value), 0.0),
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
                              color:
                              dropdownBackgroundColor ??
                                  Colors.black.withOpacity(0.8),
                              border: Border.all(
                                color: effectiveHighlightColor.withOpacity(0.3),
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
                                            transform:
                                            Matrix4.identity()..translate(
                                              0.0,
                                              15 * (1 - itemAnim.value),
                                              0.0,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  if (config
                                                      .enableHapticFeedback) {
                                                    HapticFeedback.lightImpact();
                                                  }
                                                  onChanged(item);
                                                  if (config.selectionMode ==
                                                      SelectionMode.single) {
                                                    onToggle();
                                                  }
                                                },
                                                splashColor:
                                                effectiveHighlightColor
                                                    .withOpacity(0.2),
                                                highlightColor: neonBlue
                                                    .withOpacity(0.1),
                                                child: Container(
                                                  padding:
                                                  itemPadding ??
                                                      config.itemPadding,
                                                  decoration: BoxDecoration(
                                                    border:
                                                    index <
                                                        items.length -
                                                            1 &&
                                                        showDivider
                                                        ? Border(
                                                      bottom: BorderSide(
                                                        color:
                                                        dividerColor ??
                                                            effectiveHighlightColor
                                                                .withOpacity(
                                                              0.1,
                                                            ),
                                                        width:
                                                        dividerThickness ??
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
                                                        child: DefaultTextStyle.merge(
                                                          style:
                                                          (isSelected
                                                              ? selectedItemStyle ??
                                                              config
                                                                  .selectedItemStyle
                                                              : itemStyle ??
                                                              config
                                                                  .itemStyle)
                                                              ?.copyWith(
                                                            color:
                                                            Colors
                                                                .white,
                                                            shadows:
                                                            isSelected
                                                                ? textGlow
                                                                : null,
                                                          ) ??
                                                              TextStyle(
                                                                color:
                                                                Colors
                                                                    .white,
                                                                shadows:
                                                                isSelected
                                                                    ? textGlow
                                                                    : null,
                                                              ),
                                                          child: itemBuilder(
                                                            item,
                                                          ),
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class FloatingGlassMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final floatAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    final effectiveHighlightColor =
        config.highlightColor ?? Theme.of(context).primaryColor;
    final glassColor = effectiveHighlightColor.withOpacity(0.15);

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white.withOpacity(0.95),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: glassColor,
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(color: Colors.white.withOpacity(0.95)),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(Icons.close, color: Colors.white.withOpacity(0.8)),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        // Floating background effect
        Positioned.fill(
          child: AnimatedBuilder(
            animation: floatAnim,
            builder: (context, child) {
              return Transform(
                transform:
                Matrix4.identity()
                  ..translate(0.0, 15 * (1 - floatAnim.value))
                  ..scale(1.0, floatAnim.value),
                child: Opacity(
                  opacity: floatAnim.value * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          glassColor.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        radius: 2.0,
                        center: Alignment.topCenter,
                        stops: const [0.1, 0.9],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating glass selector
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
                  duration: const Duration(milliseconds: 500),
                  constraints: BoxConstraints(
                    minHeight: config.selectorHeight,
                    minWidth: dropdownWidth ?? config.selectorWidth,
                  ),
                  padding: padding ?? config.padding,
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: config.borderRadius,
                    border: Border.all(
                      color: Colors.white.withOpacity(isOpen ? 0.5 : 0.3),
                      width: isOpen ? 2.0 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: effectiveHighlightColor.withOpacity(
                          isOpen ? 0.2 : 0.1,
                        ),
                        blurRadius: isOpen ? 40 : 30,
                        spreadRadius: isOpen ? 3 : 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (config.leadingIcon != null) ...[
                        config.leadingIcon!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(child: buildDisplayValue()),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        child:
                        icon ??
                            Icon(
                              Icons.expand_more_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 28,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizeTransition(
              axisAlignment: -1.0,
              sizeFactor: floatAnim,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: config.dropdownBorderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20 * floatAnim.value,
                      sigmaY: 20 * floatAnim.value,
                    ),
                    child: Container(
                      width: dropdownWidth ?? config.dropdownWidth,
                      constraints: BoxConstraints(
                        maxHeight:
                        maxDropdownHeight ?? config.maxDropdownHeight,
                      ),
                      decoration: BoxDecoration(
                        color: glassColor.withOpacity(0.7 * floatAnim.value),
                        border: Border.all(
                          color: Colors.white.withOpacity(
                            0.3 * floatAnim.value,
                          ),
                          width: 1,
                        ),
                        borderRadius: config.dropdownBorderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: effectiveHighlightColor.withOpacity(
                              0.2 * floatAnim.value,
                            ),
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
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: itemAnim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.2),
                                        end: Offset.zero,
                                      ).animate(itemAnim),
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
                                          splashColor: Colors.white.withOpacity(
                                            0.15,
                                          ),
                                          highlightColor: Colors.white
                                              .withOpacity(0.08),
                                          child: Container(
                                            padding:
                                            itemPadding ??
                                                config.itemPadding,
                                            decoration: BoxDecoration(
                                              border:
                                              index < items.length - 1 &&
                                                  showDivider
                                                  ? Border(
                                                bottom: BorderSide(
                                                  color:
                                                  dividerColor ??
                                                      Colors.white
                                                          .withOpacity(
                                                        0.1,
                                                      ),
                                                  width:
                                                  dividerThickness ??
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
                                                  child: DefaultTextStyle.merge(
                                                    style:
                                                    (isSelected
                                                        ? selectedItemStyle ??
                                                        config
                                                            .selectedItemStyle
                                                        : itemStyle ??
                                                        config
                                                            .itemStyle)
                                                        ?.copyWith(
                                                      color: Colors
                                                          .white
                                                          .withOpacity(
                                                        0.95,
                                                      ),
                                                    ) ??
                                                        TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(
                                                            0.95,
                                                          ),
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

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}

class LiquidSmoothMultiDropdownStrategy<T>
    implements MultiDropdownAnimationStrategy<T> {
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
    final effectiveHighlightColor =
        config.highlightColor ?? Theme.of(context).primaryColor;
    final dropdownAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    Widget buildDisplayValue() {
      if (config.selectionMode == SelectionMode.multiple) {
        final selectedItems = value is List<T> ? value : [];
        if (selectedItems.isEmpty) {
          return DefaultTextStyle.merge(
            style: (hintStyle ?? config.hintStyle)?.copyWith(
              color: Colors.white.withOpacity(0.95),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: hint ?? const Text('Select...'),
          );
        }
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children:
          selectedItems.map((item) {
            return Chip(
              padding: config.chipPadding,
              backgroundColor: effectiveHighlightColor.withOpacity(0.15),
              label: DefaultTextStyle.merge(
                style: (config.chipLabelStyle ??
                    const TextStyle(color: Colors.white))
                    .copyWith(color: Colors.white.withOpacity(0.95)),
                child: itemBuilder(item),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                config.chipBorderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              deleteIcon:
              config.chipDeleteIcon ??
                  Icon(Icons.close, color: Colors.white.withOpacity(0.9)),
              onDeleted: () {
                onChanged(item);
                if (config.enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
              },
            );
          }).toList(),
        );
      } else {
        return value != null
            ? DefaultTextStyle.merge(
          style: (selectedItemStyle ?? config.selectedItemStyle)?.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: itemBuilder(value as T),
        )
            : DefaultTextStyle.merge(
          style: (hintStyle ?? config.hintStyle)?.copyWith(
            color: Colors.white.withOpacity(0.95),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: hint ?? const Text('Select...'),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
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
                    color: effectiveHighlightColor.withOpacity(
                      isOpen ? 0.15 : 0.1,
                    ),
                    borderRadius: config.borderRadius,
                    border: Border.all(
                      color: Colors.white.withOpacity(isOpen ? 0.4 : 0.2),
                      width: isOpen ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: effectiveHighlightColor.withOpacity(
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
                            color: Colors.white.withOpacity(0.9),
                            size: 24,
                          ),
                          child: config.leadingIcon!,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(child: buildDisplayValue()),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child:
                        icon ??
                            Icon(
                              Icons.expand_more_rounded,
                              color: Colors.white.withOpacity(0.9),
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
                builder: (context, child) {
                  final progress = dropdownAnim.value.clamp(0.0, 1.0);
                  return ClipPath(
                    clipper: FluidDropdownClipper(
                      progress: progress,
                      isOpen: isOpen,
                    ),
                    child: Transform(
                      transform:
                      Matrix4.identity()
                        ..translate(0.0, 30 * (1 - progress), 0.0),
                      child: Opacity(
                        opacity: progress,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: dropdownWidth ?? config.dropdownWidth,
                            constraints: BoxConstraints(
                              maxHeight:
                              maxDropdownHeight ?? config.maxDropdownHeight,
                            ),
                            decoration: BoxDecoration(
                              color: effectiveHighlightColor.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(progress * 0.3),
                                width: 1,
                              ),
                              borderRadius: config.dropdownBorderRadius,
                              boxShadow: [
                                BoxShadow(
                                  color: effectiveHighlightColor.withOpacity(
                                    0.2 * progress,
                                  ),
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
                                          builder: (context, child) {
                                            final itemProgress = itemAnim.value
                                                .clamp(0.0, 1.0);
                                            return Transform(
                                              transform:
                                              Matrix4.identity()
                                                ..translate(
                                                  0.0,
                                                  20 * (1 - itemProgress),
                                                  0.0,
                                                )
                                                ..scale(1.0, itemProgress),
                                              child: Opacity(
                                                opacity: itemProgress,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                if (config
                                                    .enableHapticFeedback) {
                                                  HapticFeedback.lightImpact();
                                                }
                                                onChanged(item);
                                                if (config.selectionMode ==
                                                    SelectionMode.single) {
                                                  onToggle();
                                                }
                                              },
                                              splashColor: Colors.white
                                                  .withOpacity(0.15),
                                              highlightColor: Colors.white
                                                  .withOpacity(0.08),
                                              child: Container(
                                                padding:
                                                itemPadding ??
                                                    config.itemPadding,
                                                decoration: BoxDecoration(
                                                  border:
                                                  index <
                                                      items.length -
                                                          1 &&
                                                      showDivider
                                                      ? Border(
                                                    bottom: BorderSide(
                                                      color:
                                                      dividerColor ??
                                                          Colors.white
                                                              .withOpacity(
                                                            0.15,
                                                          ),
                                                      width:
                                                      dividerThickness ??
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
                                                      child: DefaultTextStyle.merge(
                                                        style:
                                                        (isSelected
                                                            ? selectedItemStyle ??
                                                            config
                                                                .selectedItemStyle
                                                            : itemStyle ??
                                                            config
                                                                .itemStyle)
                                                            ?.copyWith(
                                                          color: Colors
                                                              .white
                                                              .withOpacity(
                                                            0.95,
                                                          ),
                                                        ) ??
                                                            TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                0.95,
                                                              ),
                                                            ),
                                                        child: itemBuilder(
                                                          item,
                                                        ),
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
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  @override
  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  }) {
    if (isOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}
