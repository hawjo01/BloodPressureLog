import 'package:bp_pulse_log/widgets/month_dropdown_menu.dart';
import 'package:bp_pulse_log/widgets/records_line_chart.dart';
import 'package:bp_pulse_log/widgets/records_table.dart';
import 'package:bp_pulse_log/widgets/year_dropdown_menu.dart';
import 'package:bp_pulse_log/db/record.dart';
import 'package:bp_pulse_log/db/record_repository.dart';
import 'package:flutter/material.dart';


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
        return RecordsLineChart(records: records, year: _selectedYear, month: _selectedMonth);
      case ChartType.table:
        return RecordsTable(records: records);
    }
  }
}
