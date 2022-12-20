import 'package:flutter/material.dart';
import 'package:private_library/model.dart';

class BookList extends StatelessWidget {
  final List<Book> books;
  const BookList(this.books, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            books.length,
            (index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(books[index].title[0]),
                ),
                title: Text(books[index].title),
                subtitle: Text(books[index].author),
                trailing: const Icon(Icons.info_outline))));
  }
}
