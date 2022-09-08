import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/OwnersScreen.dart';
import 'package:app_project/Screens/RequestsScreen.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'AdminScreen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int selectedPage = 0;
  final _pageOption = [DrawerItSelf(), RequestsScreen(),OwnersScreen()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: FancyBottomNavigation(
          barBackgroundColor: Colors.yellow[700],
          circleColor: Colors.blue[900],
          textColor: Colors.black,
          inactiveIconColor: Colors.indigo,
          initialSelection: 0,
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: FontAwesomeIcons.clipboardList, title: "Requests"),
            TabData(iconData: Icons.people, title: "Owners")
          ],
          onTabChangedListener: (position) {
            setState(() {
              selectedPage = position;
            });
          },
        ),
        body: _pageOption[selectedPage],
      ),
    );
  }
}
