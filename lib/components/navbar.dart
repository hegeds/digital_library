import 'package:flutter/material.dart';

class NavDrawer extends Drawer {
  final BuildContext context;

  NavDrawer({Key? key, required this.context})
      : super(
            key: key,
            child: ListView(
              primary: true,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.library_books),
                  title: const Text('Library'),
                  onTap: () {
                    Navigator.pushNamed(context, '/library');
                  },
                ),
              ],
            ));
}
