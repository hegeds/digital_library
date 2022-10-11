import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> connectToDatabase() async {
  var dbPath = (join(await getDatabasesPath(), 'library.db'));

  return openDatabase(dbPath, onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE books(isbn TEXT PRIMARY KEY, author TEXT, title TEXT, published INTEGER)',
    );
  }, version: 1);
}
