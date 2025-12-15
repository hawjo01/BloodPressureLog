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
            body: Center(
              child: RecordsLineChart(records: records, year: 2025, month: 5),
            ),
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

  group('RecordsLineChart Snapshot Tests', () {
    test('buildLineToolTip - single date record', () {
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
      final recordsLineChart = RecordsLineChart(
        records: records,
        year: 2025,
        month: 5,
      );
      final tooltip = recordsLineChart.buildLineToolTip(1);

      expect(tooltip.textAlign, TextAlign.start);
      expect(tooltip.text, 'Friday May 16');
      expect(tooltip.children!.length, 2);
      expect(tooltip.children![0].toPlainText(), contains('9:15 AM'));
      expect(tooltip.children![1].toPlainText(), contains('Systolic:'));
      expect(tooltip.children![1].toPlainText(), contains('130'));
      expect(tooltip.children![1].toPlainText(), contains('Diastolic:'));
      expect(tooltip.children![1].toPlainText(), contains('85'));
      expect(tooltip.children![1].toPlainText(), contains('Pulse:'));
      expect(tooltip.children![1].toPlainText(), contains('75'));
    });

    test('buildLineToolTip - 2 date records', () {
      List<Record> records = [
        Record(
          date: DateTime(2025, 5, 16, 14, 30),
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
      final recordsLineChart = RecordsLineChart(
        records: records,
        year: 2025,
        month: 5,
      );
      final tooltip = recordsLineChart.buildLineToolTip(1);

      expect(tooltip.textAlign, TextAlign.start);
      expect(tooltip.text, 'Friday May 16');
      expect(tooltip.children!.length, 4);
      expect(tooltip.children![0].toPlainText(), contains('9:15 AM'));
      expect(tooltip.children![1].toPlainText(), contains('Systolic:'));
      expect(tooltip.children![1].toPlainText(), contains('130'));
      expect(tooltip.children![1].toPlainText(), contains('Diastolic:'));
      expect(tooltip.children![1].toPlainText(), contains('85'));
      expect(tooltip.children![1].toPlainText(), contains('Pulse:'));
      expect(tooltip.children![1].toPlainText(), contains('75'));
      expect(tooltip.children![2].toPlainText(), contains('2:30 PM'));
      expect(tooltip.children![3].toPlainText(), contains('Systolic:'));
      expect(tooltip.children![3].toPlainText(), contains('120'));
      expect(tooltip.children![3].toPlainText(), contains('Diastolic:'));
      expect(tooltip.children![3].toPlainText(), contains('80'));
      expect(tooltip.children![3].toPlainText(), contains('Pulse:'));
      expect(tooltip.children![3].toPlainText(), contains('70'));
    });
  });
}
