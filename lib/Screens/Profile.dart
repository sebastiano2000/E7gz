import 'dart:developer';
import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/changeEmail.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_project/Screens/welcome.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'changeName.dart';
import 'dart:ui' as ui;
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

class Profile extends StatefulWidget {
  static const String id = 'ProfileScreen';

  static String email = 'Pending';
  static String name = 'Pending';
  static String phoneNumber = 'Pending';
  static String uid;
  static String password;

  static bool isFacebook = false;
  static bool isGoogle = false;

  @override
  _ProfileState createState() =>
      _ProfileState(email, isFacebook, isGoogle, phoneNumber, name, uid, password);
}

class _ProfileState extends State<Profile> {
  String _userId;
  String _email;
  String _name = 'Pending';
  String _phoneNumber = 'Pending';
  String _password;
  bool _isFacebook;
  bool _isGoogle;
  String _oldPassword;
  String _newPassword;

  bool _isSecure = true;
  bool _validate = false;

  TextEditingController _passController = TextEditingController();

  var _changedIcon = Icon(Icons.visibility);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProfileState(this._email, this._isFacebook, this._isGoogle, this._phoneNumber,
      this._name, this._userId, this._password);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Profile'.tr().toString(),
          ),
        ),
        body: AnimationLimiter(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  horizontalOffset: 150,
                  child: FadeInAnimation(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name'.tr().toString(),
                                      style: TextStyle(
                                        fontSize: 19,
                                      ),
                                    ),
                                    Padding(
                                      padding: EasyLocalization.of(context).locale ==
                                              Locale('ar', 'EG')
                                          ? const EdgeInsets.only(left: 270)
                                          : const EdgeInsets.only(left: 250),
                                      child: GestureDetector(
                                        onTap: () {
                                          log(_userId);
                                          ChangeName.uid = _userId;
                                          ChangeName.email = _email;

                                          Navigator.pushNamed(
                                              context, ChangeName.id);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      _name,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone'.tr().toString(),
                                  style: TextStyle(fontSize: 19),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _phoneNumber,
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Email'.tr().toString(),
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    Padding(
                                      padding: EasyLocalization.of(context).locale ==
                                              Locale('ar', 'EG')
                                          ? const EdgeInsets.only(left: 200)
                                          : const EdgeInsets.only(left: 255),
                                      child: GestureDetector(
                                        onTap: () {
                                          ChangeEmail.uid = _userId;
                                          ChangeEmail.email = _email;
                                          ChangeEmail.password = _password;

                                          log(_userId);

                                          Navigator.pushNamed(
                                              context, ChangeEmail.id);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      _email,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 45, right: 45),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'ChangePassword'.tr().toString(),
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('OldPassword'.tr().toString()),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              LTextField(
                                                icon: Icons.lock,
                                                keyboardType:
                                                    TextInputType.visiblePassword,
                                                isSecured: _isSecure,
                                                endIcon: IconButton(
                                                    icon: _changedIcon,
                                                    color: Colors.purple[900],
                                                    onPressed: () {
                                                      if (_isSecure) {
                                                        setState(() {
                                                          _isSecure = false;
                                                          _changedIcon = Icon(
                                                              Icons.visibility_off);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _isSecure = true;
                                                          _changedIcon =
                                                              Icon(Icons.visibility);
                                                        });
                                                      }
                                                    }),
                                                hintText:
                                                    'OldPassword'.tr().toString(),
                                                maxLength: 20,
                                                validator:
                                                    Validations().passwordValidator,
                                                onChanged: (String value) =>
                                                    _oldPassword = value,
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Text(
                                                'NewPassword'.tr().toString(),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              LTextField(
                                                icon: Icons.lock,
                                                keyboardType:
                                                    TextInputType.visiblePassword,
                                                isSecured: _isSecure,
                                                endIcon: IconButton(
                                                    icon: _changedIcon,
                                                    color: Colors.purple[900],
                                                    onPressed: () {
                                                      if (_isSecure) {
                                                        setState(() {
                                                          _isSecure = false;
                                                          _changedIcon = Icon(
                                                              Icons.visibility_off);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _isSecure = true;
                                                          _changedIcon =
                                                              Icon(Icons.visibility);
                                                        });
                                                      }
                                                    }),
                                                hintText:
                                                    'NewPassword'.tr().toString(),
                                                maxLength: 20,
                                                validator:
                                                    Validations().passwordValidator,
                                                onChanged: (String value) =>
                                                    _newPassword = value,
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Text(
                                                'Confirm NewPassword'
                                                    .tr()
                                                    .toString(),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              LTextField(
                                                icon: Icons.lock,
                                                keyboardType:
                                                    TextInputType.visiblePassword,
                                                isSecured: _isSecure,
                                                endIcon: IconButton(
                                                    icon: _changedIcon,
                                                    color: Colors.purple[900],
                                                    onPressed: () {
                                                      if (_isSecure) {
                                                        setState(() {
                                                          _isSecure = false;
                                                          _changedIcon = Icon(
                                                              Icons.visibility_off);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _isSecure = true;
                                                          _changedIcon =
                                                              Icon(Icons.visibility);
                                                        });
                                                      }
                                                    }),
                                                hintText: 'Confirm NewPassword1'
                                                    .tr()
                                                    .toString(),
                                                maxLength: 20,
                                                validator: (val) => MatchValidator(
                                                        errorText:
                                                            'passwords do not match'
                                                                .tr()
                                                                .toString())
                                                    .validateMatch(
                                                        val, _newPassword),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          loadingButtons(
                                            loadingType: SpinKitWanderingCubes(
                                              color: Colors.white,
                                            ),
                                            text: 'Confirm'.tr().toString(),
                                            width: 200,
                                            height: 40,
                                            textColor: Colors.white,
                                            onTap: (startLoading, stopLoading,
                                                btnState) async {
                                              startLoading();

                                              if (_oldPassword
                                                      .compareTo(_password) ==
                                                  0) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                prefs.setString(
                                                    'password', _newPassword);

                                                setState(() {
                                                  DashBoard.isReset = true;
                                                  DashBoard.newPassword =
                                                      _newPassword;
                                                  Navigator.pushReplacementNamed(
                                                      context, DrawerItSelf.id);
                                                });
                                              } else {
                                                Navigator.pop(context);
                                                showSnackBar(
                                                        _scaffoldKey,
                                                        'Old Password is Wrong'
                                                            .tr()
                                                            .toString())
                                                    .show();
                                              }
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'Change Password'.tr().toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20),
                            child: GestureDetector(
                              onTap: () async {
                                if (_isFacebook)
                                  await AuthServices().signOutFacebook();
                                else if (_isGoogle)
                                  await AuthServices().signOutGoogle();
                                else
                                  await AuthServices().signOutOfFirebase();

                                Navigator.pushReplacementNamed(
                                    context, WelcomeScreen.id);
                              },
                              child: Text(
                                'Signout'.tr().toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
