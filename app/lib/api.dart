import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import './model.dart';

typedef FetchBook = Future<Book?> Function(String isbn);

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
    var authors = List<String>.from(volumeInfo['authors']);
    return Book(isbn, authors, volumeInfo['title'], int.parse(publishedYear));
  } else {
    return null;
  }
}

Future<Book?> fetchBookFromOpenLibrary(String isbn, {Client? client}) async {
  client ??= Client();

  var url = Uri(
    scheme: 'https',
    host: 'www.openlibrary.org',
    path: '/isbn/$isbn.json',
  );
  var response = await client.get(url);
  if (response.statusCode == HttpStatus.notFound) {
    return null;
  }

  var body = jsonDecode(response.body);
  var title = body['title'];
  var publishedYear = body['publish_date'].split(" ")[2];
  var authorReferences = List<Map<String, dynamic>>.from(body['authors']);

  List<String> authors = [];
  for (var authorReference in authorReferences) {
    authors
        .add(await fetchAuthorFromOpenLibrary(authorReference['key']!, client));
  }

  return Book(isbn, authors, title, int.parse(publishedYear));
}

Future<String> fetchAuthorFromOpenLibrary(String key, Client client) async {
  var url = Uri(
    scheme: 'https',
    host: 'www.openlibrary.org',
    path: '$key.json',
  );
  var response = await client.get(url);
  var body = jsonDecode(response.body);
  return body['personal_name'];
}
