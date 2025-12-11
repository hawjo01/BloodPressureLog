import 'package:bp_pulse_log/db/record.dart';
import 'package:bp_pulse_log/utils/line_chart_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RecordsLineChart extends StatelessWidget {
  const RecordsLineChart({
    super.key,
    required this.records,
    required this.year,
    required this.month,
  });

  final int year;
  final int month;
  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    final systolics = records.asMap().entries.map((entry) {
      final index = entry.value.date.day.toDouble();
      final systolic = entry.value.systolic.toDouble();
      return FlSpot(index, systolic);
    }).toList();

    final diastolics = records.asMap().entries.map((entry) {
      final index = entry.value.date.day.toDouble();
      final diastolic = entry.value.diastolic.toDouble();
      return FlSpot(index, diastolic);
    }).toList();

    final minY = FlChartUtils.findMinY(diastolics);
    final maxY = FlChartUtils.findMaxY(systolics);

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 400,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                minIncluded: false,
                maxIncluded: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                minIncluded: false,
                maxIncluded: false,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: -1.0,
          maxX: _getMaxX(),
          minY: minY - 10,
          maxY: maxY + 10,
          lineBarsData: [
            _lineChartBarData(systolics, Colors.blue),
            _lineChartBarData(diastolics, Colors.red),
          ],
        ),
      ),
    );
  }

  double _getMaxX() {
    return DateUtils.getDaysInMonth(year, month) + 1;
  }

  LineChartBarData _lineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }
}
