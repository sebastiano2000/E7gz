import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/FadeAnimation.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/login.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  static bool isBanned = false;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState(isBanned);
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int index = 0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isValid = false;
  bool _isRegistered;
  bool _isTaken;
  bool showSpinner = false;
  bool _validate = false;
  bool _isBanned;

  _RegistrationScreenState(this._isBanned);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');

  String _password;
  String _email;
  String _name;
  bool _isSecure = true;
  var _changedIcon = Icon(Icons.visibility);

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'EG');

    setState(() {
      this.number = number;
    });
  }

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

    _nameController.addListener(() {
      setState(() {
        updateColors();
      });
    });

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
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
      textDirection: EasyLocalization.of(context).locale == Locale('ar', 'EG')
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
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
                  child: Column(children: [
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Image(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.cover,
                            width: 150,
                            height: 100,
                          ),
                        ),
                      ],
                    )),
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
                                    'Registration',
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 25),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1,
                                  LTextField(
                                    icon: Icons.person,
                                    isSecured: false,
                                    hintText: 'Enter your Full Name'.tr().toString(),
                                    labelText: 'Full Name'.tr().toString(),
                                    keyboardType: TextInputType.name,
                                    maxLength: 30,
                                    validator: Validations().nameValidator,
                                    onChanged: (String val) => _name = val,
                                    controller: _nameController,
                                    isAutoValidate: _validate,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.3,
                                  LTextField(
                                    icon: Icons.email,
                                    isSecured: false,
                                    hintText: 'Enter your Email'.tr().toString(),
                                    labelText: 'Email Address'.tr().toString(),
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 30,
                                    onChanged: (String val) => _email = val,
                                    validator: Validations().emailValidator,
                                    controller: _emailController,
                                    isAutoValidate: _validate,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.4,
                                  LTextField(
                                    icon: Icons.lock,
                                    isSecured: _isSecure,
                                    hintText: 'Enter your Password'.tr().toString(),
                                    labelText: 'Password'.tr().toString(),
                                    keyboardType: TextInputType.visiblePassword,
                                    maxLength: 20,
                                    validator: Validations().passwordValidator,
                                    onChanged: (String value) => _password = value,
                                    controller: _passController,
                                    isAutoValidate: _validate,
                                    endIcon: IconButton(
                                      icon: _changedIcon,
                                      color: Colors.black,
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
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.5,
                                  LTextField(
                                      icon: Icons.lock,
                                      isSecured: _isSecure,
                                      hintText:
                                          'Enter your Password'.tr().toString(),
                                      labelText: 'ConfirmPassword'.tr().toString(),
                                      keyboardType: TextInputType.visiblePassword,
                                      maxLength: 20,
                                      validator: (val) => MatchValidator(
                                              errorText: 'passwords do not match'
                                                  .tr()
                                                  .toString())
                                          .validateMatch(val, _password),
                                      controller: _confirmController,
                                      isAutoValidate: _validate,
                                      endIcon: IconButton(
                                          icon: _changedIcon,
                                          color: Colors.black,
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
                                  height: 20,
                                ),
                                FadeAnimation(
                                  1.5,
                                  InternationalPhoneNumberInput(
                                    initialValue: number,
                                    ignoreBlank: false,
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                      showFlags: true,
                                      useEmoji: false,
                                    ),
                                    inputDecoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.transparent),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrangeAccent),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        hintText: 'Enter your Phone Number'
                                            .tr()
                                            .toString(),
                                        prefixIcon: Icon(
                                          Icons.phone_iphone,
                                          color: Colors.black,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[350],
                                        labelText: 'PhoneNumber'.tr().toString(),
                                        labelStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto),
                                    autoValidate: false,
                                    onInputValidated: (bool isRight) {
                                      !isRight ? _isValid = false : _isValid = true;
                                    },
                                    onInputChanged: (PhoneNumber newNumber) {
                                      number = newNumber;
                                    },
                                    textFieldController: _phoneController,
                                    maxLength: 11,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.6,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?'.tr().toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, LoginScreen.id);
                                        },
                                        child: Text(
                                          'login'.tr().toString(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeAnimation(
                                    1.7,
                                    loadingButtons(
                                      loadingType: SpinKitDoubleBounce(
                                        color: Colors.white,
                                      ),
                                      width: 350,
                                      textColor: Colors.white,
                                      text: 'Signup'.tr().toString(),
                                      colour: Colors.red,
                                      onTap: (startLoading, stopLoading,
                                          btnState) async {
                                        if (_formKey.currentState.validate() &&
                                            _isValid) {
                                          startLoading();
                                          setState(() {
                                            showSpinner = true;
                                            _validate = false;
                                          });

                                          bool _isConnected =
                                              await Connection().checkConnection();

                                          if (_isConnected) {
                                            getPhoneNumber(number.toString());
                                            _isRegistered = await FireStoreServices()
                                                .checkPhoneNumber(number.toString());
                                            _isTaken = await FireStoreServices()
                                                .checkEmail(_email.toString());

                                            if (_isRegistered || _isTaken) {
                                              showSnackBar(
                                                      _scaffoldKey,
                                                      _isRegistered
                                                          ? 'Phone Number is Already Registered!'
                                                              .tr()
                                                              .toString()
                                                          : 'Email address is Already Registered!'
                                                              .tr()
                                                              .toString())
                                                  .show();
                                              _passController.clear();
                                              _confirmController.clear();
                                              _phoneController.clear();
                                              stopLoading();
                                              setState(() {
                                                showSpinner = false;
                                              });
                                              return;
                                            }

                                            await AuthServices.Info(
                                                    _name, _password, _email)
                                                .phoneValidation(
                                                    number.toString(), context);

                                            if (_isBanned) {
                                              showSnackBar(
                                                      _scaffoldKey,
                                                      'This phone got banned due to multiple requests please try again later!'
                                                          .tr()
                                                          .toString())
                                                  .show();
                                              _passController.clear();
                                              _confirmController.clear();
                                              _phoneController.clear();
                                              setState(() {
                                                showSpinner = false;
                                              });
                                              stopLoading();
                                              return;
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
                                            _confirmController.clear();
                                            _phoneController.clear();
                                            stopLoading();
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          }
                                        }

                                        setState(() {
                                          if (btnState != ButtonState.Idle) {
                                            stopLoading();
                                            showSpinner = false;
                                            _passController.clear();
                                            _confirmController.clear();
                                            _emailController.clear();
                                            _phoneController.clear();
                                          }
                                        });
                                      },
                                    ))
                              ],
                            )),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )),
    ));
  }
}
