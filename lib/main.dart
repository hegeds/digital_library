import 'package:digital_library/database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/create.dart';
import 'pages/home.dart';
import 'pages/library.dart';
import 'pages/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  connectToDatabase().then((db) {
    runApp(MyApp(db));
  });
}

class MyApp extends StatelessWidget {
  final Database db;
  const MyApp(this.db, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => SettingsPage(db),
        '/library': (context) => LibraryPage(db),
        '/add-book': (context) => NewBookPage(db),
      },
    );
  }
}
