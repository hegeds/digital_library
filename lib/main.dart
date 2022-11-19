import 'package:flutter/material.dart';
import 'package:private_library/pages/library.dart';
import 'package:private_library/pages/settings.dart';

import 'pages/home.dart';
import 'pages/settings.dart';

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
