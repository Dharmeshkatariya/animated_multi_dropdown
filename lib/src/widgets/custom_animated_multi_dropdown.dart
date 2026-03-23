import 'package:animated_multi_dropdown/src/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/dropdown_animation_type.dart';
import '../models/multi_dropdown_config.dart';
import '../models/selection_mode.dart';
import '../strategies/multi_dropdown_animation_strategy.dart';


class CustomAnimatedMultiDropDown<T> extends StatefulWidget {
  final DropdownAnimationType animationType;
  final List<T> items;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final Widget Function(T item) itemBuilder;
  final Widget? hint;
  final Widget? icon;
  final MultiDropDownConfig config;
  final bool showDivider;
  final Color dividerColor;
  final double dividerThickness;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final TextStyle hintStyle;
  final TextStyle selectedItemStyle;
  final TextStyle itemStyle;
  final Color? dropdownBackgroundColor;
  final BoxShadow? shadow;
  final List<BoxShadow> shadows;
  final double elevation;
  final bool showCheckmark;
  final Widget? customCheckmark;
  final double? maxDropdownHeight;
  final double? dropdownWidth;
  final bool Function(T, T)? compareFn;
  final Widget Function(T)? chipBuilder;

  const CustomAnimatedMultiDropDown({
    super.key,
    required this.animationType,
    required this.items,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.hint,
    this.icon,
    this.config = const MultiDropDownConfig(),
    this.showDivider = true,
    this.dividerColor = Colors.white,
    this.dividerThickness = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.itemPadding = const EdgeInsets.all(16),
    this.hintStyle = const TextStyle(color: Colors.black, fontSize: 14),
    this.selectedItemStyle = const TextStyle(color: Colors.black, fontSize: 14),
    this.itemStyle = const TextStyle(color: Colors.black, fontSize: 14),
    this.dropdownBackgroundColor,
    this.shadow,
    this.shadows = const [
      BoxShadow(
        color: Colors.black54,
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.elevation = 8.0,
    this.showCheckmark = true,
    this.customCheckmark,
    this.maxDropdownHeight,
    this.dropdownWidth,
    this.compareFn,
    this.chipBuilder,
  });

  @override
  _CustomAnimatedMultiDropDownState<T> createState() =>
      _CustomAnimatedMultiDropDownState<T>();
}

class _CustomAnimatedMultiDropDownState<T>
    extends State<CustomAnimatedMultiDropDown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late MultiDropdownAnimationStrategy<T> _strategy;
  final ValueNotifier<bool> _isOpen = ValueNotifier<bool>(false);
  final ValueNotifier<dynamic> _selectedValue = ValueNotifier<dynamic>(null);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.duration,
      reverseDuration: widget.config.reverseDuration,
    );

    _strategy = createDropdownStrategy<T>(
      widget.animationType,
      widget.config,
      _controller,
      widget.itemBuilder,
      widget.items,
      widget.value,
      _handleValueChanged,
      _handleToggle,
    );

