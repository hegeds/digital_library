import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:digital_library/api.dart';
import 'package:digital_library/model.dart';

import 'api_test.mocks.dart' as mocks;
import 'fixtures.dart';

@GenerateMocks([http.Client])
void main() {
  group('GoogleBooksAPI', () {
    var book = generateBook();
    var url = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: 'books/v1/volumes',
        query: 'q=isbn:${book.isbn}');

    test('should be able to fetch book', () async {
      final client = mocks.MockClient();

      var responseBody = {
        "totalItems": 1,
        "items": [
          {
            "volumeInfo": {
              "authors": book.authors,
              "title": book.title,
              "publishedDate": '${book.published}'
            },
          }
        ],
      };

      when(client.get(url)).thenAnswer(
        (_) async => http.Response(jsonEncode(responseBody), 200),
      );

      var actualBook = await fetchBookFromGoogle(book.isbn, client: client);

      expect(actualBook, isA<Book>());
      expect('$actualBook', '$book');
    });

    for (var count in [0, 2]) {
      test('should return `null` if count is $count', () async {
        final client = mocks.MockClient();

        var responseBody = {
          "totalItems": count,
        };
        when(client.get(url)).thenAnswer(
          (_) async => http.Response(jsonEncode(responseBody), 200),
        );

        var actualBook = await fetchBookFromGoogle(book.isbn, client: client);

        expect(actualBook, null);
      });
    }
  });

  group('Open library API', (() {
    var book = generateBook();
    var bookURL = Uri(
        scheme: 'https',
        host: 'www.openlibrary.org',
        path: '/isbn/${book.isbn}.json');
    var authorReferences =
        book.authors.map((author) => {'key': '/$author'}).toList();

    test('able to fetch book', () async {
      final client = mocks.MockClient();

      when(client.get(bookURL)).thenAnswer(
        (_) async => http.Response(
            jsonEncode({
              "title": book.title,
              "authors": authorReferences,
              "publish_date": 'October 1, ${book.published}',
            }),
            200),
      );
      book.authors.forEach((author) {
        var authorURL = Uri(
            scheme: 'https',
            host: 'www.openlibrary.org',
            path: '/$author.json');
        when(client.get(authorURL)).thenAnswer(
          (_) async => http.Response(
              jsonEncode({
                'personal_name': author,
              }),
              200),
        );
      });

      var actualBook =
          await fetchBookFromOpenLibrary(book.isbn, client: client);

      expect(actualBook, isA<Book>());
      expect('$actualBook', '$book');
    });

    test('returns null when book not found', () async {
      final client = mocks.MockClient();

      when(client.get(bookURL)).thenAnswer(
        (_) async => http.Response(jsonEncode({}), 404),
      );

      var actualBook =
          await fetchBookFromOpenLibrary(book.isbn, client: client);

      expect(actualBook, null);
    });
  }));
}
