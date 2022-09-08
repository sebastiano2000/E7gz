import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: camel_case_types
class theme extends StatefulWidget {
  static const String id = 'ThemeScreen';

  @override
  _themeState createState() => _themeState();
}

class _themeState extends State<theme> {
  bool _switchState = false;
  @override
  void initState() {
    super.initState();
    DynamicTheme.of(context).brightness == Brightness.dark
        ? _switchState = true
        : _switchState = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Themes'.tr().toString(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Text(
                  'Dark Theme'.tr().toString(),
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 100,
                ),
                Switch(
                  value: _switchState,
                  onChanged: (_newValue) {
                    _switchState = _newValue;

                    changeBrightness();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }
}
