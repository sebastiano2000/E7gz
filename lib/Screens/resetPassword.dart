import 'dart:math';

import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/FadeAnimation.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'ResetPassword';

  static String userEmail;

  @override
  _ResetPasswordState createState() => _ResetPasswordState(userEmail);
}

class _ResetPasswordState extends State<ResetPassword> {
  int index = 0;

  bool showSpinner = false;

  String _password;

  bool _isSecure = true;

  var _changedIcon = Icon(Icons.visibility);

  String _userEmail;

  _ResetPasswordState(this._userEmail);

  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Random random = new Random();
  final _colors = [
    Colors.blue.shade200,
    Colors.blue.shade300,
    Colors.blue.shade400,
    Colors.blue.shade500,
    Colors.cyan.shade300,
    Colors.cyan.shade400,
    Colors.cyan.shade500,
  ];

  @override
  void initState() {
    super.initState();

    _passController.addListener(() {
      setState(() {
        updateColors();
      });
    });

    _confirmController.addListener(() {
      setState(() {
        updateColors();
      });
    });
  }

  updateColors() {
    // For random color change, use this
    index = random.nextInt(_colors.length - 1);

    // If you like a color train, use this instead
    // rotateColors(_colors);
  }

  rotateColors(List<Color> arr) {
    var last = arr[arr.length - 1];
    for (var i = arr.length - 1; i > 0; i--) {
      arr[i] = arr[i - 1];
    }
    arr[0] = last;
  }

  @override
  void dispose() {
    _confirmController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.05;
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.blue,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 0.5,
            progressIndicator: Lottie.asset('assets/indicator.json',
                height: 100, fit: BoxFit.cover, animate: true, repeat: true),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/resetbackground.jpeg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(60)),
                            gradient: LinearGradient(
                                colors: [_colors[index], _colors[index + 1]]),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height,
                                    ),
                                    FadeAnimation(
                                      1,
                                      LTextField(
                                        icon: Icons.lock,
                                        isSecured: _isSecure,
                                        hintText:
                                            'Enter your Password'.tr().toString(),
                                        labelText: 'Password'.tr().toString(),
                                        keyboardType: TextInputType.visiblePassword,
                                        maxLength: 20,
                                        validator: Validations().passwordValidator,
                                        onChanged: (String value) =>
                                            _password = value,
                                        controller: _passController,
                                        endIcon: IconButton(
                                          icon: _changedIcon,
                                          onPressed: () {
                                            if (_isSecure) {
                                              setState(() {
                                                _isSecure = false;
                                                _changedIcon =
                                                    Icon(Icons.visibility_off);
                                              });
                                            } else {
                                              setState(() {
                                                _isSecure = true;
                                                _changedIcon =
                                                    Icon(Icons.visibility);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FadeAnimation(
                                      1.3,
                                      LTextField(
                                          icon: Icons.lock,
                                          isSecured: _isSecure,
                                          hintText:
                                              'Enter your Password'.tr().toString(),
                                          labelText:
                                              'ConfirmPassword'.tr().toString(),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          maxLength: 20,
                                          validator: (val) => MatchValidator(
                                                errorText: 'passwords do not match'
                                                    .tr()
                                                    .toString(),
                                              ).validateMatch(val, _password),
                                          controller: _confirmController,
                                          endIcon: IconButton(
                                              icon: _changedIcon,
                                              onPressed: () {
                                                if (_isSecure) {
                                                  setState(() {
                                                    _isSecure = false;
                                                    _changedIcon =
                                                        Icon(Icons.visibility_off);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isSecure = true;
                                                    _changedIcon =
                                                        Icon(Icons.visibility);
                                                  });
                                                }
                                              })),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    loadingButtons(
                                        loadingType: SpinKitDualRing(
                                          color: Colors.white,
                                        ),
                                        width: 350,
                                        textColor: Colors.white,
                                        text: 'Reset'.tr().toString(),
                                        colour: Color(0xFF051D6D),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          if (_formKey.currentState.validate()) {
                                            startLoading();
                                            setState(() {
                                              showSpinner = true;
                                            });
                                            String oldPassword =
                                                await FireStoreServices()
                                                    .getPassword(_userEmail);
                                            await AuthServices().signInWithEmail(
                                                _userEmail, oldPassword);

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString('email', _userEmail);
                                            prefs.setString('password', _password);
                                            prefs.setInt('signInMethod',
                                                LoginMethod.firebase);

                                            if (oldPassword ==
                                                _passController.text) {
                                              alertFlutter(
                                                  'You are trying to change to same Password'
                                                      .tr()
                                                      .toString(),
                                                  'Try another Password'
                                                      .tr()
                                                      .toString(),
                                                  AlertType.error);
                                            }
                                            setState(() {
                                              DashBoard.isReset = true;
                                              DashBoard.newPassword = _password;
                                              Navigator.pushReplacementNamed(
                                                  context, DrawerItSelf.id);
                                            });
                                          }
                                        })
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void alertFlutter(String title, String desc, AlertType icon) {
    var style = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.green,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: icon,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            'Confirm'.tr().toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, DrawerItSelf.id),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
