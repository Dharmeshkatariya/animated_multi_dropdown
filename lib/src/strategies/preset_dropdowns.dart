import 'package:flutter/material.dart';
import '../../animated_multi_dropdown.dart';

/// Pre-configured dropdowns for common use cases
class PresetDropdowns {
  /// Primary action dropdown (blue theme)
  static Widget primarySingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.glass,
      highlightColor: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Success dropdown (green theme)
  static Widget successSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.liquid,
      highlightColor: Colors.green,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Warning dropdown (orange theme)
  static Widget warningSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.bouncy3d,
      highlightColor: Colors.orange,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Danger dropdown (red theme)
  static Widget dangerSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.neon,
      highlightColor: Colors.red,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Searchable dropdown with multiple selection
  static Widget searchableMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.multiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Search and select...',
      animationType: DropdownAnimationType.liquidSmooth,
      highlightColor: Colors.blue,
      enableSearch: true,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Compact dropdown (small height)
  static Widget compactSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select',
      animationType: DropdownAnimationType.glass,
      highlightColor: Colors.blue,
      height: 36,
      borderRadius: BorderRadius.circular(8),
    );
  }

  /// Large dropdown (big height)
  static Widget largeSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.liquid,
      highlightColor: Colors.purple,
      height: 56,
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Rounded dropdown (fully rounded corners)
  static Widget roundedSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select an option',
      animationType: DropdownAnimationType.glass,
      highlightColor: Colors.teal,
      borderRadius: BorderRadius.circular(30),
      height: 50,
    );
  }

  /// Minimal dropdown (no checkmark)
  static Widget minimalSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.single(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      hintText: hintText ?? 'Select',
      animationType: DropdownAnimationType.staggered,
      highlightColor: Colors.grey,
      borderRadius: BorderRadius.circular(8),
      showCheckmark: false,
    );
  }

  /// Cyberpunk themed dropdown
  static Widget cyberpunkSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.styledSingle(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      style: SimpleDropdownStyle.cyberpunk(
        highlightColor: Colors.cyanAccent,
        height: 48,
        width: double.infinity,
      ),
    );
  }

  /// Neon themed dropdown
  static Widget neonSingle<T>({
    required List<T> items,
    T? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.styledSingle(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      style: SimpleDropdownStyle.neon(
        highlightColor: Colors.pinkAccent,
        height: 48,
        width: double.infinity,
      ),
    );
  }

  /// Glass themed dropdown with multiple selection
  static Widget glassMultiple<T>({
    required List<T> items,
    List<T>? value,
    required void Function(dynamic) onChanged,
    required Widget Function(T) itemBuilder,
    String? hintText,
  }) {
    return SimpleDropdownFactory.styledMultiple(
      items: items,
      value: value,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      style: SimpleDropdownStyle.glass(
        highlightColor: Colors.blue,
        backgroundColor: Colors.white,
        height: 48,
        width: double.infinity,
      ),
    );
  }
}
