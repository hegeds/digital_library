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
}
