class Book {
  List<String> authors = [];
  String title = '';
  String isbn = '';
  int published = 0;

  @override
  String toString() {
    return '$isbn - Authors: ${getAuthorsAsString()}; Title: $title; Published: $published';
  }

  Book(this.isbn, this.authors, this.title, this.published);

  String getAuthorsAsString() {
    return authors.join(';');
  }

  Map<String, dynamic> toMap() {
    return {
      'authors': getAuthorsAsString(),
      'title': title,
      'isbn': isbn,
      'published': published
    };
  }
}
