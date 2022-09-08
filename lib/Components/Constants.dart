import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class LTextField extends StatelessWidget {
  final IconData icon;
  final endIcon;
  final bool isSecured;
  final String hintText;
  final String labelText;
  final keyboardType;
  final int maxLength;
  final Function validator;
  final Function onChanged;
  final bool isAutoValidate;
  final TextEditingController controller;

  LTextField(
      {@required this.icon,
      this.hintText,
      this.labelText,
      @required this.isSecured,
      this.keyboardType,
      this.maxLength,
      this.validator,
      this.onChanged,
      this.controller,
      this.endIcon,
      this.isAutoValidate = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        suffixIcon: endIcon,
        filled: true,
        fillColor: Colors.grey[350],
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      obscureText: isSecured,
      keyboardType: keyboardType,
      maxLengthEnforced: true,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      autovalidate: isAutoValidate,
    );
  }
}

// ignore: camel_case_types
class loadingButtons extends StatelessWidget {
  final String text;
  final loadingType;
  final Color colour;
  final double width;
  final Color textColor;
  final Function onTap;
  final double height;

  loadingButtons(
      {this.text,
      @required this.loadingType,
      this.colour,
      this.width,
      this.textColor,
      this.onTap,
      this.height = 50});

  @override
  Widget build(BuildContext context) {
    return ArgonButton(
        height: height,
        width: width,
        borderRadius: 30,
        elevation: 12,
        color: colour,
        child: Text(text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
        loader: Container(
          padding: EdgeInsets.all(10),
          child: loadingType,
        ),
        onTap: onTap);
  }
}

class Validations {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'.tr().toString()),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character'),
    PatternValidator(r'(?=.*?[A-Z])',
        errorText: 'passwords must have at least one uppercase character'),
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(8, errorText: 'name must be at least 8 characters long'),
  ]);

  final cafeValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'.tr().toString()),
    MinLengthValidator(3, errorText: 'name must be at least 3 characters long'),
  ]);

  final priceValidator = MultiValidator([
    RequiredValidator(errorText: 'price is required'.tr().toString()),
    MinLengthValidator(1, errorText: 'price must be at least 1 digit long'),
    PatternValidator('^[0-9]+(.[0-9]{0,2})?\$',
        errorText: 'price must have only numbers'),
  ]);

  final productValidator = MultiValidator([
    RequiredValidator(errorText: 'price is required'.tr().toString()),
    MinLengthValidator(1, errorText: 'price must be at least 1 digit long'),
    PatternValidator('r\'^[a-zA-Z]+\$\'', errorText: 'price must have only numbers'),
  ]);
}

// ignore: camel_case_types
class showSnackBar {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _text;

  showSnackBar(this._scaffoldKey, this._text);

  void show() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        _text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }
}

class DrawerButtons extends StatelessWidget {
  DrawerButtons({this.icon, this.text, this.func});
  final IconData icon;
  final String text;
  final Function func;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
      onTap: func,
    );
  }
}

class Connection {
  Future<bool> checkConnection() async {
    var _result = await (Connectivity().checkConnectivity());
    if (_result == ConnectivityResult.mobile || _result == ConnectivityResult.wifi) {
      log('connected to internet');
      return true;
    } else {
      log('no connection');
      return false;
    }
  }
}

class StatusType {
  static String owner = 'isOwner';
  static String pending = 'isPending';
  static String checking = 'isChecked';
}

class LoginMethod {
  static int firebase = 0;
  static int google = 1;
  static int facebook = 2;
}

const Color activeColor = Colors.white;
const Color inactiveColor = Color(0xFF808080);

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30.0, offset: Offset(0, 10))
];
