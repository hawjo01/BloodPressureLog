import 'package:bp_pulse_log/db/record.dart';
import 'package:intl/intl.dart';

class SingleMonthRecords {

    final int year;
    final int month;
    final List<Record> records;

    SingleMonthRecords({
        required this.year,
        required this.month,
        required this.records,
    });

    String monthName() {
        final DateTime date = DateTime(year, month);
        return DateFormat('MMMM').format(date);
    }
}