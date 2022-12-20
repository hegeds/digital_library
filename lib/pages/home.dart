import 'package:flutter/material.dart';
import 'package:private_library/components/home_card.dart';
import '../components/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            children: const [
              HomeCard(
                  iconData: Icons.create,
                  text: 'Add new book',
                  route: '/add-book'),
              HomeCard(
                  iconData: Icons.library_books,
                  text: 'Open your library',
                  route: '/library'),
              HomeCard(
                  iconData: Icons.settings,
                  text: 'Open Settings',
                  route: '/settings')
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-book');
        },
        tooltip: 'Add book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
