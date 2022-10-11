import 'package:sqflite/sqflite.dart';

import './model.dart';

class BookShelf {
  Future<void> addBook(Book book) async {
    throw UnimplementedError();
  }

  Future<List<Book>> retrieveBooks() {
    throw UnimplementedError();
  }

  Future<Book?> retrieveBook(String isbn) {
    throw UnimplementedError();
  }
}

class SQLiteShelf implements BookShelf {
  final Database _database;

  SQLiteShelf(this._database);

  @override
  Future<void> addBook(Book book) async {
    _database.insert('books', book.toMap());
  }

  @override
  Future<Book?> retrieveBook(String isbn) async {
    final List<Map<String, dynamic>> queryResults = await _database
        .query('books', where: 'id = ?', whereArgs: [isbn], limit: 1);

    if (queryResults.isEmpty) {
      return null;
    }

    return _transformQueryResultToBook(queryResults[0]);
  }

  @override
  Future<List<Book>> retrieveBooks() async {
    final List<Map<String, dynamic>> queryResults =
        await _database.query('books');

    return List.generate(queryResults.length, (index) {
      return _transformQueryResultToBook(queryResults[index]);
    });
  }

  Book _transformQueryResultToBook(Map<String, dynamic> result) {
    return Book(
      result['isbn'],
      result['author'],
      result['title'],
      result['published'],
    );
  }
}
