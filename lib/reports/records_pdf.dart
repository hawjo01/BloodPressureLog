import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:bp_pulse_log/db/record.dart';

class RecordsPdf {
  static pw.Document generateMonthPdf(
    final List<Record> records,
    final int year,
    final int month,
  ) {
    records.sort((a, b) => a.date.compareTo(b.date));

    final List<String> tableHeaders = ['Date', 'Systolic', 'Diastolic', 'Pulse'];
    final tableData = records.map((record) {
      return [
        DateFormat('yyyy-MM-dd HH:mm a').format(record.date),
        record.systolic.toString(),
        record.diastolic.toString(),
        record.pulse.toString(),
      ];
    }).toList();

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text(
              "Blood Pressure Records - ${DateFormat('MMMM yyyy').format(DateTime(year, month))}",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "Generated - ${DateFormat('MMMM dd yyyy h:mm a').format(DateTime.now())}",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.normal),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            headers: tableHeaders,
            data: tableData,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    return pdf;
  }
}
