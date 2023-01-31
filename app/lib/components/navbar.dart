import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  static const pages = ['/', '/add-book', '/library', '/settings'];
  final String currentRoute;

  const Navbar(this.currentRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: pages.indexOf(currentRoute),
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          Navigator.pushNamed(context, pages[index]);
        });
  }
}
