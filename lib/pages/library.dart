import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:digital_library/components/page_layout.dart';
import 'package:digital_library/database.dart';
import 'package:digital_library/exporter.dart';
import 'package:digital_library/model.dart';
import 'package:digital_library/storage.dart';
import 'package:digital_library/components/list.dart';

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

  Future<void> _downloadLibrary() async {
    var excelLocation = await generateLibraryExport(books);
    OpenFile.open(excelLocation);
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Library',
      body: Center(
        child: BookList(books),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadLibrary,
        tooltip: 'Download library',
        child: const Icon(Icons.download),
      ),
    );
  }
}
