import 'dart:developer' as dev;
import 'dart:math';

import 'package:app_project/Components/FadeAnimation.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
// import 'package:app_project/Screens/adminScreen.dart';
import 'package:app_project/Screens/forget.dart';
import 'package:app_project/Screens/language.dart';
import 'package:app_project/Screens/registration.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:app_project/Components/Constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'Profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_project/Components/languages.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;

  String _email;
  String _password;
  bool _isSecure = true;
  bool _validate = false;

  var _changedIcon = Icon(Icons.visibility);

  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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

    _emailController.addListener(() {
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

  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.LanguageCode) {
      case 'en':
        _temp = Locale(language.LanguageCode, 'US');
        break;
      case 'de':
        _temp = Locale(language.LanguageCode, 'DE');
        break;
      case 'fr':
        _temp = Locale(language.LanguageCode, 'FR');
        break;
      case 'it':
        _temp = Locale(language.LanguageCode, 'IT');
        break;
      case 'ar':
        _temp = Locale(language.LanguageCode, 'EG');
        break;
      default:
        _temp = Locale(language.LanguageCode, 'US');
    }
    EasyLocalization.of(context).locale = _temp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.050;

    return SafeArea(
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          key: _scaffoldKey,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              opacity: 0.5,
              progressIndicator: Lottie.asset('assets/indicator.json',
                  height: 100, fit: BoxFit.cover, animate: true, repeat: true),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Color(0xFFd4ebe8),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25, right: 15),
                              child: DropdownButton(
                                onChanged: (Language language) {
                                  _changeLanguage(language);
                                },
                                dropdownColor: Colors.white,
                                items: Language.languageList()
                                    .map<DropdownMenuItem<Language>>(
                                        (lang) => DropdownMenuItem(
                                              value: lang,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    lang.flag,
                                                    style: TextStyle(fontSize: 23),
                                                  ),
                                                  Text(
                                                    lang.name,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ))
                                    .toList(),
                                icon: Icon(
                                  Icons.language,
                                  size: 35,
                                  color: Colors.grey[700],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Hero(
                                tag: 'logo',
                                child: Image(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.cover,
                                  width: 170,
                                  height: 110,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      AnimatedContainer(
                        height: MediaQuery.of(context).size.height * 0.9,
                        duration: Duration(milliseconds: 250),
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
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(4, 0, 0, 20),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  1,
                                  Directionality(
                                    textDirection:
                                        EasyLocalization.of(context).locale ==
                                                Locale('ar', 'EG')
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                    child: LTextField(
                                      icon: Icons.email,
                                      isSecured: false,
                                      hintText: 'Enter your Email'.tr().toString(),
                                      labelText: 'Email'.tr().toString(),
                                      keyboardType: TextInputType.emailAddress,
                                      maxLength: 30,
                                      validator: Validations().emailValidator,
                                      onChanged: (String val) => _email = val,
                                      controller: _emailController,
                                      isAutoValidate: _validate,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  1.3,
                                  Directionality(
                                    textDirection:
                                        EasyLocalization.of(context).locale ==
                                                Locale('ar', 'EG')
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                    child: LTextField(
                                      icon: Icons.lock,
                                      isSecured: _isSecure,
                                      hintText:
                                          'Enter your Password'.tr().toString(),
                                      labelText: 'Password'.tr().toString(),
                                      keyboardType: TextInputType.visiblePassword,
                                      maxLength: 20,
                                      validator: Validations().passwordValidator,
                                      onChanged: (String value) => _password = value,
                                      controller: _passController,
                                      isAutoValidate: _validate,
                                      endIcon: IconButton(
                                        icon: _changedIcon,
                                        color: Colors.purple[900],
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
                                              _changedIcon = Icon(Icons.visibility);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                FadeAnimation(
                                  1.4,
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, ForgetPassScreen.id);
                                    },
                                    child: Text(
                                      'Forgot Password?'.tr().toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                FadeAnimation(
                                  1.5,
                                  EasyLocalization.of(context).locale ==
                                          Locale('en', 'US')
                                      ? Row(
                                          children: [
                                            AutoSizeText(
                                              'Dont have an account?'
                                                  .tr()
                                                  .toString(),
                                              maxLines: 2,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(
                                                    context, RegistrationScreen.id);
                                              },
                                              child: AutoSizeText(
                                                'Create one'.tr().toString(),
                                                maxLines: 2,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(
                                                    context, RegistrationScreen.id);
                                              },
                                              child: AutoSizeText(
                                                'Create one'.tr().toString(),
                                                maxLines: 2,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            AutoSizeText(
                                              'Dont have an account?'
                                                  .tr()
                                                  .toString(),
                                              maxLines: 2,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                SizedBox(height: 20),
                                FadeAnimation(
                                  1.6,
                                  loadingButtons(
                                    loadingType: SpinKitDualRing(
                                      color: Colors.white,
                                    ),
                                    colour: Colors.lightBlueAccent,
                                    text: 'Login'.tr().toString(),
                                    width: 350,
                                    textColor: Colors.white,
                                    onTap:
                                        (startLoading, stopLoading, btnState) async {
                                      if (_formKey.currentState.validate()) {
                                        startLoading();
                                        bool _isConnected =
                                            await Connection().checkConnection();
                                        if (_isConnected) {
                                          setState(() {
                                            showSpinner = true;
                                            _validate = false;
                                          });
                                          try {
                                            final user = await AuthServices()
                                                .signInWithEmail(_email, _password);
                                            if (user != null) {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString('email', _email);
                                              prefs.setString('password', _password);
                                              prefs.setInt('signInMethod',
                                                  LoginMethod.firebase);

                                              _email.compareTo('admin@gmail.com') ==
                                                      0
                                                  ? Navigator.pushReplacementNamed(
                                                      context, DrawerItSelf.id)
                                                  : Navigator.pushReplacementNamed(
                                                      context, DrawerItSelf.id);
                                            }
                                            _passController.clear();
                                            stopLoading();
                                          } catch (e) {
                                            dev.log(e.toString());
                                            showSnackBar(
                                                    _scaffoldKey,
                                                    'Wrong email or password!'
                                                        .tr()
                                                        .toString())
                                                .show();
                                            _passController.clear();
                                            stopLoading();
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _validate = true;
                                          });
                                          showSnackBar(
                                                  _scaffoldKey,
                                                  'No internet connection'
                                                      .tr()
                                                      .toString())
                                              .show();
                                          _passController.clear();
                                          stopLoading();
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                FadeAnimation(
                                  1.7,
                                  Text(
                                    'Continue with social media'.tr().toString(),
                                    style:
                                        TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                FadeAnimation(
                                  1.8,
                                  Divider(
                                    color: Colors.purpleAccent,
                                    thickness: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    1.9,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: FacebookSignInButton(
                                            onPressed: () async {
                                              setState(() {
                                                showSpinner = true;
                                              });
                                              bool _isConnected = await Connection()
                                                  .checkConnection();

                                              if (_isConnected) {
                                                bool _isIn = await AuthServices()
                                                    .signInWithFaceBook(context);

                                                if (_isIn) {
                                                  setState(() {
                                                    Profile.isFacebook = true;
                                                    Navigator.pushReplacementNamed(
                                                        context, DrawerItSelf.id);
                                                  });
                                                } else {
                                                  showSnackBar(
                                                          _scaffoldKey,
                                                          'Something wrong happened!'
                                                              .tr()
                                                              .toString())
                                                      .show();
                                                  setState(() {
                                                    showSpinner = false;
                                                  });
                                                }

                                                setState(() {
                                                  showSpinner = false;
                                                });
                                              } else {
                                                showSnackBar(
                                                        _scaffoldKey,
                                                        'No internet connection'
                                                            .tr()
                                                            .toString())
                                                    .show();
                                                setState(() {
                                                  showSpinner = false;
                                                });
                                              }
                                            },
                                            borderRadius: 20,
                                            text: 'Facebook'.tr().toString(),
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GoogleSignInButton(
                                            onPressed: () async {
                                              setState(() {
                                                showSpinner = true;
                                              });

                                              bool _isConnected = await Connection()
                                                  .checkConnection();

                                              if (_isConnected) {
                                                setState(() {
                                                  showSpinner = false;
                                                });

                                                try {
                                                  var result = await AuthServices()
                                                      .signInWithGoogle(context);
                                                  dev.log(result);
                                                } catch (e) {
                                                  showSnackBar(_scaffoldKey,
                                                          'Something wrong happened!')
                                                      .show();
                                                }
                                              } else {
                                                showSnackBar(
                                                        _scaffoldKey,
                                                        'No internet connection'
                                                            .tr()
                                                            .toString())
                                                    .show();
                                                setState(() {
                                                  showSpinner = false;
                                                });
                                              }
                                            },
                                            borderRadius: 20,
                                            text: 'Gmail'.tr().toString(),
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            darkMode: true,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
