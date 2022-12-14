import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';

import 'package:digital_library/components/page_layout.dart';
import 'package:digital_library/api.dart';
import 'package:digital_library/model.dart';
import 'package:digital_library/database.dart';
import 'package:digital_library/storage.dart';

class NewBookPage extends StatefulWidget {
  const NewBookPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewBookPAgeState();
}

class _NewBookPAgeState extends State<NewBookPage> {
  _NewBookPAgeState() {
    formControllers = {
      'isbn': TextEditingController(),
      'author': TextEditingController(),
      'title': TextEditingController(),
      'published': TextEditingController(),
    };
  }

  Map<String, TextEditingController> formControllers = {};

  @override
  void dispose() {
    for (var controller in formControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _scanBarcode() async {
    var barCode = await FlutterBarcodeScanner.scanBarcode(
        'blue', 'cancel', true, ScanMode.BARCODE);

    var fetchedBook = await fetchBookFromGoogle(barCode);
    if (fetchedBook != null) {
      setState(() {
        formControllers['isbn']!.text = fetchedBook.isbn;
        formControllers['author']!.text = fetchedBook.author;
        formControllers['title']!.text = fetchedBook.title;
        formControllers['published']!.text = fetchedBook.published.toString();
      });
    }
  }

  void _createBook() async {
    Book book = Book(
        formControllers['isbn']!.text,
        formControllers['author']!.text,
        formControllers['title']!.text,
        int.parse(formControllers['published']!.text));
    Database db = await connectToDatabase();
    await SQLiteShelf(db).addBook(book);

    for (var controller in formControllers.values) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Add new book',
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Scan book',
        child: const Icon(Icons.camera),
      ),
      body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(label: Text('ISBN number')),
                controller: formControllers['isbn'],
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(label: Text('Author')),
                controller: formControllers['author'],
              ),
              TextField(
                decoration: const InputDecoration(label: Text('Title')),
                controller: formControllers['title'],
              ),
              TextField(
                decoration:
                    const InputDecoration(label: Text('Year of publish')),
                controller: formControllers['published'],
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                  onPressed: () => {_createBook()}, child: const Text('Save')),
            ],
          )),
    );
  }
}
