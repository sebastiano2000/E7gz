import 'dart:async';
import 'dart:developer';
import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/loadingData.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as pinCode;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  static const String id = 'OTPScreen';
  static bool isValid;

  static String verificationId;
  static String number;
  static String name;
  static String password;
  static String email;
  static bool isSocial = false;

  @override
  _OTPScreenState createState() => _OTPScreenState(
      verificationId, isValid, number, name, password, email, isSocial);
}

class _OTPScreenState extends State<OTPScreen> {
  String _code = '';
  String _verificationId;
  bool _isValid;
  String _name;
  String _password;
  String _email;
  bool _isSocial;

  var _lock = new Lock();

  String _phoneNumber;

  _OTPScreenState(this._verificationId, this._isValid, this._phoneNumber,
      this._name, this._password, this._email, this._isSocial);

  TextEditingController _controller = TextEditingController();
  StreamController<pinCode.ErrorAnimationType> _errorController =
      StreamController<pinCode.ErrorAnimationType>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _code = '';
  }

  // ignore: missing_return
  Future<bool> checkCode(AuthCredential credential) async {
    try {
      var _result = await _auth.signInWithCredential(credential);

      User _user = _result.user;

      if (_user != null) {
        log('verified');

        _user.delete();

        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  void showError() {
    _errorController.add(
        pinCode.ErrorAnimationType.shake); // Triggering error shake animation
    showSnackBar(_scaffoldKey, 'Wrong code! please try again').show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Container(
              height: 500,
              child: FlareActor(
                'assets/check.flr',
                animation: 'otp',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: pinCode.PinCodeTextField(
                      controller: _controller,
                      errorAnimationController: _errorController,
                      animationType: pinCode.AnimationType.fade,
                      appContext: context,
                      obsecureText: false,
                      autoDisposeControllers: false,
                      length: 6,
                      onChanged: (value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      pinTheme: pinCode.PinTheme(
                          inactiveFillColor: Colors.grey,
                          shape: pinCode.PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(20),
                          fieldHeight: 50,
                          fieldWidth: 45,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.grey),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      autoDismissKeyboard: true,
                      textInputType: TextInputType.number,
                    )),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: loadingButtons(
                      loadingType: SpinKitChasingDots(
                        color: Colors.white,
                      ),
                      width: 300,
                      colour: Colors.green,
                      text: 'VERIFY',
                      textColor: Colors.white,
                      onTap: (startLoading, stopLoading, btnState) async {
                        startLoading();

                        if (_code.length != 6 || _isValid == false) {
                          showError();
                          _controller.clear();
                          stopLoading();
                          return;
                        } else if (_isSocial) {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: _verificationId,
                                  smsCode: _code);

                          bool _result = await _lock.synchronized(() async {
                            return await checkCode(credential);
                          });

                          if (_result) {
                            Alert(
                              style: AlertStyle(
                                  animationType: AnimationType.fromTop,
                                  isCloseButton: false,
                                  isOverlayTapDismiss: false,
                                  descStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  animationDuration:
                                      Duration(milliseconds: 1000),
                                  alertBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  )),
                              type: AlertType.success,
                              context: context,
                              title: "Validation Successful",
                              buttons: [
                                DialogButton(
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(116, 116, 191, 1.0),
                                    Color.fromRGBO(52, 138, 199, 1.0)
                                  ]),
                                  child: Text(
                                    "Get Started",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pushReplacementNamed(
                                          context, DrawerItSelf.id);
                                    });
                                  },
                                  width: 120,
                                ),
                              ],
                              content: Container(
                                height: 350,
                                child: FlareActor(
                                  'assets/done.flr',
                                  animation: 'otpDone',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ).show();
                            _controller.clear();

                            stopLoading();
                          }

                          return;
                        }

                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: _verificationId,
                                smsCode: _code);

                        bool _result = await _lock.synchronized(() async {
                          return await checkCode(credential);
                        });

                        if (_result) {
                          final newUser = _auth.createUserWithEmailAndPassword(
                              email: _email, password: _password);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('email', _email);
                          prefs.setString('password', _password);
                          prefs.setInt('signInMethod', LoginMethod.firebase);

                          await FireStoreServices().addUser(_email, _password,
                              _name, _phoneNumber,'assets/images/avatar.jpg');

                          setState(() {
                            if (newUser != null) {
                              log(_phoneNumber);

                              Alert(
                                style: AlertStyle(
                                    animationType: AnimationType.fromTop,
                                    isCloseButton: false,
                                    isOverlayTapDismiss: false,
                                    descStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    alertBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    )),
                                type: AlertType.success,
                                context: context,
                                title: "Validation Successful",
                                buttons: [
                                  DialogButton(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(116, 116, 191, 1.0),
                                      Color.fromRGBO(52, 138, 199, 1.0)
                                    ]),
                                    child: Text(
                                      "Get Started",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        LoadingData.email = _email;
                                        Navigator.pushReplacementNamed(
                                            context, LoadingData.id);
                                      });
                                    },
                                    width: 120,
                                  ),
                                ],
                                content: Container(
                                  height: 350,
                                  child: FlareActor(
                                    'assets/done.flr',
                                    animation: 'otpDone',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ).show();
                              _controller.clear();

                              stopLoading();
                            }
                          });
                        } else {
                          showError();

                          _controller.clear();
                          stopLoading();
                          return;
                        }
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ArgonTimerButton(
                    initialTimer: 10,
                    // Optional
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.45,
                    minWidth: MediaQuery.of(context).size.width * 0.30,
                    color: Colors.blue,
                    borderRadius: 5.0,
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    loader: (timeLeft) {
                      return Text(
                        "Wait | $timeLeft",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      );
                    },
                    onTap: (startTimer, btnState) async {
                      if (_isSocial) {
                        await AuthServices()
                            .phoneValidation(_phoneNumber, context);
                        setState(() {
                          if (btnState == ButtonState.Idle) {
                            startTimer(20);
                          }
                        });
                      } else {
                        await AuthServices.Info(_name, _password, _email)
                            .phoneValidation(_phoneNumber, context);
                        setState(() {
                          if (btnState == ButtonState.Idle) {
                            startTimer(20);
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
