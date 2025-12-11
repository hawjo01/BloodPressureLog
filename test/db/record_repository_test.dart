import 'package:bp_pulse_log/db/record_repository.dart';
import 'package:bp_pulse_log/db/record.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';


// Create a mock for the database factory
//class MockDatabaseFactory extends Mock implements DatabaseFactory {}

class MockDatabaseFactory extends Mock implements DatabaseFactory {
  @override
  Future<Database> openDatabase(String? path, {OpenDatabaseOptions? options}) {
    super.noSuchMethod(
      Invocation.method(
        #openDatabase,
        [path],
        {#options: options},
      ),
      returnValue: Future<Database>.value(
        databaseFactoryFfi.openDatabase(inMemoryDatabasePath, options: options),
      ),
    );
    return databaseFactoryFfi.openDatabase(inMemoryDatabasePath, options: options);
  }
}

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group(
    'RecordRepository',
    () {
      //MockDatabaseFactory mockFactory;
      late Directory tempDir;

      setUp(() async {
        //mockFactory = MockDatabaseFactory();

        tempDir = await Directory.systemTemp.createTemp('pb_pulse_log_test_db');
        // Provide a mock implementation for getDatabasesPath
        // when(
        //   mockFactory.getDatabasesPath(),
        // ).thenAnswer((_) async => Future.value(tempDir.path));
        // You might also need to mock openDatabase if your service uses it

        
//        when(mockFactory.openDatabase(tempDir.path, options: anyNamed('options')))
        when(MockDatabaseFactory().openDatabase(argThat(contains('records_database.db')), options: anyNamed('options')))
            .thenAnswer((invocation) async =>
            databaseFactoryFfi.openDatabase(inMemoryDatabasePath, options: invocation.namedArguments[Symbol('options')]));
        // when(mockFactory.openDatabase(path: anyNamed('path'), version: anyNamed('version'), options: anyNamed('options')))
        //     .thenAnswer((_) async =>
        //     databaseFactoryFfi.openDatabase(inMemoryDatabasePath)
        //     Future.value(null)); // Or a mock database instance
      });

      // tearDown(() async {
      //   if (await tempDir.exists()) {
      //     await tempDir.delete(recursive: true);
      //   }
      // });

      // tearDown(() async {
      //   await database.close();
      // });

      test('insert and retrieve record', () async {
        final record = Record(
          date: DateTime.now(),
          systolic: 120,
          diastolic: 80,
          heartRate: 70,
        );

        final recordRepository = RecordRepository();
        await recordRepository.insertRecord(record);
        final records = await recordRepository.getRecords();

        expect(records.length, 1);
        expect(records[0].systolic, 120);
        expect(records[0].diastolic, 80);
        expect(records[0].heartRate, 70);
        expect(records[0].id, isNotNull);
      });
    },
    // onPlatform: {'windows': Skip('This test is problematic on Windows')},
  );
}
