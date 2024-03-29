import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Migration {
  final List<String> _upStatements;
  final List<String> _downStatements;

  const Migration(this._upStatements, this._downStatements);

  up(Database db) async {
    for (var statement in _upStatements) {
      await db.execute(statement);
    }
  }

  down(Database db) async {
    for (var statement in _downStatements) {
      await db.execute(statement);
    }
  }
}

const migrations = [
  Migration([
    'CREATE TABLE books(isbn TEXT PRIMARY KEY, author TEXT, title TEXT, published INTEGER);'
  ], [
    'DROP TABLE books;'
  ]),
  Migration([
    'ALTER TABLE books RENAME COLUMN author TO authors;',
  ], [
    'ALTER TABLE books RENAME COLUMN authors TO author;',
  ]),
  Migration([
    'CREATE TABLE configs(key TEXT PRIMARY KEY, value TEXT);',
    'INSERT INTO configs (key, value) VALUES ("enabledAPIs", \'["google"]\');'
  ], [
    'DROP TABLE configs;',
  ]),
  Migration([
    'UPDATE configs SET value=\'["google", "open-library"]\' WHERE key="enabledAPIs";'
  ], [
    'UPDATE configs SET value=\'["google", "google"]\' WHERE key="enabledAPIs";'
  ])
];

Future<Database> connectToDatabase(
    {int version = 4,
    List<Migration> migrations = migrations,
    bool isInMemory = false}) async {
  var dbPath = join(await getDatabasesPath(), 'library.db');

  return openDatabase(dbPath, onUpgrade: ((db, oldVersion, newVersion) async {
    for (var i = oldVersion; i < newVersion; i++) {
      await migrations[i].up(db);
    }
  }), onDowngrade: ((db, oldVersion, newVersion) async {
    for (var i = oldVersion - 1; i >= newVersion; i--) {
      await migrations[i].down(db);
    }
  }), version: version);
}
