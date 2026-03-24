// This is a basic Flutter integration test for the animated multi dropdown widget.
//
// Since integration tests run in a full Flutter application, they can test
// the complete widget behavior including animations and user interactions.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Animated Multi Dropdown Integration Tests', () {
    testWidgets('Basic rendering test', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.glass,
              items: ['Apple', 'Banana', 'Orange'],
              value: null,
              onChanged: (value) {},
              itemBuilder: (item) => Text(item),
              hint: const Text('Select a fruit'),
            ),
          ),
        ),
      );

      // Verify widget is rendered
      expect(find.text('Select a fruit'), findsOneWidget);
      expect(find.byType(CustomAnimatedMultiDropDown<String>), findsOneWidget);
    });

    testWidgets('Dropdown opens and closes', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CustomAnimatedMultiDropDown<String>(
                  animationType: DropdownAnimationType.glass,
                  items: ['Apple', 'Banana', 'Orange'],
                  value: null,
                  onChanged: (value) {},
                  itemBuilder: (item) => Text(item),
                  hint: const Text('Select a fruit'),
                );
              },
            ),
          ),
        ),
      );

      // Find and tap the dropdown
      final dropdownFinder = find.byType(CustomAnimatedMultiDropDown<String>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Verify dropdown items appear
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Orange'), findsOneWidget);
    });

    testWidgets('Single selection works', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.glass,
              items: ['Apple', 'Banana', 'Orange'],
              value: selectedValue,
              onChanged: (value) {
                selectedValue = value;
              },
              itemBuilder: (item) => Text(item),
              hint: const Text('Select a fruit'),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();

      // Select an item
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // Verify selection changed
      expect(selectedValue, 'Apple');
    });

    testWidgets('Multiple selection works', (WidgetTester tester) async {
      List<String> selectedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.liquid,
              items: ['Apple', 'Banana', 'Orange'],
              value: selectedValues,
              onChanged: (value) {
                selectedValues = value;
              },
              itemBuilder: (item) => Text(item),
              hint: const Text('Select fruits'),
              config: const MultiDropDownConfig(
                selectionMode: SelectionMode.multiple,
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.text('Apple'));
      await tester.pump();

      // Select second item
      await tester.tap(find.text('Banana'));
      await tester.pump();

      // Verify both items selected
      expect(selectedValues.contains('Apple'), true);
      expect(selectedValues.contains('Banana'), true);
      expect(selectedValues.length, 2);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      List<String> selectedValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.liquid,
              items: ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
              value: selectedValues,
              onChanged: (value) {
                selectedValues = value;
              },
              itemBuilder: (item) => Text(item),
              hint: const Text('Select fruits'),
              config: const MultiDropDownConfig(
                selectionMode: SelectionMode.multiple,
                enableSearch: true,
                searchHintText: 'Search...',
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();

      // Find search field and enter text
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'App');
      await tester.pump();

      // Verify only matching items show
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('Chip display works in multi-select', (WidgetTester tester) async {
      List<String> selectedValues = ['Apple', 'Banana'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.liquid,
              items: ['Apple', 'Banana', 'Orange'],
              value: selectedValues,
              onChanged: (value) {},
              itemBuilder: (item) => Text(item),
              hint: const Text('Select fruits'),
              config: const MultiDropDownConfig(
                selectionMode: SelectionMode.multiple,
                showSelectedItemsAsChips: true,
              ),
            ),
          ),
        ),
      );

      // Verify chips are displayed
      expect(find.byType(Chip), findsWidgets);
      expect(find.text('Apple'), findsWidgets);
      expect(find.text('Banana'), findsWidgets);
    });

    testWidgets('All animation types render without errors', (WidgetTester tester) async {
      final animationTypes = DropdownAnimationType.values;

      for (var type in animationTypes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomAnimatedMultiDropDown<String>(
                animationType: type,
                items: ['Apple', 'Banana', 'Orange'],
                value: null,
                onChanged: (value) {},
                itemBuilder: (item) => Text(item),
                hint: Text('Select fruit - ${type.name}'),
              ),
            ),
          ),
        );

        // Verify widget renders
        expect(find.byType(CustomAnimatedMultiDropDown<String>), findsOneWidget);
        expect(find.text('Select fruit - ${type.name}'), findsOneWidget);

        // Tap to ensure animation works
        await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
        await tester.pumpAndSettle();

        // Close dropdown
        await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Custom styling works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedMultiDropDown<String>(
              animationType: DropdownAnimationType.glass,
              items: ['Apple', 'Banana', 'Orange'],
              value: null,
              onChanged: (value) {},
              itemBuilder: (item) => Text(item),
              hint: const Text('Select a fruit'),
              config: const MultiDropDownConfig(
                highlightColor: Colors.red,
                backgroundColor: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                blurIntensity: 15,
              ),
            ),
          ),
        ),
      );

      // Verify widget renders with custom config
      expect(find.byType(CustomAnimatedMultiDropDown<String>), findsOneWidget);

      // Tap to open
      await tester.tap(find.byType(CustomAnimatedMultiDropDown<String>));
      await tester.pumpAndSettle();

      // Verify items appear
      expect(find.text('Apple'), findsOneWidget);
    });
  });
}