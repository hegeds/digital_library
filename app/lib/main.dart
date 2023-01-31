import 'package:digital_library/database.dart';
import 'package:digital_library/pages/detail.dart';
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
      onGenerateRoute: (settings) {
        var routes = <String, WidgetBuilder>{
          '/': (context) => const HomePage(),
          '/settings': (context) => SettingsPage(db),
          '/library': (context) => LibraryPage(db),
          '/library/detail': (context) =>
              BookDetail(db, (settings.arguments as List<String>)[0]),
          '/add-book': (context) => NewBookPage(db),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}
