import 'dart:convert';

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
      result['authors'].split(';'),
      result['title'],
      result['published'],
    );
  }
}

class ConfigStore {
  Future<dynamic> retrieveConfig(String key) {
    throw UnimplementedError();
  }

  Future<void> saveConfig(String key, dynamic value) {
    throw UnimplementedError();
  }
}

class SQLiteConfigStore implements ConfigStore {
  final Database _database;

  SQLiteConfigStore(this._database);

  @override
  Future retrieveConfig(String key) async {
    final List<Map<String, dynamic>> queryResults = await _database
        .query('configs', where: 'key = ?', whereArgs: [key], limit: 1);
    if (queryResults.isEmpty) {
      return null;
    }
    return jsonDecode(queryResults[0]['value']);
  }

  @override
  Future<void> saveConfig(String key, value) async {
    var rawValue = jsonEncode(value);

    if (await retrieveConfig(key) != null) {
      await _database.update('configs', {'key': key, 'value': rawValue},
          where: 'key = ?', whereArgs: [key]);
      return;
    }

    await _database.insert('configs', {'key': key, 'value': rawValue});
  }
}
