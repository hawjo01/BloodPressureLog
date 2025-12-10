import 'package:bp_pulse_log/components/numeric_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumericInputField Widget Tests', () {
    testWidgets('NumericInputField accepts numeric input', (
      WidgetTester tester,
    ) async {
      int? systolic;
      TextEditingController textEditingController = TextEditingController();

      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          title: 'NumericInputField Test',
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Row(
                children: [
                  NumericInputField(
                    label: 'Systolic',
                    hint: 'e.g. 120',
                    controller: textEditingController,
                    onChange: (int value) {
                      systolic = value;
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify that the label is displayed and that 'Required' is not shown initially
      expect(find.text('Systolic'), findsOneWidget);
      expect(find.text('Required'), findsNothing);

      // Mimic user clicking save without entering any value
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();
      expect(find.text('Required'), findsOneWidget);
      expect(systolic, isNull);

      // Enter a non-numeric value and verify that it is not accepted
      await tester.enterText(find.byType(TextFormField).first, 'abc');
      expect(find.text('Required'), findsOneWidget);
      expect(systolic, isNull);

      // Enter a numeric value and save
      await tester.enterText(find.byType(TextFormField).first, '130');
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();
      expect(find.text('Systolic'), findsOneWidget);
      expect(find.text('130'), findsOneWidget);
      expect(find.text('Required'), findsNothing);
      expect(systolic, 130);

      // Clear the input and verify that 'Required' does not appear and the value is cleared
      textEditingController.clear();
      await tester.pumpAndSettle();
      expect(find.text('130'), findsNothing);
      expect(find.text('Required'), findsNothing);
    });
  });
}
