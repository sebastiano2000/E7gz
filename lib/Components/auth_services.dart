import 'dart:developer';

import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/OTP.dart';
import 'package:app_project/Screens/Profile.dart';
import 'package:app_project/Screens/getPhone.dart';
import 'package:app_project/Screens/loadingData.dart';
import 'package:app_project/Screens/registration.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'fireStore_services.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  User _user;

  String _name;
  String _password;
  String _email;
  bool _isSocial = false;
  static String phoneNumber;

  AuthServices.Info(this._name, this._password, this._email);

  AuthServices();

  Future<void> phoneValidation(String number, BuildContext context) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential credential) async {
      if (_isSocial) {
        Alert(
          style: AlertStyle(
              animationType: AnimationType.fromTop,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              descStyle: TextStyle(fontWeight: FontWeight.bold),
              animationDuration: Duration(milliseconds: 1000),
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () async {
                await FireStoreServices().addUser(
                    _user.email,
                    'Signed in with Gmail',
                    _user.displayName,
                    phoneNumber,
                    _user.photoURL);

                Navigator.pushReplacementNamed(context, DrawerItSelf.id);
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
      } else {
        final newUser = _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        if (newUser != null) {
          log(number);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _email);
          prefs.setString('password', _password);
          prefs.setInt('signInMethod', 0);

          await FireStoreServices().addUser(
              _email, _password, _name, number, 'assets/images/avatar.jpeg');

          Alert(
            style: AlertStyle(
                animationType: AnimationType.fromTop,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 1000),
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  LoadingData.email = _email;
                  Navigator.pushReplacementNamed(context, LoadingData.id);
                },
                width: 120,
              )
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
        }
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      log(authException.toString());
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 6),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, [int forceResendingToken]) async {
        OTPScreen.number = number;
        OTPScreen.email = _email;
        OTPScreen.verificationId = verificationId;
        OTPScreen.password = _password;
        OTPScreen.name = _name;
        OTPScreen.isSocial = _isSocial;
        Navigator.pushNamed(context, OTPScreen.id);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  // ignore: missing_return
  Future<String> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleSignInAuthentication =
        await _googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _googleSignInAuthentication.accessToken,
        idToken: _googleSignInAuthentication.idToken);

    var _result = await _auth.signInWithCredential(credential);
    User _user = _result.user;

    assert(!_user.isAnonymous, 'Unexpected error happened');
    assert(await _user.getIdToken() != null);

    User _currentUser = _auth.currentUser;
    assert(_user.uid == _currentUser.uid);

    if (_currentUser.phoneNumber == null) {
      await Navigator.pushNamed(context, GetPhone.id);
      _isSocial = true;
      Profile.isGoogle = true;
      await phoneValidation(phoneNumber, context);
    } else
      phoneNumber = _user.phoneNumber;

    this._user = _user;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _user.email);
    prefs.setString('password', 'Signed in with Gmail');
    prefs.setInt('signInMethod', 1);
    return 'signInWithGoogle succeeded: $_user';
  }

  Future<void> signOutGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('signInMethod');
    log('user Signed out of Google');

    await _googleSignIn.signOut();
  }

  Future<bool> signInWithFaceBook(BuildContext context) async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

    final _result = await _facebookLogin.logIn(['email', 'public_profile']);

    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        final _token = _result.accessToken.token;
        final _graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${_token}');
        final _profile = json.decode(_graphResponse.body);

        log(_profile.toString());
        final credential = FacebookAuthProvider.credential(_token);
        var _answer = await _auth.signInWithCredential(credential);
        User _user = _answer.user;

        if (_user.phoneNumber == null) {
          await Navigator.pushReplacementNamed(context, GetPhone.id);
          _isSocial = true;
          Profile.isFacebook = true;
          await phoneValidation(phoneNumber, context);
        } else
          phoneNumber = _user.phoneNumber;

        this._user = _user;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _user.email);
        prefs.setString('password', 'Signed in with Facebook');
        prefs.setInt('signInMethod', 2);

        return true;
        break;

      case FacebookLoginStatus.cancelledByUser:
        return false;
        break;

      case FacebookLoginStatus.error:
        return false;
        break;
    }

    if (_result.status == FacebookLoginStatus.loggedIn) {
      log('hakona');
    } else
      return false;
  }

  Future<void> signOutFacebook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('signInMethod');
    log('user Signed out of Facebook');

    await _facebookLogin.logOut();
  }

  Future<dynamic> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future signOutOfFirebase() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('signInMethod');

    log('user Signed out of firebase');
  }
}
