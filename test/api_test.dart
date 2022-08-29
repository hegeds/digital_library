import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:private_library/api.dart';
import 'package:private_library/model.dart';

import 'api_test.mocks.dart' as mocks;

@GenerateMocks([http.Client])
void main() {
  group('GoogleBooksAPI', () {
    var isbn = "987654321";
    var url = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: 'books/v1/volumes',
        query: 'q=isbn:$isbn');

    test('should be able to fetch book', () async {
      var title = 'This is a book title';
      var author = 'Author von Authorious';
      var published = 1991;
      var expectedBook = Book(isbn, author, title, published);

      final client = mocks.MockClient();

      var responseBody = {
        "totalItems": 1,
        "items": [
          {
            "volumeInfo": {
              "authors": [author],
              "title": title,
              "publishedDate": '$published'
            },
          }
        ],
      };

      when(client.get(url)).thenAnswer(
        (_) async => http.Response(jsonEncode(responseBody), 200),
      );

      var actualBook = await fetchBookFromGoogle(isbn, client: client);

      expect(actualBook, isA<Book>());
      expect('$actualBook', '$expectedBook');
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

        var actualBook = await fetchBookFromGoogle(isbn, client: client);

        expect(actualBook, null);
      });
    }
  });
}
