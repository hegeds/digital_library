import 'package:flutter/material.dart';

class NavDrawer extends Drawer {
  final BuildContext context;

  NavDrawer({Key? key, required this.context})
      : super(
            key: key,
            child: ListView(
              children: [
                const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Menu')),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ));
}
