import 'dart:developer';
import 'package:app_project/Screens/TestScreen.dart';
import 'package:app_project/Screens/statusScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationScreen extends StatefulWidget {
  static const String id = 'ConfirmationScreen';

  static String uid;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState(uid);
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String _uid;

  _ConfirmationScreenState(this._uid);

  void acceptOwner() async {
    StatusScreen.isOwner = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('pendingScreen');

    Navigator.of(context).pushReplacementNamed(StatusScreen.id);
  }

  void rejectOwner() async {
    StatusScreen.isOwner = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('pendingScreen');

    TestScreen.isEnabled = false;

    prefs.setBool('isEnabled', false);

    Navigator.of(context).pushReplacementNamed(StatusScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Your Information has been sent to the admins to check if you are a valid owner'
                '\n we will answer as soon as possible',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                height: 300,
                child: Lottie.asset(
                  'assets/searching.json',
                  repeat: true,
                  fit: BoxFit.fill,
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(_uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bool status = snapshot.data.get('isOwner');
                      bool status2 = snapshot.data.get('isChecked');

                      log(status.toString());
                      log(status2.toString());

                      if (status == true) {
                        acceptOwner();
                      } else if (status == false && status2 == true) {
                        rejectOwner();
                      }
                    }
                    return Column(
                      children: [
                        Text(
                          'Pending...',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        Container(
                          height: 200,
                          child: Lottie.asset(
                            'assets/pending.json',
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
