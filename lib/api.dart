import 'dart:convert';

import 'package:http/http.dart';

import './model.dart';

Future<Book?> fetchBookFromGoogle(String isbn, {Client? client}) async {
  client ??= Client();

  var url = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'books/v1/volumes',
      query: 'q=isbn:$isbn');
  var response = await client.get(url);
  var body = jsonDecode(response.body);

  if (body['totalItems'] == 1) {
    var volumeInfo = body['items'][0]['volumeInfo'];
    String publishedInfo = volumeInfo['publishedDate'];
    var publishedYear = publishedInfo.split("-")[0];
    return Book(isbn, volumeInfo['authors'][0], volumeInfo['title'],
        int.parse(publishedYear));
  } else {
    return null;
  }
}
