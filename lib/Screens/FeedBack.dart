import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:ui' as ui;
import 'package:app_project/Components/fireStore_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:easy_localization/easy_localization.dart';

class FeedBack extends StatefulWidget {
  static const String id = 'FeedbackScreen';

  static String email;

  @override
  _FeedBackState createState() => _FeedBackState(email);
}

class _FeedBackState extends State<FeedBack> {
  _FeedBackState(this._email);
  String _email;

  String titleText;

  bool _validate = false;
  bool _showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  List<String> _choices = [
    'Positive FeedBack'.tr().toString(),
    'Negative FeedBack'.tr().toString(),
    'Further Improvements'.tr().toString(),
    'Report a Bug'.tr().toString(),
    'Report an error'.tr().toString()
  ];

  String _selectedChoice;

  // ignore: non_constant_identifier_names
  final _FeedBackText = TextEditingController();
  // ignore: non_constant_identifier_names
  String _Text = "";

  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('FeedBack'),
          leading: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, DrawerItSelf.id);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AnimationLimiter(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    horizontalOffset: 150,
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: SafeArea(
                        child: ModalProgressHUD(
                          inAsyncCall: _showSpinner,
                          opacity: 0.5,
                          progressIndicator: Lottie.asset(
                            'assets/indicator.json',
                            height: 100,
                            fit: BoxFit.cover,
                            animate: true,
                            repeat: true,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25, left: 20, right: 20),
                                  child: Form(
                                    key: _formKey,
                                    child: Directionality(
                                      textDirection:
                                          EasyLocalization.of(context).locale ==
                                                  Locale('ar', 'EG')
                                              ? ui.TextDirection.rtl
                                              : ui.TextDirection.ltr,
                                      child: DropdownSearch<String>(
                                        mode: Mode.BOTTOM_SHEET,
                                        showSelectedItem: true,
                                        items: _choices,
                                        label: 'Select your FeedBack Type'
                                            .tr()
                                            .toString(),
                                        hint: 'FeedBack Type'.tr().toString(),
                                        popupItemDisabled: (String s) =>
                                            s.startsWith('I'),
                                        validator: (String item) {
                                          if (item == null)
                                            return 'Required field'.tr().toString();
                                          else
                                            return null;
                                        },
                                        onChanged: (value) {
                                          _selectedChoice = value;
                                        },
                                        selectedItem: _selectedChoice,
                                        autoValidate: _validate,
                                        showClearButton: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 60,
                                    left: 15,
                                    right: 25,
                                  ),
                                  child: Directionality(
                                    textDirection:
                                        EasyLocalization.of(context).locale ==
                                                Locale('ar', 'EG')
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                    child: TextField(
                                      maxLines: 10,
                                      controller: _FeedBackText,
                                      onChanged: (value) {
                                        setState(() {
                                          _Text = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(40)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(20)),
                                        ),
                                        hintText:
                                            'Enter Your FeedBack'.tr().toString(),
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        fillColor:
                                            DynamicTheme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.grey[700]
                                                : Colors.grey[200],
                                      ),
                                      cursorColor: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                SmoothStarRating(
                                  allowHalfRating: true,
                                  onRated: (value) {
                                    _rating = value;
                                  },
                                  starCount: 5,
                                  rating: _rating,
                                  size: 40.0,
                                  isReadOnly: false,
                                  color: Colors.yellowAccent,
                                  borderColor: Colors.blueAccent,
                                  spacing: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 80),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState.validate() &&
                                          _rating != null) {
                                        setState(() {
                                          _showSpinner = true;
                                          _validate = false;
                                        });

                                        await FireStoreServices().addFeedBack(
                                            _selectedChoice, _Text, _rating, _email);

                                        alertFlutter();
                                        setState(() {
                                          _showSpinner = false;
                                        });
                                      } else
                                        setState(() {
                                          _validate = true;
                                        });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
                                        shape: BoxShape.rectangle,
                                        color: Colors.blue,
                                      ),
                                      margin: EasyLocalization.of(context).locale ==
                                              Locale('ar', 'EG')
                                          ? EdgeInsets.all(20)
                                          : EdgeInsets.all(30),
                                      padding: EasyLocalization.of(context).locale ==
                                              Locale('ar', 'EG')
                                          ? EdgeInsets.only(top: 2, bottom: 2)
                                          : EdgeInsets.only(top: 10, bottom: 10),
                                      child: Center(
                                        child: Text(
                                          'Submit FeedBack'.tr().toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void alertFlutter() {
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
        color: Colors.green,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: AlertType.success,
      title: 'Thank you for Your FeedBack.'.tr().toString(),
      desc: 'Our support team will handle your FeedBack as soon as possible.'
          .tr()
          .toString(),
      buttons: [
        DialogButton(
          child: Text(
            "Done.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushNamed(context, DrawerItSelf.id),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
