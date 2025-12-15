import 'package:bp_pulse_log/utils/line_chart_utils.dart' as utils;
import 'package:fl_chart/fl_chart.dart';
import 'package:test/test.dart';

void main() {
  group('Line Chart Utils Tests', () {
    test('findMaxY - empty list', () {
      final spots = <FlSpot>[];
      final maxY = utils.FlChartUtils.findMaxY(spots);
      expect(maxY, equals(0));
    });

    test('findMaxY - 1 item', () {
      final spots = <FlSpot>[FlSpot(1, 1)];
      final maxY = utils.FlChartUtils.findMaxY(spots);
      expect(maxY, equals(1));
    });

    test('findMaxY - 2 items', () {
      final spots = <FlSpot>[FlSpot(1, 1), FlSpot(2, 0)];
      final maxY = utils.FlChartUtils.findMaxY(spots);
      expect(maxY, equals(1));
    });

    test('findMaxY - 3 items', () {
      final spots = <FlSpot>[FlSpot(1, 1), FlSpot(2, 10), FlSpot(3, 5)];
      final maxY = utils.FlChartUtils.findMaxY(spots);
      expect(maxY, equals(10));
    });
  });

  test('findMinY - empty list', () {
    final spots = <FlSpot>[];
    final maxY = utils.FlChartUtils.findMinY(spots);
    expect(maxY, equals(0));
  });

  test('findMinY - 1 item', () {
    final spots = <FlSpot>[FlSpot(1, 1)];
    final maxY = utils.FlChartUtils.findMinY(spots);
    expect(maxY, equals(1));
  });

  test('findMinY - 2 items', () {
    final spots = <FlSpot>[FlSpot(1, 1), FlSpot(2, 0)];
    final maxY = utils.FlChartUtils.findMinY(spots);
    expect(maxY, equals(0));
  });

  test('findMinY - 3 items', () {
    final spots = <FlSpot>[FlSpot(1, 1), FlSpot(2, 10), FlSpot(3, 5)];
    final maxY = utils.FlChartUtils.findMinY(spots);
    expect(maxY, equals(1));
  });
}
