import 'package:bp_pulse_log/data/single_month_records.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'record.dart';

class RecordRepository {
  static Database? _database;
  String? path;

  // Path is optional; if not provided, a default path will be used.  Used for testing.
  RecordRepository({this.path});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    path ??= join(await getDatabasesPath(), 'records_database.db');

    return await openDatabase(
      path!,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE records(id INTEGER PRIMARY KEY, date INTEGER, systolic INTEGER, diastolic INTEGER, pulse INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) => {
        if (oldVersion < 2) {
          db.execute(
            'ALTER TABLE records RENAME COLUMN heartRate TO pulse',
          )
        }
      },
    );
  }

  Future<void> insertRecord(Record record) async {
    final db = await database;
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Add methods for update, delete, etc. as needed
  Future<Record?> getMostRecentRecord() async {
    final List<Record> mostRecentRecords = await getMostRecentRecords(1);
    if (mostRecentRecords.isNotEmpty) {
      return mostRecentRecords[0];
    } else {
      return null;
    }
  }

    // Add methods for update, delete, etc. as needed
  Future<List<Record>> getMostRecentRecords(int number) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      orderBy: 'date DESC',
      limit: number,
    );

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }

  Future<SingleMonthRecords> getSingleMonthRecords(int year, int month) async {
    final db = await database;
    final int startTimestamp = DateTime(year, month, 1).millisecondsSinceEpoch;
    final int endTimestamp = DateTime(year, month + 1, 1).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'date >= ? AND date < ?',
      whereArgs: [startTimestamp, endTimestamp],
      orderBy: 'date DESC',
    );

    final List<Record> records = List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });

    return SingleMonthRecords(year: year, month: month, records: records);
  }

  void close() async {
    final db = await database;
    db.close();
    _database = null;
  } 
}