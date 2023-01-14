import 'package:test/test.dart';

import 'package:digital_library/model.dart';

void main() {
  var isbn = "987654321";
  var title = 'This is a book title';
  var author = 'Author von Authorious';
  var published = 1991;

  test('should be able to create Books', () {
    var book = Book(isbn, [author], title, published);

    expect(book.isbn, isbn);
    expect(book.title, title);
    expect(book.authors, [author]);
    expect(book.published, published);
  });

  test('should print out details when converted to string', () {
    var book = Book(isbn, [author], title, published);
    var expectedString =
        '$isbn - Authors: $author; Title: $title; Published: $published';

    expect('$book', expectedString);
  });

  test('should be able to tranform to map', () {
    var book = Book(isbn, [author], title, published);
    var expectedBookMap = {
      'isbn': isbn,
      'authors': author,
      'title': title,
      'published': published
    };

    expect(book.toMap(), expectedBookMap);
  });
}
