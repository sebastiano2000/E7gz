import 'dart:developer';

import 'package:app_project/Components/SharedInformation.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
// import 'package:app_project/Screens/adminScreen.dart';
import 'package:app_project/Screens/ownerTest.dart';
import 'package:app_project/Screens/welcome.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'noNetwork.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'LoadingScreen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  Future checkConnection() async {
    try {
      var _result = await (Connectivity().checkConnectivity());
      if (_result == ConnectivityResult.mobile ||
          _result == ConnectivityResult.wifi) {
        log('connected to internet');

        await Firebase.initializeApp();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _email = prefs.getString('email');

        bool _isUser = await SharedInformation().isLoggedIn();

        bool _isOwner = await FireStoreServices().checkOwner(_email);

        if (_isUser) {
          if (_email.compareTo('admin@gmail.com') == 0)
            Navigator.pushReplacementNamed(context, DrawerItSelf.id);
          else if (_isOwner)
            Navigator.pushReplacementNamed(context, OwnerScreen.id);
          else
            Navigator.pushReplacementNamed(context, DrawerItSelf.id);
        } else
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, NoNetworkScreen.id);

        log('no connection');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: Center(
          child: Container(
            child: Lottie.asset('assets/loading.json',
                fit: BoxFit.cover,
                repeat: true,
                alignment: Alignment.center,
                animate: true),
          ),
        ),
      ),
    );
  }
}
