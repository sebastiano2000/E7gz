import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

class ChangeName extends StatefulWidget {
  static const String id = 'ChangeName';

  static String email;
  static String uid;

  @override
  _ChangeNameState createState() => _ChangeNameState(email,uid);
}

class _ChangeNameState extends State<ChangeName> {
  final nameText = TextEditingController();
  String _newName;
  String _uid;

  final _formKey = GlobalKey<FormState>();

  bool showSpinner = false;

  _ChangeNameState(this.email,this._uid);
  String email;

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
              'Change Name'.tr().toString(),
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
                            ? const EdgeInsets.only(right: 35, top: 25)
                            : const EdgeInsets.only(left: 15, top: 25),
                    child: Text(
                      'Enter Your new Name'.tr().toString(),
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
                      icon: Icons.person,
                      isSecured: false,
                      hintText:
                      'Enter new Name'.tr().toString(),
                      labelText: 'Full Name'.tr().toString(),
                      keyboardType: TextInputType.name,
                      maxLength: 30,
                      validator: Validations().nameValidator,
                      onChanged: (String val) => _newName = val,
                      controller: nameText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          showSpinner = true;
                        });

                        _isTaken =
                        await FireStoreServices().checkName(_newName);

                        nameText.clear();
                        if (_isTaken)
                          alertFlutter(
                              'Name already Registered'.tr().toString(),
                              'Try another Name'.tr().toString(),
                              AlertType.error,
                              Colors.red);
                        else {
                          setState(() {
                            showSpinner = true;
                          });

                          FirebaseAuth _auth = FirebaseAuth.instance;

                          await _auth.currentUser.updateProfile(
                              displayName: _newName);

                          await FireStoreServices().changeName(
                              _newName, email, _uid);

                          setState(() {
                            showSpinner = false;
                          });

                          alertFlutter(
                              'Name changed'.tr().toString(),
                              'Process done successfully'.tr().toString(),
                              AlertType.success,
                              Colors.green);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                      ),
                      margin: EdgeInsets.all(25),
                      padding: EdgeInsets.only(left: 35, right: 35),
                      child: Center(
                        child: Text(
                          'Change Name'.tr().toString(),
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

  void alertFlutter(String title, String desc, AlertType icon, Color color) {
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
