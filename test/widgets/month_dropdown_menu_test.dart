import 'package:bp_pulse_log/widgets/month_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthDropdownMenu Widget Tests', () {
    testWidgets('MonthDropdownMenu displays months and handles selection', (
      WidgetTester tester,
    ) async {
      final MonthLabel april = MonthLabel.getByNumber(DateTime.april);
      int? selectedMonth;

      await tester.pumpWidget(
        MaterialApp(
          title: 'MonthDropdownMenu Test',
          home: Scaffold(
            body: Center(
              child: MonthDropdownMenu(
                initialValue: april.number,
                onMonthChanged: (int value) {
                  selectedMonth = value;
                },
              ),
            ),
          ),
        ),
      );

      // Verify that april is displayed, it will be found twice, once in the button and once in the menu
      expect(find.text(april.label), findsExactly(2));

      // Verify that all months are displayed in the dropdown
      for (var month in MonthLabel.values) {
        if (month == april) {
          continue; // Skip current month as it will exist twice (see next expect)
        }
        expect(find.text(month.label), findsOneWidget);
      }

      // Simulate selecting a month
      MonthLabel november = MonthLabel.getByNumber(DateTime.november);

      await tester.tap(warnIfMissed: false, find.byType(MenuItemButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(november.label).last); // Select november
      await tester.pumpAndSettle();

      // Verify that the callback was called with the correct month
      expect(find.text(november.label), findsExactly(2));
      expect(selectedMonth, november.number);
    });
  });

  group('MonthLabel Tests', () {
    test('Month Name and Number', () {
      expect(MonthLabel.january.label, equals('January'));
      expect(MonthLabel.january.number, equals(1));
      expect(MonthLabel.february.label, equals('February'));
      expect(MonthLabel.february.number, equals(2));
      expect(MonthLabel.march.label, equals('March'));
      expect(MonthLabel.march.number, equals(3));
      expect(MonthLabel.april.label, equals('April'));
      expect(MonthLabel.april.number, equals(4));
      expect(MonthLabel.may.label, equals('May'));
      expect(MonthLabel.may.number, equals(5));
      expect(MonthLabel.june.label, equals('June'));
      expect(MonthLabel.june.number, equals(6));
      expect(MonthLabel.july.label, equals('July'));
      expect(MonthLabel.july.number, equals(7));
      expect(MonthLabel.august.label, equals('August'));
      expect(MonthLabel.august.number, equals(8));
      expect(MonthLabel.september.label, equals('September'));
      expect(MonthLabel.september.number, equals(9));
      expect(MonthLabel.october.label, equals('October'));
      expect(MonthLabel.october.number, equals(10));
      expect(MonthLabel.november.label, equals('November'));
      expect(MonthLabel.november.number, equals(11));
      expect(MonthLabel.december.label, equals('December'));
      expect(MonthLabel.december.number, equals(12));
    });

    test('Get By Number', () {
      expect(MonthLabel.getByNumber(1), equals(MonthLabel.january));
      expect(MonthLabel.getByNumber(2), equals(MonthLabel.february));
      expect(MonthLabel.getByNumber(3), equals(MonthLabel.march));
      expect(MonthLabel.getByNumber(4), equals(MonthLabel.april));
      expect(MonthLabel.getByNumber(5), equals(MonthLabel.may));
      expect(MonthLabel.getByNumber(6), equals(MonthLabel.june));
      expect(MonthLabel.getByNumber(7), equals(MonthLabel.july));
      expect(MonthLabel.getByNumber(8), equals(MonthLabel.august));
      expect(MonthLabel.getByNumber(9), equals(MonthLabel.september));
      expect(MonthLabel.getByNumber(10), equals(MonthLabel.october));
      expect(MonthLabel.getByNumber(11), equals(MonthLabel.november));
      expect(MonthLabel.getByNumber(12), equals(MonthLabel.december));
    });
  });
}
