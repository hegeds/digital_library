import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:mockito/mockito.dart';

import 'package:private_library/storage.dart' as storage;

import './storage_test.mocks.dart' as mocks;
import 'fixtures.dart';

@GenerateMocks([sqflite.Database])
void main() {
  final database = mocks.MockDatabase();
  final book1 = generateBook();
  final book2 = generateBook();

  group('SQLite database', () {
    test('should be able to fetch books', () async {
      when(database.query('books')).thenAnswer((_) async => [
            book1.toMap(),
            book2.toMap(),
          ]);

      var store = storage.SQLiteShelf(database);
      var queriedBooks = await store.retrieveBooks();

      expect(queriedBooks[0].toMap(), book1.toMap());
      expect(queriedBooks[1].toMap(), book2.toMap());
      expect(queriedBooks.length, 2);
    });

    test('should be able to fetch book', () async {
      when(database.query('books',
              where: 'id = ?', whereArgs: [book1.isbn], limit: 1))
          .thenAnswer((_) async => [
                book1.toMap(),
              ]);

      var store = storage.SQLiteShelf(database);
      var queriedBook = await store.retrieveBook(book1.isbn);

      expect(queriedBook?.toMap(), book1.toMap());
    });

    test('should return null if book not found', () async {
      when(database.query('books',
              where: 'id = ?', whereArgs: ['invalid-isbn'], limit: 1))
          .thenAnswer((_) async => []);

      var store = storage.SQLiteShelf(database);
      var queriedBook = await store.retrieveBook('invalid-isbn');

      expect(queriedBook, null);
    });

    test('should be able to store book', () async {
      when(database.insert('books', book1.toMap())).thenAnswer((_) async => 1);

      var store = storage.SQLiteShelf(database);
      store.addBook(book1);

      verify(database.insert('books', book1.toMap()));
    });
  });
}
