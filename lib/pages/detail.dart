import 'package:flutter/material.dart';

import 'package:digital_library/components/page_layout.dart';
import 'package:digital_library/model.dart';
import 'package:digital_library/storage.dart';
import 'package:sqflite/sqflite.dart';

class BookDetail extends StatefulWidget {
  final Database db;
  final String isbn;

  const BookDetail(this.db, this.isbn, {Key? key}) : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Book? book;

  @override
  void initState() {
    super.initState();

    var shelf = SQLiteShelf(widget.db);
    shelf.retrieveBook(widget.isbn).then((value) {
      setState(() {
        book = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: book?.title ?? '',
      page: '/library',
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(children: [
          ListTile(
            title: const Text(
              'ISBN',
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: Text(
              book?.isbn ?? '',
            ),
          ),
          ListTile(
            title: const Text(
              'Author(s)',
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: Text(
              book?.getAuthorsAsString() ?? '',
            ),
          ),
          ListTile(
            title: const Text(
              'Publish year',
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: Text(
              book?.published.toString() ?? '',
            ),
          ),
        ]),
      )),
    );
  }
}
