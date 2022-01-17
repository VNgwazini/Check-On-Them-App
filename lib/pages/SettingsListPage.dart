import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';


class SettingsListPage extends StatefulWidget {
  SettingsListPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _SettingsListPageState createState() => _SettingsListPageState();
}



class _SettingsListPageState extends State<SettingsListPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        //ToDo: Add list of languages
        SettingsSection(
          title: Text('System Settings'),
          tiles: [
            SettingsTile(
              title: Text('Language'),
              value: Text('English'),
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {},
            ),
          ],
        ),
        SettingsSection(
          //ToDo: switch is reset on page load, not persistent
          title: Text('Appearance'),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.phone_android),
              onToggle: (value) {
                setState(() {
                  isSwitched = value;
                });
              },initialValue: isSwitched,
            ),
          ],
        ),
        SettingsSection(
          title: Text('Message'),
          tiles: [
            SettingsTile(
              title: Text('Preset'),
              value: Text('Crossed My Mind'),
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {},
            ),
          ],
        ),
      ],
    );
  }
}
