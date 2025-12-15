import 'package:bp_pulse_log/db/record.dart';
import 'package:bp_pulse_log/utils/datetime_utils.dart';
import 'package:bp_pulse_log/utils/line_chart_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            _lineChartBarData(diastolics, Colors.deepPurple),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              maxContentWidth: 200,
              getTooltipColor: (touchedSpot) => Colors.grey.shade200,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  // Only build a toolip for the first spot find on an index line as it will be triggered for all spots on the same x-axis line
                  if (spot.barIndex == 0) {
                    return buildLineToolTip(spot.spotIndex);
                  } else {
                    return null;
                  }
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  // Handling building a tooltip that may contain multiple records for the same day
  LineTooltipItem buildLineToolTip(int index) {
    final record = records[index];
    final dateRecords = records
        .where((r) => DateTimeUtils.isSameDay(r.date, record.date))
        .toList();
    dateRecords.sort((a, b) => a.date.compareTo(b.date));

    final children = <TextSpan>[];
    for (var r in dateRecords) {
      children.add(
        TextSpan(
          text: DateFormat('\n\nh:mm a').format(r.date),
        ),
      );
      children.add(
        TextSpan(
          text: _buildRecordTooltipText(r),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      );
    }

    final label = DateFormat('EEEE MMMM d').format(record.date);
    return LineTooltipItem(
      label.toString(),
      const TextStyle(color: Colors.black),
      textAlign: TextAlign.start,
      children: children,
    );
  }

  String _buildRecordTooltipText(Record record) {
    final buffer = StringBuffer('');
    buffer.write('\nSystolic:  ${record.systolic}');
    buffer.write('\nDiastolic: ${record.diastolic}');
    buffer.write('\nPulse:     ${record.pulse}');
    return buffer.toString();
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
