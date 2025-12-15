import 'package:bp_pulse_log/db/record_repository.dart';
import 'package:bp_pulse_log/db/record.dart';
import 'package:test/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  RecordRepository? recordRepository;

  setUp(() {
    recordRepository = RecordRepository(path: ':memory:');
  });

  tearDown(() async {
    recordRepository?.close();
  });

  test('empty database returns no records', () async {
    final Record? mostRecentRecord = await recordRepository!
        .getMostRecentRecord();
    expect(mostRecentRecord, isNull);

    final List<Record> mostRecentRecords = await recordRepository!
        .getMostRecentRecords(10);
    expect(mostRecentRecords, isEmpty);

    final List<Record> monthRecords = await recordRepository!
        .getRecordsForMonth(2025, 11);
    expect(monthRecords, isEmpty);
  });

  test('insert and retrieve a single record', () async {
    final List<Record> noRecords = await recordRepository!.getMostRecentRecords(
      10,
    );
    expect(noRecords, isEmpty);

    Record record = Record(
      date: DateTime.now(),
      systolic: 120,
      diastolic: 80,
      pulse: 70,
    );

    await recordRepository!.insertRecord(record);
    final Record? mostRecent = await recordRepository!.getMostRecentRecord();

    expect(mostRecent, isNotNull);
    expect(mostRecent!.systolic, 120);
    expect(mostRecent.diastolic, 80);
    expect(mostRecent.pulse, 70);
    expect(mostRecent.id, isNotNull);

    final List<Record> mostRecentRecords = await recordRepository!
        .getMostRecentRecords(2);
    expect(mostRecentRecords.length, 1);
    expect(mostRecentRecords[0].systolic, 120);
    expect(mostRecentRecords[0].diastolic, 80);
    expect(mostRecentRecords[0].pulse, 70);
    expect(mostRecentRecords[0].id, isNotNull);

    final List<Record> monthRecords = await recordRepository!
        .getRecordsForMonth(record.date.year, record.date.month);
    expect(monthRecords.length, 1);
    expect(monthRecords[0].systolic, 120);
    expect(monthRecords[0].diastolic, 80);
    expect(monthRecords[0].pulse, 70);
  });

  test('insert and retrieve multiple records', () async {
    final List<Record> noRecords = await recordRepository!.getMostRecentRecords(
      10,
    );
    expect(noRecords, isEmpty);

    Record record1 = Record(
      date: DateTime(2025, 12, 15, 11, 08),
      systolic: 120,
      diastolic: 80,
      pulse: 70,
    );

    Record record2 = Record(
      date: DateTime(2025, 12, 14, 14, 30),
      systolic: 130,
      diastolic: 90,
      pulse: 80,
    );

    Record record3 = Record(
      date: DateTime(2025, 12, 13, 10, 15),
      systolic: 125,
      diastolic: 85,
      pulse: 75,
    );

    // Different month than previous 3 records
    Record record4 = Record(
      date: DateTime(2025, 11, 13, 8, 02),
      systolic: 125,
      diastolic: 85,
      pulse: 75,
    );

    await recordRepository!.insertRecord(record1);
    await recordRepository!.insertRecord(record2);
    await recordRepository!.insertRecord(record3);
    await recordRepository!.insertRecord(record4);

    final Record? mostRecent = await recordRepository!.getMostRecentRecord();

    expect(mostRecent, isNotNull);
    expect(mostRecent!.systolic, record1.systolic);
    expect(mostRecent.diastolic, record1.diastolic);
    expect(mostRecent.pulse, record1.pulse);
    expect(mostRecent.id, isNotNull);

    final List<Record> mostRecentRecords = await recordRepository!
        .getMostRecentRecords(2);
    expect(mostRecentRecords.length, 2);
    expect(mostRecentRecords[0].systolic, record1.systolic);
    expect(mostRecentRecords[0].diastolic, record1.diastolic);
    expect(mostRecentRecords[0].pulse, record1.pulse);
    expect(mostRecentRecords[0].id, isNotNull);

    expect(mostRecentRecords[1].systolic, record2.systolic);
    expect(mostRecentRecords[1].diastolic, record2.diastolic);
    expect(mostRecentRecords[1].pulse, record2.pulse);
    expect(mostRecentRecords[1].id, isNotNull);

    final List<Record> monthRecords = await recordRepository!
        .getRecordsForMonth(record1.date.year, record1.date.month);
    expect(monthRecords.length, 3);
    expect(monthRecords[0].systolic, record1.systolic);
    expect(monthRecords[0].diastolic, record1.diastolic);
    expect(monthRecords[0].pulse, record1.pulse);

    expect(monthRecords[1].systolic, record2.systolic);
    expect(monthRecords[1].diastolic, record2.diastolic);
    expect(monthRecords[1].pulse, record2.pulse);

    expect(monthRecords[2].systolic, record3.systolic);
    expect(monthRecords[2].diastolic, record3.diastolic);
    expect(monthRecords[2].pulse, record3.pulse);
  });
}
