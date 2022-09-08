import 'package:app_project/Screens/login.dart';
import 'package:app_project/Screens/registration.dart';
import 'package:connectivity/connectivity.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    checkConnection();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  Future checkConnection() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult _result) async {
      if (_result == ConnectivityResult.mobile ||
          _result == ConnectivityResult.wifi) {
      }else{
        EdgeAlert.show(context, title: 'No internet connection', gravity: EdgeAlert.TOP,backgroundColor: Colors.red, duration: 3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFd4ebe8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: animation.value * 250,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, LoginScreen.id);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 110.0,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue,
                        elevation: 10,
                        focusElevation: 20,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {

                            Navigator.pushNamed(context, RegistrationScreen.id);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 110.0,
                          ),
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.lightBlueAccent,
                        elevation: 10,
                        focusElevation: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
