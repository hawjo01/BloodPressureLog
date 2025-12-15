import 'package:bp_pulse_log/db/record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({super.key, required this.records});

  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20.0,
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
                DataCell(
                  Text(DateFormat('E MMM d hh:mm a').format(record.date)),
                ),
                DataCell(Text(record.systolic.toString())),
                DataCell(Text(record.diastolic.toString())),
                DataCell(Text(record.pulse.toString())),
              ],
            ),
          )
          .toList(),
    );
  }
}
