import 'package:bp_pulse_log/components/time_picker_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimePickerInputField Widget Tests', () {
    testWidgets(
      'TimePickerInputField displays a time and allows it to be changed.',
      (WidgetTester tester) async {
        TimeOfDay? selectedTime;
        TimeOfDay initialTime = const TimeOfDay(hour: 10, minute: 30);

        await tester.pumpWidget(
          MaterialApp(
            title: 'TimePickerInputField Test',
            home: Scaffold(
              body: Center(
                child: TimePickerInputField(
                  initialTime: initialTime,
                  onTimeChanged: (TimeOfDay value) {
                    selectedTime = value;
                  },
                ),
              ),
            ),
          ),
        );

        // Verify that the initial date is displayed in the format MM-dd-yyyy
        expect(find.text('10:30 AM'), findsExactly(1));
        expect(
          find.widgetWithIcon(TextFormField, Icons.access_time),
          findsOneWidget,
        );
        expect(find.text('Time'), findsOneWidget);

        // Simulate tapping the calendar icon to open the date picker
        await tester.tap(find.byIcon(Icons.access_time));
        await tester.pumpAndSettle();
        expect(find.byType(TimePickerDialog), findsOneWidget);

        // Simulate selecting the 'PM' button
        await tester.tap(find.text('PM'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify that the displayed date has been updated
        expect(find.text('10:30 PM'), findsOneWidget);

        // Verify that the callback was called with the correct date
        expect(selectedTime, isNotNull);
        expect(selectedTime!, equals(const TimeOfDay(hour: 22, minute: 30)));
      },
    );
  });
}
