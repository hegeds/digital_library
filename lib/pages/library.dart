import 'package:flutter/material.dart';

import 'package:private_library/components/page_layout.dart';
import 'package:private_library/database.dart';
import 'package:private_library/model.dart';
import 'package:private_library/storage.dart';
import 'package:private_library/components/list.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Book> books = [];

  _LibraryPageState() {
    connectToDatabase().then((db) {
      var shelf = SQLiteShelf(db);
      shelf.retrieveBooks().then((value) {
        setState(() {
          books = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Library',
      body: Center(
        child: BookList(books),
      ),
    );
  }
}
