import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:app_project/Components/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TestScreen extends StatefulWidget {
  static const String id = 'TestScreen';

  static String email;
  static bool isEnabled = true;

  @override
  _TestScreenState createState() => _TestScreenState(email,isEnabled);
}

class _TestScreenState extends State<TestScreen> {
  String _email;

  bool _isEnabled;
  var _onPressed;

  @override
  void initState() {
    super.initState();
    checkButtonState();
  }

  void checkButtonState () async{
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    bool check = prefs.getBool('isEnabled');

    if(check == null){
      if(_isEnabled){
        setState(() {
          _onPressed = () async{
            await FireStoreServices().updateStatus(_email, StatusType.pending, true);

            await FireStoreServices().makeRequest(_email);

            prefs.setBool('pendingScreen', true);

            Navigator.pushReplacementNamed(context, ConfirmationScreen.id);
          };
        });
      }else{
        setState(() {
          _onPressed = null;
        });
      }
    }else if (check == false){
      setState(() {
        _onPressed = null;
      });
    }

  }

  _TestScreenState(this._email,this._isEnabled);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              color: Colors.green,
                disabledColor: Colors.grey[700],
                disabledTextColor: Colors.white,
                onPressed: _onPressed,
                child: Text('Apply')),
          ],
        ),
      ),
    );
  }
}
