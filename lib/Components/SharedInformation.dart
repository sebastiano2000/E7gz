import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_project/Screens/Profile.dart';

class SharedInformation {
  String _email;
  String _password;
  bool _isUser;
  int _method;

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email');
    _password = prefs.getString('password');
    _method = prefs.getInt('signInMethod');

    if (_password == null || _email == null) {
      _isUser = false;
    } else
      _isUser = true;

    if (_method == 1)
      Profile.isGoogle = true;
    else if (_method == 2) Profile.isFacebook = true;

    return _isUser;
  }
}
