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
  State<StatefulWidget> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> {
  var isbnController = TextEditingController();
  var titleController = TextEditingController();
  var publishYearController = TextEditingController();
  var authorControllers = [TextEditingController()];

  List<String> enabledAPIs = [];
  Map<String, FetchBook> apiByName = {
    'google': fetchBookFromGoogle,
  };

  _NewBookPageState() {
    connectToDatabase().then((db) {
      var configStore = SQLiteConfigStore(db);
      configStore.retrieveConfig('enabledAPIs').then((fetchedAPIs) {
        enabledAPIs = List<String>.from(fetchedAPIs);
      });
    });
  }

  @override
  void dispose() {
    isbnController.dispose();
    titleController.dispose();
    publishYearController.dispose();

    for (var controller in authorControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<Book?> _getBookFromAPIs(String isbn) async {
    Book? fetchedBook;
    for (var apiName in enabledAPIs) {
      var api = apiByName[apiName];
      if (api == null) return null;

      fetchedBook = await api(isbn);
      if (fetchedBook != null) break;
    }

    return fetchedBook;
  }

  void _scanBarcode() async {
    var barCode = await FlutterBarcodeScanner.scanBarcode(
        'blue', 'cancel', true, ScanMode.BARCODE);

    var fetchedBook = await _getBookFromAPIs(barCode);
    setState(() {
      if (fetchedBook != null) {
        isbnController.text = fetchedBook.isbn;
        titleController.text = fetchedBook.title;
        publishYearController.text = '${fetchedBook.published}';

        authorControllers = fetchedBook.authors
            .map((author) => TextEditingController(text: author))
            .toList();
      }
    });
  }

  void _createBook() async {
    Book book = Book(
        isbnController.text,
        authorControllers.map((controller) => controller.text).toList(),
        titleController.text,
        int.parse(publishYearController.text));
    Database db = await connectToDatabase();
    await SQLiteShelf(db).addBook(book);

    isbnController.clear();
    titleController.clear();
    publishYearController.clear();
    for (var controller in authorControllers) {
      controller.clear();
    }
  }

  void _removeAuthorInput(TextEditingController controller) {
    setState(() {
      authorControllers.remove(controller);
    });
  }

  void _addNewAuthorInput() {
    setState(() {
      authorControllers.add(TextEditingController());
    });
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
          child: ListView(
            children: [
              TextField(
                decoration: const InputDecoration(label: Text('ISBN number')),
                controller: isbnController,
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(label: Text('Title')),
                controller: titleController,
              ),
              TextField(
                decoration:
                    const InputDecoration(label: Text('Year of publish')),
                controller: publishYearController,
                keyboardType: TextInputType.number,
              ),
              ...List<Widget>.from(authorControllers.map((controller) {
                return Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      decoration: const InputDecoration(label: Text('Author')),
                      controller: controller,
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.bottomRight,
                      iconSize: 30,
                      onPressed: () {
                        _removeAuthorInput(controller);
                      },
                      icon: const Icon(Icons.remove_circle))
                ]);
              })),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: const Text(
                      style: TextStyle(fontSize: 16.0),
                      'Add author',
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.bottomRight,
                      iconSize: 30,
                      onPressed: () {
                        _addNewAuthorInput();
                      },
                      icon: const Icon(Icons.add_circle)),
                ],
              ),
              ElevatedButton(
                  onPressed: () => {_createBook()}, child: const Text('Save')),
            ],
          )),
    );
  }
}
