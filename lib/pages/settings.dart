import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:digital_library/components/page_layout.dart';
import 'package:digital_library/storage.dart';

class SettingsPage extends StatefulWidget {
  final Database db;

  const SettingsPage(this.db, {Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ConfigStore configStore;
  List<String> enabledAPIs = [];

  @override
  void initState() {
    super.initState();
    configStore = SQLiteConfigStore(widget.db);

    configStore.retrieveConfig('enabledAPIs').then((fetchedAPIs) {
      setState(() {
        enabledAPIs = List<String>.from(fetchedAPIs);
      });
    });
  }

  Future<void> modifyAPIs(String apiName, bool? isActive) async {
    setState(() {
      if (enabledAPIs.contains(apiName) && !isActive!) {
        enabledAPIs.remove(apiName);
      }

      if (!enabledAPIs.contains(apiName) && isActive!) {
        enabledAPIs.add(apiName);
      }
    });
    await configStore.saveConfig('enabledAPIs', enabledAPIs);
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Settings',
      page: '/settings',
      body: Column(
        children: [
          const ListTile(
            title: Text('API configuration'),
            textColor: Colors.blue,
          ),
          CheckboxListTile(
            title: const Text('Enable google API'),
            onChanged: (bool? value) {
              modifyAPIs('google', value);
            },
            value: enabledAPIs.contains('google'),
          ),
          CheckboxListTile(
            title: const Text('Enable Open Library API'),
            onChanged: (bool? value) {
              modifyAPIs('open-library', value);
            },
            value: enabledAPIs.contains('open-library'),
          )
        ],
      ),
    );
  }
}
