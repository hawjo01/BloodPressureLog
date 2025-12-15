import 'package:bp_pulse_log/db/record.dart';
import 'package:bp_pulse_log/widgets/records_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('RecordsTable Widget Tests', () {
    testWidgets('Displays a list of records in a table format.', (
      WidgetTester tester,
    ) async {
      List<Record> records = [
        Record(
          date: DateTime(2025, 5, 15, 14, 30),
          systolic: 120,
          diastolic: 80,
          pulse: 70,
        ),
        Record(
          date: DateTime(2025, 5, 16, 9, 15),
          systolic: 130,
          diastolic: 85,
          pulse: 75,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          title: 'RecordsTable Test',
          home: Scaffold(
            body: Center(child: RecordsTable(records: records)),
          ),
        ),
      );

      // Verify that table headers are displayed
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('SBP'), findsOneWidget);
      expect(find.text('DBP'), findsOneWidget);
      expect(find.text('PR'), findsOneWidget);

      // Verify that the 1st record is displayed
      expect(
        find.text(DateFormat('E MMM d hh:mm a').format(records[0].date)),
        findsOneWidget,
      );
      expect(find.text(records[0].systolic.toString()), findsOneWidget);
      expect(find.text(records[0].diastolic.toString()), findsOneWidget);
      expect(find.text(records[0].pulse.toString()), findsOneWidget);

      // Verify that the 2nd record is displayed
      expect(
        find.text(DateFormat('E MMM d hh:mm a').format(records[1].date)),
        findsOneWidget,
      );
      expect(find.text(records[1].systolic.toString()), findsOneWidget);
      expect(find.text(records[1].diastolic.toString()), findsOneWidget);
      expect(find.text(records[1].pulse.toString()), findsOneWidget);
    });
  });
}
