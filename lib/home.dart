import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:private_library/database.dart';
import 'package:private_library/model.dart';
import 'package:private_library/storage.dart';
import 'package:sqflite/sqlite_api.dart';

import './api.dart';
import './navbar.dart';
import 'book/list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Book? book;

  void _scanBarcode() async {
    var barCode = await FlutterBarcodeScanner.scanBarcode(
        'blue', 'cancel', true, ScanMode.BARCODE);

    var fetchedBook = await fetchBookFromGoogle(barCode);

    if (fetchedBook is Book) {
      Database db = await connectToDatabase();
      await SQLiteShelf(db).addBook(fetchedBook);
    }
    setState(() {
      book = fetchedBook;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: NavDrawer(
        context: context,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          LayoutBuilder(
            builder: ((context, constraints) {
              if (book != null) {
                return BookList([book as Book]);
              } else {
                return const Text('No book');
              }
            }),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
