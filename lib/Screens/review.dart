import 'package:app_project/Components/fireStore_services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:ui' as ui;

class Review extends StatefulWidget {
  static const String id = 'ReviewScreen';

  final String emailOwner;
  static String emailClient;
  static String telephone;

  Review({this.emailOwner});

  @override
  _ReviewState createState() => _ReviewState(emailOwner, emailClient, telephone);
}

class _ReviewState extends State<Review> {

  _ReviewState(this._emailOwner, this._emailClient, this._telephone);

  String _emailClient;
  String _emailOwner;
  String _text;
  String _telephone;
  String _name;
  double _rating;

  final reviewText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Review'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    left: 15,
                  ),
                  child: Center(
                    child: SmoothStarRating(
                        allowHalfRating: true,
                        onRated: (value) {
                          _rating = value;
                        },
                        starCount: 5,
                        rating: _rating * 1.0,
                        size: 40.0,
                        isReadOnly: false,
                        color: Colors.yellowAccent,
                        borderColor: Colors.yellowAccent,
                        spacing: 5.0
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 60,
                    left: 15,
                    right: 25,
                  ),
                  child: TextField(
                    maxLines: 10,
                    controller: reviewText,
                    onChanged: (value) {
                      setState(() {
                        _text = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter Your Review',
                        hintStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: Colors.grey[200]),
                    cursorColor: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 150),
                  child: GestureDetector(
                    onTap: () async {
                      await FireStoreServices().addReview(_emailOwner, _emailClient, _name, _text, _rating, _telephone);
                      alertFlutter();
                      setState(() {
                        reviewText.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                      ),
                      margin: EdgeInsets.all(37),
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Submit Review',
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
    );
  }

  void alertFlutter() {
    var style = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
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
      title: "Review.\n",
      desc: "Thank you for your review.",
      buttons: [
        DialogButton(
          child: Text(
            "Done.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(20.0),
        ),
      ],
    ).show();
  }
}