import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/month_dropdown_menu.dart';
import 'components/year_dropdown_menu.dart';
import 'db/record_repository.dart';
import 'db/record.dart';
import 'utils/line_chart_utils.dart';

class HistoryChartScreen extends StatefulWidget {
  const HistoryChartScreen({super.key});

  @override
  State<HistoryChartScreen> createState() => _HistoryChartScreenState();
}

enum ChartType { line, table }

class _HistoryChartScreenState extends State<HistoryChartScreen> {
  final List<int> _years = List.generate(5, (index) {
    return DateTime.now().year - index;
  });

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  ChartType _selectedChartType = ChartType.line;
  late Future<List<Record>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _getRecordsForMonth(_selectedYear, _selectedMonth);
  }

  void _onSelectedYearChanged(int year) {
    setState(() {
      _selectedYear = year;
      _recordsFuture = _getRecordsForMonth(_selectedYear, _selectedMonth);
    });
  }

  void _onSelectedMonthChanged(int month) {
    setState(() {
      _selectedMonth = month;
      _recordsFuture = _getRecordsForMonth(_selectedYear, _selectedMonth);
    });
  }

  Future<List<Record>> _getRecordsForMonth(int year, int month) async {
    RecordRepository recordRepository = RecordRepository();
    return await recordRepository.getRecordsForMonth(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthDropdownMenu(
                initialValue: _selectedMonth,
                onMonthChanged: _onSelectedMonthChanged,
              ),
              const SizedBox(width: 20),
              YearDropdownMenu(
                initialValue: _selectedYear,
                years: _years,
                onYearChanged: _onSelectedYearChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SegmentedButton<ChartType>(
                segments: const <ButtonSegment<ChartType>>[
                  ButtonSegment<ChartType>(
                    value: ChartType.line,
                    label: Text('Line'),
                    icon: Icon(Icons.show_chart_outlined),
                  ),
                  ButtonSegment<ChartType>(
                    value: ChartType.table,
                    label: Text('Table'),
                    icon: Icon(Icons.table_chart_outlined),
                  ),
                ],
                selected: <ChartType>{_selectedChartType},
                onSelectionChanged: (Set<ChartType> newSelection) {
                  setState(() {
                    _selectedChartType = newSelection.first;
                  });
                },
              ),
            ],
          ),
          FutureBuilder<List<Record>>(
            future: _recordsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No records found.');
              } else {
                final records = snapshot.data!;
                return Container(child: _buildChart(records));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Record> records) {
    switch (_selectedChartType) {
      case ChartType.line:
        return _buildLineChart(records);
      case ChartType.table:
        return _buildTableChart(records);
    }
  }

  Widget _buildTableChart(List<Record> records) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(
          label: Text('SBP'),
          numeric: true,
          tooltip: 'Systolic Blood Pressure',
        ),
        DataColumn(
          label: Text('DBP'),
          numeric: true,
          tooltip: 'Diastolic Blood Pressure',
        ),
        DataColumn(label: Text('PR'), numeric: true, tooltip: 'Pulse Rate'),
      ],
      rows: records
          .map(
            (record) => DataRow(
              cells: [
                DataCell(Text(DateFormat('EEE hh:mm a').format(record.date))),
                DataCell(Text(record.systolic.toString())),
                DataCell(Text(record.diastolic.toString())),
                DataCell(Text(record.heartRate.toString())),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildLineChart(List<Record> records) {
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
    return DateUtils.getDaysInMonth(_selectedYear, _selectedMonth) + 1;
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
