import 'package:animated_multi_dropdown/src/strategies/strategy_factory.dart';
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
  final Widget? noDataWidget;
  final String? noDataMessage;

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
    this.noDataWidget,
    this.noDataMessage,
  });

  @override
  // ignore: library_private_types_in_public_api
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.duration,
      reverseDuration: widget.config.reverseDuration,
    );

    _strategy = StrategyFactory.create<T>(widget.animationType);

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
      _filterItems(_searchQuery);
    }
    // If animation type changes, recreate strategy
    if (widget.animationType != oldWidget.animationType) {
      _strategy = StrategyFactory.create<T>(widget.animationType);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    _searchQuery = query;
    _filterItems(query);
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredItems = widget.items.where((item) {
          final itemText = widget.itemBuilder(item).toString().toLowerCase();
          return itemText.contains(lowerQuery);
        }).toList();
      }
    });
  }

  void _handleValueChanged(dynamic newValue) {
    _selectedValue.value = newValue;
    widget.onChanged?.call(newValue);

    // Clear search when selection changes (optional)
    if (widget.config.selectionMode == SelectionMode.single) {
      _searchController.clear();
      _searchQuery = '';
      _filterItems('');
    }
  }

  void _handleToggle() {
    _isOpen.value = !_isOpen.value;
    _strategy.toggleDropdown(controller: _controller, isOpen: _isOpen.value);

    if (!_isOpen.value) {
      // Clear search when closing
      _searchController.clear();
      _searchQuery = '';
      _filterItems('');
      _searchFocusNode.unfocus();
    } else {
      // Focus search when opening if search is enabled
      if (widget.config.enableSearch) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _searchFocusNode.requestFocus();
        });
      }
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

  bool _isItemSelected(T item) {
    if (widget.config.selectionMode == SelectionMode.multiple) {
      final currentSelection = _selectedValue.value is List<T>
          ? _selectedValue.value as List<T>
          : <T>[];
      final compareFn = widget.compareFn ?? (T a, T b) => a == b;
      return currentSelection.any((i) => compareFn(i, item));
    } else {
      final currentValue = _selectedValue.value;
      if (currentValue == null) return false;
      if (widget.compareFn != null) {
        return widget.compareFn!(currentValue as T, item);
      }
      return currentValue == item;
    }
  }
  Widget _buildSelectionIndicator(bool isSelected, MultiDropDownConfig config) {
    // Check for custom indicator first
    if (config.customCheckmark != null) {
      return config.customCheckmark!;
    }

    // Use the indicator configuration from the config
    final indicatorConfig = config.indicatorConfig;

    // FIXED: Determine if this is a radio-style indicator based on the type, not selection mode
    final isRadioStyle = indicatorConfig.type.toString().contains('radio') ||
        indicatorConfig.type == IndicatorType.toggle ||
        indicatorConfig.type == IndicatorType.switchStyle ||
        indicatorConfig.type == IndicatorType.radioClassic ||
        indicatorConfig.type == IndicatorType.radioCheckmark ||
        indicatorConfig.type == IndicatorType.radioDot ||
        indicatorConfig.type == IndicatorType.radioSquare;

    final isCheckboxStyle = !isRadioStyle &&
        indicatorConfig.type != IndicatorType.toggle &&
        indicatorConfig.type != IndicatorType.switchStyle;

    // Create indicator configuration with proper flags based on type
    final configForIndicator = IndicatorConfig(
      type: indicatorConfig.type,
      activeColor: indicatorConfig.activeColor,
      inactiveColor: indicatorConfig.inactiveColor,
      gradientColors: indicatorConfig.gradientColors,
      size: indicatorConfig.size,
      borderRadius: indicatorConfig.borderRadius,
      borderWidth: indicatorConfig.borderWidth,
      showCheckmark: indicatorConfig.showCheckmark,
      showDot: indicatorConfig.showDot,
      dotSize: indicatorConfig.dotSize,
      isRadio: isRadioStyle,
      isCheckbox: isCheckboxStyle,
      animateChanges: indicatorConfig.animateChanges,
      customBuilder: indicatorConfig.customBuilder,
    );

    return IndicatorWidget(
      isSelected: isSelected,
      isEnabled: true,
      config: configForIndicator,
      isRadioGroup: isRadioStyle,
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
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: config.searchDecorationColor),
            onPressed: () {
              _searchController.clear();
              _filterItems('');
            },
          )
              : null,
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

  /// Builds the no data widget when no items match the search
  Widget _buildNoDataWidget() {
    // If custom widget is provided, use it
    if (widget.noDataWidget != null) {
      return widget.noDataWidget!;
    }

    // If custom message is provided, show it
    if (widget.noDataMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                widget.noDataMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Default no data widget
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
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
                  noDataBuilder: _buildNoDataWidget,
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


