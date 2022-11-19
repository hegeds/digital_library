import 'package:flutter/material.dart';

import '../components/navbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: NavDrawer(
        context: context,
      ),
      body: const Center(
        child: null,
      ),
    );
  }
}
