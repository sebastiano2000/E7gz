import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:app_project/Screens/drawerCaller.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

class DrawerItSelf extends StatefulWidget {
  static const String id = 'SelfDrawerScreen';

  @override
  _State createState() => _State();
}

class _State extends State<DrawerItSelf> {
  FSBStatus status;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        body: SwipeDetector(
          onSwipeRight: () {
            setState(() {
              status = FSBStatus.FSB_OPEN;
            });
          },
          onSwipeLeft: () {
            setState(() {
              status = FSBStatus.FSB_CLOSE;
            });
          },
          child: FoldableSidebarBuilder(
            drawerBackgroundColor: Colors.purple.shade900,
            status: status,
            drawer: DrawerCaller(
              closeDrawer: () {
                setState(() {
                  status = FSBStatus.FSB_CLOSE;
                });
              },
            ),
            screenContents: DashBoard(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 10,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  // Colors.pink[500],
                  // Colors.pink[700],
                  // Colors.redAccent,
                  // Colors.pink[500],
                  // Colors.red[600],
                  // Colors.red[700],
                  // Colors.pink[800],
                  // Colors.red[900],
                  // Colors.black,
                  Colors.blue[500],
                  Colors.blue[700],
                  Colors.blueAccent,
                  Colors.blue[500],
                  Colors.indigoAccent,
                  Colors.blue[800],
                  Colors.indigoAccent,
                ],
              ),
            ),
          ),
          centerTitle: true,

          title: SizedBox(
            width: 250.0,
            child: TypewriterAnimatedTextKit(
                text: [
                  "E7GZ",
                ],
                textStyle: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Pacifico',
                ),
                speed: Duration(seconds: 5),
                textAlign: TextAlign.center,
                alignment: AlignmentDirectional.topCenter // or Alignment.topLeft
                ),
          ),
          // title: Text(
          //   'app_bar'.tr().toString(),
          //   style: TextStyle(
          //     fontSize: 30,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                status = status == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              });
            },
          ),
        ),
      ),
    );
  }
}
