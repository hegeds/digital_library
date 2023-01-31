import 'package:flutter/material.dart';

import './navbar.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final String page;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const PageLayout(
      {Key? key,
      required this.title,
      required this.body,
      required this.page,
      this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: Navbar(page),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