    _selectedValue.value = widget.value;
    _filteredItems = widget.items;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(CustomAnimatedMultiDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue.value = widget.value;
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        final itemText = widget.itemBuilder(item).toString().toLowerCase();
        return itemText.contains(query);
      }).toList();
    });
  }

  void _handleValueChanged(dynamic newValue) {
    _selectedValue.value = newValue;
    widget.onChanged?.call(newValue);
  }

  void _handleToggle() {
    _isOpen.value = !_isOpen.value;
    _strategy.toggleDropdown(controller: _controller, isOpen: _isOpen.value);

    if (!_isOpen.value) {
      _searchController.clear();
      _searchFocusNode.unfocus();
    }
  }

  void _handleItemSelection(T item) {
    if (widget.config.selectionMode == SelectionMode.multiple) {
      final currentSelection = _selectedValue.value is List<T>
          ? List<T>.from(_selectedValue.value as List<T>)
          : <T>[];

      final compareFn = widget.compareFn ?? (T a, T b) => a == b;
      final index = currentSelection.indexWhere((i) => compareFn(i, item));

      if (index >= 0) {
        currentSelection.removeAt(index);
      } else {
        currentSelection.add(item);
      }

      _handleValueChanged(currentSelection);
    } else {
      _handleValueChanged(item);
      _handleToggle();
    }
  }

  // bool _isItemSelected(T item) {
  //   if (widget.config.selectionMode == SelectionMode.multiple) {
  //     final currentSelection = _selectedValue.value is List<T>
  //         ? _selectedValue.value as List<T>
  //         : [];
  //     final compareFn = widget.compareFn ?? (T a, T b) => a == b;
  //     return currentSelection.any((i) => compareFn(i, item));
  //   } else {
  //     return widget.compareFn?.call(_selectedValue.value as T, item) ??
  //         _selectedValue.value == item;
  //   }
  // }

  bool _isItemSelected(T item) {
    if (widget.config.selectionMode == SelectionMode.multiple) {
      final currentSelection = _selectedValue.value is List<T>
          ? _selectedValue.value as List<T>
          : <T>[];
      final compareFn = widget.compareFn ?? (T a, T b) => a == b;
      return currentSelection.any((i) => compareFn(i, item));
    } else {
      // Fix the type cast issue here
      final currentValue = _selectedValue.value;
      if (currentValue == null) return false;
      if (widget.compareFn != null) {
        return widget.compareFn!(currentValue as T, item);
      }
      return currentValue == item;
    }
  }

  Widget _buildSelectionIndicator(bool isSelected, MultiDropDownConfig config) {
    if (config.customIndicator != null) {
      return config.customIndicator!;
    }

    return IndicatorWidget(
      isSelected: isSelected,
      isEnabled: true,
      config: IndicatorConfig(
        type: config.selectedIndicator,
        activeColor: config.indicatorActiveColor,
        inactiveColor: config.indicatorInactiveColor,
        size: config.indicatorSize,
        borderRadius: config.borderRadius,
      ),
    );
  }

  Widget _buildSelectedItemsChips() {
    if (widget.config.selectionMode != SelectionMode.multiple ||
        !widget.config.showSelectedItemsAsChips) {
      return const SizedBox.shrink();
    }

    final selectedItems = _selectedValue.value is List<T>
        ? _selectedValue.value as List<T>
        : [];

    if (selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: widget.config.chipSpacing,
        runSpacing: widget.config.chipRunSpacing,
        children: selectedItems.map((item) {
          return widget.chipBuilder != null
              ? widget.chipBuilder!(item)
              : Chip(
            padding: widget.config.chipPadding,
            backgroundColor: widget.config.chipColor ?? Colors.grey[200],
            label: DefaultTextStyle.merge(
              style: widget.config.chipLabelStyle ??
                  const TextStyle(color: Colors.black),
              child: widget.itemBuilder(item),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: widget.config.chipBorderRadius ??
                  BorderRadius.circular(8),
            ),
            deleteIcon: widget.config.chipDeleteIcon ??
                const Icon(Icons.close, size: 18),
            onDeleted: () {
              _handleItemSelection(item);
              if (widget.config.enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchField(MultiDropDownConfig config) {
    if (!config.enableSearch) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: config.searchTextStyle,
        cursorColor: config.searchCursorColor,
        decoration: InputDecoration(
          hintText: config.searchHintText,
          hintStyle: config.searchTextStyle.copyWith(
            color: config.searchDecorationColor,
          ),
          prefixIcon: Icon(Icons.search, color: config.searchDecorationColor),
          filled: true,
          fillColor: config.searchBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isOpen,
      builder: (context, isOpen, _) {
        return ValueListenableBuilder<dynamic>(
          valueListenable: _selectedValue,
          builder: (context, selectedValue, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _strategy.buildDropdown(
                  context: context,
                  items: _filteredItems,
                  value: selectedValue,
                  onChanged: _handleItemSelection,
                  itemBuilder: widget.itemBuilder,
                  hint: widget.hint,
                  icon: widget.icon,
                  controller: _controller,
                  isOpen: isOpen,
                  config: widget.config.copyWith(
                    maxDropdownHeight: widget.maxDropdownHeight,
                    dropdownWidth: widget.dropdownWidth,
                  ),
                  onToggle: _handleToggle,
                  showDivider: widget.showDivider,
                  dividerColor: widget.dividerColor,
                  dividerThickness: widget.dividerThickness,
                  padding: widget.padding,
                  itemPadding: widget.itemPadding,
                  hintStyle: widget.hintStyle,
                  selectedItemStyle: widget.selectedItemStyle,
                  itemStyle: widget.itemStyle,
                  dropdownBackgroundColor: widget.dropdownBackgroundColor,
                  shadow: widget.shadow,
                  shadows: widget.shadows,
                  elevation: widget.elevation,
                  showCheckmark: widget.showCheckmark,
                  customCheckmark: widget.customCheckmark,
                  dropdownWidth: widget.dropdownWidth,
                  isItemSelected: _isItemSelected,
                  buildSelectionIndicator: _buildSelectionIndicator,
                  buildSearchField: _buildSearchField,
                ),
                _buildSelectedItemsChips(),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isOpen.dispose();
    _selectedValue.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}


abstract class MultiDropdownAnimationStrategy<T> {
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
  });

  void toggleDropdown({
    required AnimationController controller,
    required bool isOpen,
  });
}

MultiDropdownAnimationStrategy<T> createDropdownStrategy<T>(
    DropdownAnimationType type,
    MultiDropDownConfig config,
    AnimationController controller,
    Widget Function(T item) itemBuilder,
    List<T> items,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    VoidCallback onToggle,
    ) {
  switch (type) {
    case DropdownAnimationType.glass:
      return MultiGlassDropdownStrategy<T>();
    case DropdownAnimationType.liquid:
      return MultiLiquidDropdownStrategy<T>();
    case DropdownAnimationType.neon:
      return MultiNeonDropdownStrategy<T>();
    case DropdownAnimationType.bouncy3d:
      return MultiBounce3DDropdownStrategy<T>();
    case DropdownAnimationType.floatingCard:
      return FloatingCardsMultiDropdownStrategy<T>();
    case DropdownAnimationType.morphing:
      return MorphingMultiDropdownStrategy<T>();
    case DropdownAnimationType.staggered:
      return StaggeredMultiDropdownStrategy<T>();
    case DropdownAnimationType.staggeredVerticalDropItem:
      return StaggeredVerticalMultiDropdownStrategy<T>();
    case DropdownAnimationType.foldable:
      return FoldableMultiDropdownStrategy<T>();
    case DropdownAnimationType.fluidWave:
      return FluidWaveMultiDropdownStrategy<T>();
    case DropdownAnimationType.holographicFan:
      return HolographicFanMultiDropdownStrategy<T>();
    case DropdownAnimationType.molecular:
      return MolecularMultiDropdownStrategy<T>();
    case DropdownAnimationType.cosmicRipple:
      return CosmicRippleMultiDropdownStrategy<T>();
    case DropdownAnimationType.gravityWell:
      return GravityWellMultiDropdownStrategy<T>();
    case DropdownAnimationType.neonPulse:
      return NeonPulseMultiDropdownStrategy<T>();
    case DropdownAnimationType.glassMorphism:
      return GlassMorphismMultiDropdownStrategy<T>();
    case DropdownAnimationType.liquidSwipe:
      return LiquidSwipeMultiDropdownStrategy<T>();
    case DropdownAnimationType.cyberpunk:
      return CyberpunkMultiDropdownStrategy<T>();
    case DropdownAnimationType.morphingGlass:
      return MorphingGlassMultiDropdownStrategy<T>();
    case DropdownAnimationType.hologram:
      return HologramMultiDropdownStrategy<T>();
    case DropdownAnimationType.liquidMetal:
      return LiquidMetalMultiDropdownStrategy<T>();
    case DropdownAnimationType.cyberNeon:
      return CyberNeonMultiDropdownStrategy<T>();
    case DropdownAnimationType.gradientWave:
      return GradientWaveMultiDropdownStrategy<T>();
    case DropdownAnimationType.floatingGlass:
      return FloatingGlassMultiDropdownStrategy<T>();
    case DropdownAnimationType.liquidSmooth:
      return LiquidSmoothMultiDropdownStrategy<T>();
  }
}
