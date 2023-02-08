import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

/// "Activity" for Settings.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: "Preferences",
        children: <Widget>[
          SettingsGroup(title: "Personal Info",
            children: [
              TextInputSettingsTile(
                title: "Your name",
                settingKey: 'key_name',
                keyboardType: TextInputType.name,
                onChange: (v) => changed = true,
                validator: (instrName) {
                  if (instrName != null && instrName.isNotEmpty) {
                    return null;
                  }
                  return "Name is required";
                },
                errorColor: Colors.redAccent,
              ),
              DropDownSettingsTile<String>(
                title: 'Theme Color',
                settingKey: 'key-theme-color',
                values: const <String, String>{
                  'orange': 'Orange',
                  'green': 'Green',
                  'blue': 'Blue',
                },
                selected: 'orange',
                onChange: (v) => changed = true,
              ),
              SwitchSettingsTile(
                  title: "Dark mode",
                  leading: const Icon(Icons.dark_mode),
                  settingKey: 'key_dark_mode',
                  onChange: (v) => changed = true,
                  )
            ],
          ),
          Center(child: ElevatedButton(
              child: const Text('Done'),
              onPressed: () async {
                if (changed) {
                  await alert(context, "Change will take effect on app restart",
                      title:'Settings Changed');
                }
                Navigator.of(context).pop();
                },
            ),
          )
        ]
    );
  }

  @override
  void dispose() {
    // Do we need anything here?
    super.dispose();
  }
}

/// Standalone method for showing an alert dialog
alert(BuildContext context, String message, {title = 'Serious Error'}) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
  );
}
