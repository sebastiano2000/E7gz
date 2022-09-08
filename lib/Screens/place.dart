import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Screens/e7gz.dart';
import 'package:app_project/Screens/menu.dart';
import 'package:app_project/Screens/review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Place extends StatefulWidget {
  static const id = 'PlaceScreen';

  final int stars;
  final String name;
  final String email;
  final List image;
  final String tag;
  final String location;
  final String street;
  final bool available;

  Place(
      {@required this.stars,
      @required this.image,
      @required this.tag,
      @required this.name,
      @required this.location,
      @required this.street,
      @required this.available,
      @required this.email});

  @override
  _PlaceState createState() =>
      _PlaceState(stars, name, email, image, tag, location, street, available);
}

class _PlaceState extends State<Place> {
  int _stars;
  String _name;
  String _email;
  List _image = [];
  String _tag;
  String _location;
  String _street;
  bool _available;

  _PlaceState(this._stars, this._name, this._email, this._image, this._tag,
      this._location, this._street, this._available);

  List<Row> availability() {
    List<Row> list = [];

    if (_available == true) {
      list.add(
        Row(
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Colors.green,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Available'.tr().toString(),
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
          ],
        ),
      );
    } else {
      list.add(
        Row(
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Colors.red,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Not Available'.tr().toString(),
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return list;
  }

  List images() {
    List<Container> list = [];

    for (int i = 0; i < _image.length; i++) {
      list.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[300],
            boxShadow: shadowList,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _image[i] != null
              ? SizedBox(
            height: 250,
            child: CachedNetworkImage(
              imageUrl: _image[i],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )
              : Container(
              width: 0.0, height: 0.0
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Hero(
                        tag: _tag,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: images(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.grey.shade400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 80, left: 10),
                            child: Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Owners')
                                            .doc(_tag)
                                            .collection('reviews')
                                            .snapshots(),

                                        // ignore: missing_return
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final reviews = snapshot.data.docs;

                                            // ignore: non_constant_identifier_names
                                            List<Container> Reviews = [];

                                            for (var review in reviews) {
                                              final _reviewsName = review.get('name');
                                              final _reviewsStar = review.get('star');
                                              final _reviewsReview = review.get('review');

                                              final cardWidget = Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _reviewsName,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 24),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 25,
                                                        left: 15,
                                                      ),
                                                      child: Center(
                                                        child: SmoothStarRating(
                                                            allowHalfRating: true,
                                                            starCount: 5,
                                                            rating: _reviewsStar * 1.0,
                                                            size: 25.0,
                                                            isReadOnly: true,
                                                            color: Colors.yellowAccent,
                                                            borderColor: Colors.yellowAccent,
                                                            spacing: 5.0),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                      _reviewsReview,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                  ],
                                                ),
                                              );

                                              Reviews.add(cardWidget);
                                            }

                                            return ListView(
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(20),
                                                children: Reviews);
                                          }
                                        },
                                      ),
                                    ],
                                  ), //own(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.0),
              child: Container(
                height: 140.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: shadowList,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _name,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: Color(0xFF647082),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '$_location, $_street',
                          style: TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: Color(0xFF647082),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '$_location, $_street',
                          style: TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: _stars * 1.0,
                              size: 25.0,
                              isReadOnly: true,
                              color: Colors.yellowAccent,
                              borderColor: Colors.yellowAccent,
                              spacing: 5.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: availability(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Menu(available: _available, email: _email)));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Menu'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Review(emailOwner: _email)));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Review'.tr().toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _available
                              ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder:
                                  // ignore: unnecessary_statements
                                      (context) => E7gz(emailOwner: _email)))
                          // ignore: unnecessary_statements
                              : null;
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'E7gz'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
