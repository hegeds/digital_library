import 'package:flutter/material.dart';

import 'package:digital_library/components/page_layout.dart';
import 'package:digital_library/database.dart';
import 'package:digital_library/storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ConfigStore configStore;
  List<String> enabledAPIs = [];

  _SettingsPageState() {
    connectToDatabase().then((db) {
      configStore = SQLiteConfigStore(db);

      configStore.retrieveConfig('enabledAPIs').then((fetchedAPIs) {
        setState(() {
          enabledAPIs = List<String>.from(fetchedAPIs);
        });
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
          )
        ],
      ),
    );
  }
}
