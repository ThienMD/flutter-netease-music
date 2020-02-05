import 'package:flutter/material.dart';
import 'package:quiet/component/global/settings.dart';

import 'material.dart';

class SettingThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Theme settings")),
      body: ListView(
        children: <Widget>[
          SettingGroup(
            title: "Theme mode",
            children: <Widget>[
              RadioListTile<ThemeMode>(
                onChanged: (mode) => context.settings.themeMode = mode,
                groupValue: context.settings.themeMode,
                value: ThemeMode.system,
                title: Text("Follow system"),
              ),
              RadioListTile<ThemeMode>(
                onChanged: (mode) => context.settings.themeMode = mode,
                groupValue: context.settings.themeMode,
                value: ThemeMode.light,
                title: Text("Bright theme"),
              ),
              RadioListTile<ThemeMode>(
                onChanged: (mode) => context.settings.themeMode = mode,
                groupValue: context.settings.themeMode,
                value: ThemeMode.dark,
                title: Text("Dark theme"),
              )
            ],
          ),
          if (context.settings.themeMode == ThemeMode.dark) _DarkThemeSwitchGroup() else _LightThemeSwitchGroup(),
        ],
      ),
    );
  }
}

class _DarkThemeSwitchGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingGroup(title: 'Dark color theme selection', children: [
      RadioListTile(
        onChanged: null,
        groupValue: null,
        value: null,
        selected: true,
        title: Container(color: context.settings.darkTheme.primaryColor, height: 20),
      )
    ]);
  }
}

class _LightThemeSwitchGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingGroup(
      title: "Bright theme color selection",
      children: <Widget>[...quietThemes.map((theme) => _RadioLightThemeTile(themeData: theme))],
    );
  }
}

class _RadioLightThemeTile extends StatelessWidget {
  final ThemeData themeData;

  const _RadioLightThemeTile({Key key, @required this.themeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeData>(
      value: themeData,
      groupValue: context.settings.theme,
      onChanged: (theme) => context.settings.theme = theme,
      activeColor: themeData.primaryColor,
      title: Container(color: themeData.primaryColor, height: 20),
    );
  }
}
