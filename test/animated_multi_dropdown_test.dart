import 'package:animated_multi_dropdown/src/models/dropdown_animation_type.dart';
import 'package:animated_multi_dropdown/src/models/multi_dropdown_config.dart';
import 'package:animated_multi_dropdown/src/models/selection_mode.dart';
import 'package:animated_multi_dropdown/src/widgets/custom_animated_multi_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedMultiDropdown Widget Tests', () {
    testWidgets('Basic rendering', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.glass,
              items: const ['Item 1', 'Item 2', 'Item 3'],
              value: null,
              onChanged: (value) {},
              itemBuilder: (item) => Text(item),
              hint: const Text('Select an item'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomAnimatedMultiDropDown<String>), findsOneWidget);
    });

    testWidgets('Single selection works', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.glass,
              items: const ['Apple', 'Banana', 'Orange'],
              value: selectedValue,
              onChanged: (value) => selectedValue = value,
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'Banana');
    });

    testWidgets('Multiple selection works', (WidgetTester tester) async {
      List<String> selectedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.liquid,
              items: const ['Apple', 'Banana', 'Orange'],
              value: selectedValues,
              onChanged: (value) => selectedValues = value,
              itemBuilder: (item) => Text(item),
              config: const MultiDropDownConfig(
                selectionMode: SelectionMode.multiple,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apple'));
      await tester.pump();
      await tester.tap(find.text('Orange'));
      await tester.pump();

      expect(selectedValues.length, 2);
      expect(selectedValues.contains('Apple'), true);
      expect(selectedValues.contains('Orange'), true);
    });
  });
}