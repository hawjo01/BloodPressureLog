import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'record.dart';

class RecordRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'records_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE records(id INTEGER PRIMARY KEY, date INTEGER, systolic INTEGER, diastolic INTEGER, heartRate INTEGER)',
        );
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

  Future<List<Record>> getRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('records');

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }

  // Add methods for update, delete, etc. as needed
  Future<Record?> getMostRecentRecord() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      orderBy: 'date DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Record.fromMap(maps[0]);
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

  Future<List<Record>> getRecordsForMonth(int year, int month) async {
    final db = await database;
    final int startTimestamp = DateTime(year, month, 1).millisecondsSinceEpoch;
    final int endTimestamp = DateTime(year, month + 1, 1).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'date >= ? AND date < ?',
      whereArgs: [startTimestamp, endTimestamp],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }
}