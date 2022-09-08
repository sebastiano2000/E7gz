import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:app_project/Screens/FeedBack.dart';
import 'package:app_project/Screens/Settings.dart';
import 'package:app_project/Screens/TestScreen.dart';
import 'package:app_project/Screens/confirmation.dart';
import 'package:app_project/Screens/createOwner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'package:app_project/Components/Constants.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerCaller extends StatefulWidget {
  static const String id = 'CallerDrawerScreen';

  static String photoUrl;

  final Function closeDrawer;

  const DrawerCaller({Key key, this.closeDrawer}) : super(key: key);

  @override
  _DrawerCallerState createState() => _DrawerCallerState(closeDrawer, photoUrl);
}

class _DrawerCallerState extends State<DrawerCaller> {
  String _photoUrl;
  String _imagePath;
  var _tempPhoto;

  _DrawerCallerState(this._closeDrawer, this._photoUrl);

  final Function _closeDrawer;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        _image = File(pickedFile.path);
      });

      saveImage(_image.path);
    } catch (e) {
      log('cancelled by user');
    }
  }

  Future saveImage(path) async {
    SharedPreferences _savedImage = await SharedPreferences.getInstance();
    _savedImage.setString('ImagePath', path);
  }

  Future loadImage() async {
    SharedPreferences _savedImage = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = _savedImage.getString('ImagePath');
    });
  }

  ImageProvider showImage() {
    if (_photoUrl == null)
      _tempPhoto = AssetImage('assets/images/avatar.jpg');
    else {
      if (_photoUrl.compareTo('assets/images/avatar.jpg') == 0)
        _tempPhoto = AssetImage(_photoUrl);
      else
        _tempPhoto = NetworkImage(_photoUrl);
    }

    return _tempPhoto;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 60,
              ),
              _imagePath != null
                  ? GestureDetector(
                      onTap: getImage,
                      behavior: HitTestBehavior.opaque,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: FileImage(File(_imagePath)),
                      ),
                    )
                  : GestureDetector(
                      onTap: getImage,
                      behavior: HitTestBehavior.opaque,
                      child: CircleAvatar(
                        child: _image == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.black,
                              )
                            : Text(''),
                        radius: 65,
                        backgroundImage:
                            _image == null ? showImage() : FileImage(_image),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          DrawerButtons(
            icon: Icons.home,
            text: 'Home'.tr().toString(),
            func: () {
              _closeDrawer();
            },
          ),
          DrawerButtons(
            icon: Icons.person,
            text: 'Profile'.tr().toString(),
            func: () {
              _closeDrawer();
              Navigator.pushNamed(context, Profile.id);
            },
          ),
          DrawerButtons(
            icon: Icons.settings,
            text: 'Settings'.tr().toString(),
            func: () {
              Navigator.pushNamed(context, Settings.id);
              _closeDrawer();
            },
          ),
          SizedBox(
            height: 80,
          ),
          DrawerButtons(
            icon: Icons.bookmark,
            text: 'FeedBack'.tr().toString(),
            func: () {
              Navigator.pushNamed(context, FeedBack.id);
              _closeDrawer();
            },
          ),
          DrawerButtons(
            icon: Icons.error,
            text: 'Privacy'.tr().toString(),
          ),
          DrawerButtons(
            icon: Icons.code,
            text: 'Become an Owner'.tr().toString(),
            func: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              bool _isPending = prefs.getBool('pendingScreen');

              if (_isPending == null) {
                Navigator.pushNamed(context, CreateOwner.id);
                _closeDrawer();
              } else if (_isPending) {
                Navigator.pushNamed(context, ConfirmationScreen.id);
                _closeDrawer();
              }
            },
          ),
        ],
      ),
    );
  }
}
