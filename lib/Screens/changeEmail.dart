import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

class ChangeEmail extends StatefulWidget {
  static const String id = 'ChangeEmail';

  static String email;
  static String password;
  static String uid;


  @override
  _ChangeEmailState createState() => _ChangeEmailState(email, password,uid);
}

class _ChangeEmailState extends State<ChangeEmail> {
  final mailText = TextEditingController();
  String _newMail;

  _ChangeEmailState(this._originalEmail, this._password, this._uid);

  String _originalEmail;
  String _password;
  String _uid;
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  bool _isTaken;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: EasyLocalization.of(context).locale == Locale('ar', 'EG')
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Change E-mail'.tr().toString(),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 0.5,
            progressIndicator: Lottie.asset(
                'assets/indicator.json',
                height: 100,
                fit: BoxFit.cover,
                animate: true,
                repeat: true),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EasyLocalization.of(context).locale == Locale('ar', 'EG')
                            ? const EdgeInsets.only(right: 25, top: 20)
                            : const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      'Enter Your new Email'.tr().toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 13, right: 25),
                    child:
                    LTextField(
                      icon: Icons.email,
                      isSecured: false,
                      hintText: 'Enter new Email'.tr().toString(),
                      labelText: 'Email Address'.tr().toString(),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 30,
                      onChanged: (String val) => _newMail = val,
                      validator: Validations().emailValidator,
                      controller: mailText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          showSpinner = true;
                        });

                        _isTaken =
                        await FireStoreServices().checkEmail(_newMail);

                        mailText.clear();

                        if (_isTaken) {
                          Alert_flutter(
                              'Email address is Already Registered!'
                                  .tr()
                                  .toString(),
                              'Try another Email'.tr().toString(),
                              AlertType.error,
                              Colors.red);
                        } else {
                          FirebaseAuth _auth = FirebaseAuth.instance;
                          await _auth
                              .signInWithEmailAndPassword(
                              email: _originalEmail, password: _password)
                              .then((value) async {
                            await _auth.currentUser.updateEmail(_newMail);

                            await FireStoreServices()
                                .changeEmail(_newMail, _originalEmail, _uid);
                          });

                          setState(() {
                            showSpinner = false;
                          });

                          Alert_flutter(
                              'Email changed'.tr().toString(),
                              'Process done successfully'.tr().toString(),
                              AlertType.success,
                              Colors.green);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                      ),
                      margin: EdgeInsets.all(25),
                      padding: EdgeInsets.only(left: 35, right: 35),
                      child: Center(
                        child: Text(
                          'Change Email'.tr().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Alert_flutter(String title, String desc, AlertType icon, Color color) {
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
        color: color,
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
          onPressed: () {
            if (_isTaken) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, DrawerItSelf.id);
            }
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
