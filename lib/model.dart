class Book {
  String author = '';
  String title = '';
  String isbn = '';
  int published = 0;

  @override
  String toString() {
    return '$isbn - Author: $author; Title: $title; Published: $published';
  }

  Book(this.isbn, this.author, this.title, this.published);

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'isbn': isbn,
      'published': published
    };
  }
}
