import 'dart:io';

import 'package:bp_pulse_log/data/single_month_records.dart';
import 'package:bp_pulse_log/reports/records_pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class RecordsShare extends StatelessWidget {
  const RecordsShare({
    super.key,
    required this.monthRecords,
  });

  final SingleMonthRecords monthRecords;

  void _deleteOldFiles(Directory directory) {
    final files = directory.listSync();
    for (var file in files) {
      if (file is File && file.path.endsWith('.pdf')) {
        try {
          file.deleteSync();
        } catch (e) {
          // Handle any errors during deletion
          debugPrint('Error deleting file ${file.path}: $e');
        }
      }
    }
  }

  Future<File> _exportToPdf(Directory directory) async {
    final pdf = RecordsPdf.generateMonthPdf(monthRecords.records, monthRecords.year, monthRecords.month);

    final fileName = 'bp-records-${monthRecords.monthName()}-${monthRecords.year}.pdf';

    // Save the PDF file to a temporary directory
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  void _createPdfAndShare() async {

    // TODO: This should be done in a background isolate
    final tempDir = await getTemporaryDirectory();
    _deleteOldFiles(tempDir);

    final pdfFile = await _exportToPdf(tempDir);

    // Share the generated PDF file
    await SharePlus.instance.share(
      ShareParams(
        subject: 'Blood Pressure Log',
        text: 'Blood Pressure log for ${monthRecords.monthName()} ${monthRecords.year}',
        files: [XFile(pdfFile.path)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _createPdfAndShare(),
        child: Text('Share'),
      ),
    );
  }
}
