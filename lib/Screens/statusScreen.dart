import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/ownerTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class StatusScreen extends HookWidget {
  static const String id = 'StatusScreen';

  static bool isOwner;

  bool _animationComplete = false;


  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40,),
              isOwner
                  ? Text('Congratulations you are now an Owner!',textAlign: TextAlign.center, style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),)
                  : Text(
                      'For our Users safety we rejected your application\n'
                      'because we could\'nt find enough information to validate that you are a real owner!',textAlign: TextAlign.center, style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),
              SizedBox(height: 60,),
              isOwner
                  ? Container(
                height: 300,
                child: Lottie.asset(
                  'assets/accepted.json',
                  fit: BoxFit.cover,
                  animate: true,
                  controller: animationController,

                  onLoaded: (composition) async {
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
                  },
                ),
              )
                  : Container(
                height: 300,
                child: Lottie.asset(
                  'assets/rejected.json',
                  fit: BoxFit.cover,
                  animate: true,
                  controller: animationController,

                  onLoaded: (composition) async {
                    animationController.addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        indicateAnimationComplete(context);
                      }
                    });

                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    animationController
                      ..duration = Duration(seconds: 6)
                      ..forward();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void indicateAnimationComplete(BuildContext context) {
    _animationComplete = true;

    navDashBoard(context);
  }

  void navDashBoard(BuildContext context) {
    if (_animationComplete) {
      if(isOwner)
        Navigator.of(context)
            .pushNamedAndRemoveUntil(OwnerScreen.id, (Route<dynamic> route) => false);
      else
        Navigator.pushReplacementNamed(context, DrawerItSelf.id);

    }
  }
}
