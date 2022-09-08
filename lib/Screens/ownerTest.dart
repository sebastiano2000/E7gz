import 'package:connectivity/connectivity.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';

class OwnerScreen extends StatefulWidget {
  static const String id = 'OwnerScreen';

  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {

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
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: Text('I AM AN OWNER BITCH!', style: TextStyle(
          fontSize: 40,
          color: Colors.black
        ),),
      ),
    );
  }
}
