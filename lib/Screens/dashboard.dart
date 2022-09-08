import 'dart:developer';
import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/FeedBack.dart';
import 'package:app_project/Screens/PlaceDashboard.dart';
import 'package:app_project/Screens/Profile.dart';
import 'package:app_project/Screens/TestScreen.dart';
import 'package:app_project/Screens/confirmation.dart';
import 'package:app_project/Screens/createOwner.dart';
import 'package:app_project/Screens/drawerCaller.dart';
import 'package:app_project/Screens/e7gz.dart';
import 'package:app_project/Screens/place.dart';
import 'package:app_project/Screens/review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:search_widget/search_widget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DashBoard extends StatefulWidget {
  static const String id = 'DashBoard';

  static String newPassword;
  static bool isReset;

  static List<String> data;
  static bool isNew = false;

  @override
  _DashBoardState createState() =>
      _DashBoardState(newPassword, isReset, data, isNew);
}

class _DashBoardState extends State<DashBoard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;

  String _phoneNumber;
  String _FSId;

  String _newPassword;
  bool _isReset;

  List<String> _data;

  bool _isNew;

  _DashBoardState(this._newPassword, this._isReset, this._data, this._isNew);

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _searchList.clear();
  }

  void getCurrentUser() async {
    try {
      final _user = _auth.currentUser;

      if (_user != null) {
        loggedInUser = _user;

        if (!_isNew) {
          _data = await FireStoreServices().getUserInformation(loggedInUser.email);
        }

        DrawerCaller.photoUrl = loggedInUser.photoURL;
        Profile.email = loggedInUser.email;
        Profile.phoneNumber = _phoneNumber;
        Profile.name = loggedInUser.displayName;
        Profile.uid = _FSId;
        Profile.password = _data[1];
        Review.emailClient = loggedInUser.email;
        E7gz.emailClient = loggedInUser.email;
        PlaceDashboard.email = loggedInUser.email;
        TestScreen.email = loggedInUser.email;
        ConfirmationScreen.uid = _FSId;
        CreateOwner.email = loggedInUser.email;
        FeedBack.email = loggedInUser.email;

        log(Profile.email);
        log(Profile.phoneNumber);
        log(Profile.name);

        log(loggedInUser.uid);
        log(loggedInUser.toString());
        log(loggedInUser.displayName);
        log(loggedInUser.photoURL);

        _phoneNumber = _data[2];
        _FSId = _data[4];
        log(_phoneNumber);
        log(_FSId);
        log('new password is = $_newPassword');

        Review.telephone = _phoneNumber;

        if (_isReset) {
          await FireStoreServices()
              .updatePassword(loggedInUser.email, _newPassword, _FSId);
          await loggedInUser.updatePassword(_newPassword);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // ignore: missing_return
  List<Container> choose(
      List<Container> cafe, List<Container> restaurant, List<Container> gym) {
    if (_selectedChoice == 0) {
      log('1');
      return cafe;
    } else if (_selectedChoice == 1) {
      log('2');
      return restaurant;
    } else if (_selectedChoice == 2) {
      log('3');
      return gym;
    }
  }

  final _swipeImages = [
    'assets/images/swipeCafe.png',
    'assets/images/swipeRestaurant.png',
    'assets/images/swipeGym.png'
  ];

  int _selectedChoice = 0;

  List<LeaderBoard> _searchList = <LeaderBoard>[];

  LeaderBoard _selectedItem;

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        data: (brightness) => ThemeData(
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return Scaffold(
            body: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: SearchWidget<LeaderBoard>(
                        dataList: _searchList,
                        hideSearchBoxWhenItemSelected: true,
                        listContainerHeight: MediaQuery.of(context).size.height / 4,
                        queryBuilder: (String query, List<LeaderBoard> list) {
                          return list
                              .where((LeaderBoard item) => item.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        },
                        popupListItemBuilder: (LeaderBoard item) {
                          return PopupListItemWidget(item);
                        },
                        selectedItemBuilder: (LeaderBoard selectedItem,
                            VoidCallback deleteSelectedItem) {
                          return Place(
                              image: selectedItem.image,
                              tag: selectedItem.ownerID,
                              name: selectedItem.name,
                              location: selectedItem.location,
                              stars: selectedItem.stars,
                              available: selectedItem.state,
                              street: selectedItem.address,
                              email: selectedItem.email
                          );
                        },
                        // widget customization
                        noItemsFoundWidget: NoItemsFound(),
                        textFieldBuilder:
                            (TextEditingController controller, FocusNode focusNode) {
                          return MyTextField(controller, focusNode);
                        },
                        onItemSelected: (item) {
                          setState(() {
                            _selectedItem = item;
                          });
                        })),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  height: 130,
                  child: Swiper(
                    autoplay: true,
                    autoplayDelay: 7000,
                    autoplayDisableOnInteraction: true,
                    curve: Curves.easeIn,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage(_swipeImages[index]),
                            fit: BoxFit.fill,
                          ));
                    },
                    viewportFraction: 0.7,
                    scale: 0.8,
                    pagination: SwiperPagination(builder: SwiperPagination.dots),
                    onTap: (index) {
                      setState(() {
                        _selectedChoice = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Owners')
                              .snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              log('1');
                              return CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return CircularProgressIndicator();

                            if (snapshot.hasData) {
                              log('123');
                              final places = snapshot.data.docs;
                              // ignore: non_constant_identifier_names
                              List<Container> Cafe = [];
                              // ignore: non_constant_identifier_names
                              List<Container> Restaurant = [];
                              // ignore: non_constant_identifier_names
                              List<Container> Gym = [];

                              _searchList.clear();

                              for (var place in places) {
                                // log(place.id.toString());
                                // log(place.get('name').toString());
                                // log(place.get('category').toString());
                                // log(place.get('location').toString());
                                // log(place.get('address').toString());
                                // log(place.get('email').toString());
                                // log(place.get('state').toString());
                                // log(place.get('star').toString());
                                // log(place.get('placeImages').toString());

                                final ownersID = place.id;
                                final ownersName = place.get('name');
                                final ownersCategory = place.get('category');
                                final ownersLocation = place.get('location');
                                final ownersAddress = place.get('address');
                                final ownersEmail = place.get('email');
                                final ownersState = place.get('state');
                                final ownersStar = place.get('star');
                                final ownersImages = place.get('placeImages');

                                log(ownersEmail);

                                final cardWidget = Container(
                                  child: GestureDetector(
                                    dragStartBehavior: DragStartBehavior.down,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Place(
                                                image: ownersImages,
                                                tag: ownersID,
                                                name: ownersName,
                                                location: ownersLocation,
                                                stars: ownersStar,
                                                available: ownersState,
                                                street: ownersAddress,
                                                email: ownersEmail),
                                          ));
                                    },
                                    child: Container(
                                      height: 240.0,
                                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Align(
                                                child: Hero(
                                                  tag: ownersID,
                                                  child: Container(
                                                    height: 210,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(20),
                                                    ),
                                                    child: ownersImages.first != null
                                                        ? SizedBox(
                                                            height: 250,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  ownersImages.first,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url, error) =>
                                                                  Icon(Icons.error),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 0.0, height: 0.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 200.0,
                                            margin: EdgeInsets.only(
                                                top: 40.0, bottom: 20.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blue[100],
                                                  Colors.blue[200],
                                                  Colors.blue[300],
                                                  Colors.blue[400],
                                                  Colors.blue[500],
                                                  Colors.blue[600],
                                                  Colors.blue[700]
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                              ),
                                              boxShadow: shadowList,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                bottomRight: Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  ownersName,
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 20.0),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                  ),
                                                  child: Center(
                                                    child: SmoothStarRating(
                                                        allowHalfRating: true,
                                                        starCount: 5,
                                                        rating: ownersStar * 1.0,
                                                        size: 25.0,
                                                        isReadOnly: true,
                                                        color: Colors.yellowAccent,
                                                        borderColor: Colors.yellowAccent,
                                                        spacing: 5.0),
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.pin_drop,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      ownersLocation,
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                _searchList.add(
                                  LeaderBoard(
                                      ownersName,
                                      ownersImages,
                                      ownersEmail,
                                      ownersLocation,
                                      ownersStar,
                                      ownersAddress,
                                      ownersCategory,
                                      ownersID,
                                      ownersState),
                                );

                                if (ownersCategory == 'cafe') {
                                  Cafe.add(cardWidget);
                                } else if (ownersCategory == 'restaurant') {
                                  Restaurant.add(cardWidget);
                                } else if (ownersCategory == 'gym') {
                                  Gym.add(cardWidget);
                                }
                              }

                              return ListView(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: choose(Cafe, Restaurant, Gym));
                            }
                          },
                        ),
                      ],
                    ), //own(),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class LeaderBoard {
  LeaderBoard(this.name, this.image, this.email, this.location, this.stars,
      this.address, this.category, this.ownerID, this.state);

  final name;
  final image;
  final ownerID;
  final category;
  final location;
  final address;
  final email;
  final state;
  final stars;
}

class SelectedItemWidget extends StatelessWidget {
  SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final LeaderBoard selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/cafe.jpg'), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.name,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(30),
          ),
          labelText: 'Find a place to reserve',
          labelStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          border: InputBorder.none,
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.local_cafe,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "Can\'t find what you are searching for!",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  PopupListItemWidget(this.item);

  final LeaderBoard item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cafe.jpg'), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
