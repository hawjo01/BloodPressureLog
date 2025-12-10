import 'package:bp_pulse_log/components/year_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearDropdownMenu Widget Tests', () {
    testWidgets('YearDropdownMenu displays years and handles selection', (
      WidgetTester tester,
    ) async {
      int? selectedYear;

      await tester.pumpWidget(
        MaterialApp(
          title: 'YearDropdownMenu Test',
          home: Scaffold(
            body: Center(
              child: YearDropdownMenu(
                initialValue: 2025,
                years: [2021, 2022, 2023, 2024, 2025],
                onYearChanged: (int value) {
                  selectedYear = value;
                },
              ),
            ),
          ),
        ),
      );

      // Verify that 2025 is displayed, it will be found twice, once in the button and once in the menu
      expect(find.text('2025'), findsExactly(2));

      // Verify that all years are displayed in the dropdown
      for (var year in [2021, 2022, 2023, 2024]) {
        if (year == 2025) {
          continue; // Skip current month as it will exist twice (see next expect)
        }
        expect(find.text(year.toString()), findsOneWidget);
      }

      // Simulate selecting a year
      int yearToSelect = 2023;

      await tester.tap(warnIfMissed: false, find.byType(MenuItemButton).first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(yearToSelect.toString()).last,
      ); // Select yearToSelect
      await tester.pumpAndSettle();

      // Verify that the callback was called with the correct year
      expect(find.text(yearToSelect.toString()), findsExactly(2));
      expect(selectedYear, yearToSelect);
    });
  });
}
