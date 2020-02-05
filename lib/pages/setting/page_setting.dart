import 'package:flutter/material.dart';
import 'package:quiet/component/global/settings.dart';
import 'package:quiet/component/route.dart';

import 'material.dart';

export 'setting_theme_page.dart';

///App 设置页面
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set up'),
        titleSpacing: 0,
      ),
      body: ListView(
        children: <Widget>[
          SettingGroup(
            title: 'Universal',
            children: <Widget>[
              ListTile(
                title: Text('Change theme'),
                onTap: () => Navigator.pushNamed(context, ROUTE_SETTING_THEME),
              ),
              _CopyRightCheckBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyRightCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: Settings.of(context).showCopyrightOverlay,
      onChanged: (value) {
        Settings.of(context).showCopyrightOverlay = value;
      },
      title: Text('Hide copyright floating layer'),
    );
  }
}
