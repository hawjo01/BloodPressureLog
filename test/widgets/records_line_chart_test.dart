import 'package:bp_pulse_log/db/record.dart';
import 'package:bp_pulse_log/widgets/records_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecordsLineChart Widget Tests', () {
    testWidgets('Displays a list of records in a line chart.', (
      WidgetTester tester,
    ) async {
      List<Record> records = [
        Record(
          date: DateTime(2025, 5, 15, 14, 30),
          systolic: 120,
          diastolic: 80,
          heartRate: 70,
        ),
        Record(
          date: DateTime(2025, 5, 16, 9, 15),
          systolic: 130,
          diastolic: 85,
          heartRate: 75,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          title: 'RecordsLineChart Test',
          home: Scaffold(
            body: Center(child: RecordsLineChart(records: records, year: 2025, month: 5)),
          ),
        ),
      );

      // Verify that a couple of x-axis labels are displayed
      expect(find.text('0'), findsOneWidget);
      expect(find.text('30'), findsOneWidget); 

      // Verify that a couple of y-axis labels are displayed
      expect(find.text('80'), findsOneWidget);
      expect(find.text('130'), findsOneWidget);
    });
  });
}
