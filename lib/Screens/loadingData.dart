import 'dart:developer';

import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';


// ignore: must_be_immutable
class LoadingData extends HookWidget {
  static const String id = 'LoadingData';

  static String email;

  bool _animationComplete = false;

  List<String> _data = [];

  FirebaseAuth _auth = FirebaseAuth.instance;
  User _loggedInUser;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Lottie.asset(
            'assets/welcome.json',
            fit: BoxFit.cover,
            animate: true,
            controller: animationController,
            onLoaded: (composition) async {
              DashBoard.isNew = true;
              DashBoard.data = _data;

              animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  indicateAnimationComplete(context);
                }
              });

              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              animationController
                ..duration = composition.duration
                ..forward();

              try {
                final _user = _auth.currentUser;

                if (_user != null) {
                  _loggedInUser = _user;

                  _data = await FireStoreServices().getUserInformation(email);

                  await _loggedInUser.updateProfile(
                      displayName: _data[0], photoURL: _data[3]);
                }
              } catch (e) {
                log(e.toString());
              }
            },
          ),
        ),
      ),
    );
  }

  void indicateAnimationComplete(BuildContext context) {
    _animationComplete = true;

    navDashBoard(context);
  }

  void navDashBoard(BuildContext context) {
    if (_animationComplete) {
      Navigator.pushReplacementNamed(context, DrawerItSelf.id);
    }
  }
}
