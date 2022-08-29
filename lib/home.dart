import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import './api.dart';
import './navbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String bookDetails = "";

  void _scanBarcode() async {
    var barCode = await FlutterBarcodeScanner.scanBarcode(
        'blue', 'cancel', true, ScanMode.BARCODE);

    var book = await fetchBookFromGoogle(barCode);
    setState(() {
      bookDetails = book.toString();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              bookDetails,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
