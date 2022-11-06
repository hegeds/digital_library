import 'package:flutter/material.dart';
import 'package:private_library/database.dart';
import 'package:private_library/model.dart';
import 'package:private_library/storage.dart';

import './navbar.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      drawer: NavDrawer(
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              books.length, (index) => Text(books[index].toString())),
        ),
      ),
    );
  }
}
