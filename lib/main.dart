import 'package:flutter/material.dart';
import 'package:private_library/library.dart';
import 'package:private_library/settings.dart';

import './home.dart';
import './settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/settings': (context) => const SettingsPage(),
        '/library': (context) => const LibraryPage(),
      },
    );
  }
}
