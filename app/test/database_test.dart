import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:digital_library/database.dart';

void main() {
  group('Database connections', () {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    const migrations = [
      Migration([
        'CREATE TABLE test (id INTEGER);',
        'INSERT INTO test (id) VALUES (1);',
      ], [
        'DROP TABLE test;'
      ]),
      Migration(['INSERT INTO test (id) VALUES (2);'],
          ['DELETE FROM test WHERE id=2'])
    ];

    setUp(() async {
      var dbFile = File(join(await getDatabasesPath(), 'library.db'));
      if (dbFile.statSync().type != FileSystemEntityType.notFound) {
        dbFile.deleteSync();
      }
    });

    for (var version in const [1, 2]) {
      test('able to run up migration $version', () async {
        var database =
            await connectToDatabase(version: version, migrations: migrations);

        var results = await database.query('test',
            columns: ['id'], where: 'id = ?', whereArgs: [version]);

        await database.close();

        expect(results.length, 1);
        expect(results[0]['id'], version);
      });
    }

    test('able to run down migration from 2 to 1', () async {
      var database =
          await connectToDatabase(version: 2, migrations: migrations);
      await database.close();
      database = await connectToDatabase(version: 1, migrations: migrations);

      var results = await database.query('test',
          columns: ['id'], where: 'id = ?', whereArgs: [1]);

      // await database.close();

      expect(results.length, 1);
      expect(results[0]['id'], 1);
    });

    test('able to run up migration from 1 to 2', () async {
      var database =
          await connectToDatabase(version: 1, migrations: migrations);
      await database.close();
      database = await connectToDatabase(version: 2, migrations: migrations);

      var results = await database.query('test',
          columns: ['id'], where: 'id = ?', whereArgs: [2]);

      await database.close();
      expect(results.length, 1);
      expect(results[0]['id'], 2);
    });
  });
}
