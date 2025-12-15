import 'package:test/test.dart';

import 'package:bp_pulse_log/db/record.dart' as r;

void main() {
  group('Record Model Tests', () {
    test('toMap/fromMap', () {
      final record = r.Record(
        id: 1,
        date: DateTime(2025, 1, 1),
        systolic: 120,
        diastolic: 80,
        pulse: 70,
      );

      final recordMap = record.toMap();
      expect(recordMap['id'], equals(1));
      expect(
        recordMap['date'],
        equals(DateTime(2025, 1, 1).millisecondsSinceEpoch),
      );
      expect(recordMap['systolic'], equals(120));
      expect(recordMap['diastolic'], equals(80));
      expect(recordMap['pulse'], equals(70));

      final newRecord = r.Record.fromMap(recordMap);

      expect(newRecord.id, equals(record.id));
      expect(newRecord.date, equals(record.date));
      expect(newRecord.systolic, equals(record.systolic));
      expect(newRecord.diastolic, equals(record.diastolic));
      expect(newRecord.pulse, equals(record.pulse));
    });

    test('toString', () {
      final record = r.Record(
        id: 2,
        date: DateTime(2025, 2, 2),
        systolic: 130,
        diastolic: 85,
        pulse: 75,
      );

      final recordString = record.toString();
      expect(
        recordString,
        equals(
          'Record{id: 2, date: 2025-02-02 00:00:00.000, systolic: 130, diastolic: 85, pulse: 75}',
        ),
      );
    });
  });
}
