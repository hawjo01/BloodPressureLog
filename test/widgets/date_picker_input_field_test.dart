import 'package:bp_pulse_log/widgets/date_picker_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePickerInputField Widget Tests', () {
    testWidgets(
      'DatePickerInputField displays a date and allows it to be changed.',
      (WidgetTester tester) async {
        DateTime? selectedDate;
        DateTime initialDate = DateTime(2025, 5, 15);

        await tester.pumpWidget(
          MaterialApp(
            title: 'DatePickerInputField Test',
            home: Scaffold(
              body: Center(
                child: DatePickerInputField(
                  initialDate: initialDate,
                  onDateChanged: (DateTime value) {
                    selectedDate = value;
                  },
                ),
              ),
            ),
          ),
        );

        // Verify that the initial date is displayed in the format MM-dd-yyyy
        expect(find.text('05-15-2025'), findsExactly(1));
        expect(
          find.widgetWithIcon(TextFormField, Icons.calendar_today),
          findsOneWidget,
        );
        expect(find.text('Date'), findsOneWidget);

        // Simulate tapping the calendar icon to open the date picker
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
        expect(find.byType(DatePickerDialog), findsOneWidget);

        // Simulate selecting the '27' day of the month
        await tester.tap(find.text('27'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify that the displayed date has been updated
        expect(find.text('05-27-2025'), findsOneWidget);

        // Verify that the callback was called with the correct date
        expect(selectedDate, isNotNull);
        expect(selectedDate!, equals(DateTime(2025, 5, 27)));
      },
    );
  });
}