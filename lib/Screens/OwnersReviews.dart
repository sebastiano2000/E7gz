import 'package:app_project/Components/fireStore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OwnerReview extends StatefulWidget {
  static const id = 'OwnerReview';

  final String email;

  OwnerReview({this.email});

  @override
  _OwnerReviewState createState() => _OwnerReviewState(email);
}

class _OwnerReviewState extends State<OwnerReview> {
  String _email;
  Map _owner = {};

  _OwnerReviewState(this._email);

  @override
  void initState() {
    super.initState();
    owner();
  }

  void owner() async {
    _owner = await FireStoreServices().getOwner(_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:60 ),
          child: SingleChildScrollView(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Owners')
                      .doc(_owner['id'])
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
                              Text(_reviewsName,
                                style: TextStyle(color: Colors.black,fontSize: 24),
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
                                      rating: _reviewsStar,
                                      size: 25.0,
                                      isReadOnly: true,
                                      color: Colors.yellowAccent,
                                      borderColor: Colors.yellowAccent,
                                      spacing: 5.0
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(_reviewsReview,
                                style: TextStyle(color: Colors.black,fontSize: 20),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        );

                        Reviews.add(cardWidget);
                      }

                      return ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20),
                          children: Reviews
                      );
                    }
                  },
                ),
              ],
            ), //own(),
          ),
        ),
      ),
    );
  }
}
