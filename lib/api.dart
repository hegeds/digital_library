import 'dart:convert';

import 'package:http/http.dart' as http;

import './model.dart';

class BookAPI {
  Future<Book?> fetchBook(String isbn) async {
    throw UnimplementedError();
  }
}

class GoogleBooksAPI implements BookAPI {
  final http.Client _client;

  GoogleBooksAPI(this._client);

  @override
  Future<Book?> fetchBook(String isbn) async {
    var url = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: 'books/v1/volumes',
        query: 'q=isbn:$isbn');
    var response = await _client.get(url);
    var body = jsonDecode(response.body);

    if (body['totalItems'] == 1) {
      var volumeInfo = body['items'][0]['volumeInfo'];
      return Book(isbn, volumeInfo['authors'][0], volumeInfo['title'],
          int.parse(volumeInfo['publishedDate']));
    } else {
      return null;
    }
  }
}
