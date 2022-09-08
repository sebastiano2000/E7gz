import 'package:app_project/Screens/language.dart';
import 'package:app_project/Screens/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Settings extends StatelessWidget {
  static const String id = 'SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr().toString()),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 700),
                    child: SlideAnimation(
                      horizontalOffset: 150,
                      child: FadeInAnimation(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.palette,
                                    size: 30,
                                  ),
                                  title: Text(
                                    'Change Theme'.tr().toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.pushNamed(context, theme.id);
                                  },
                                ),
                              ),
                              Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.g_translate,
                                    size: 30,
                                  ),
                                  title: Text(
                                    'Language'.tr().toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, LanguageTranslator.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              })),
    );
  }
}
