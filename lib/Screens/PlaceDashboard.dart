import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/OrderRequests.dart';
import 'package:app_project/Screens/OwnersReviews.dart';
import 'package:app_project/Screens/placeMenu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceDashboard extends StatefulWidget {
  static const id = 'PlaceDashboard';

  static String email;

  @override
  _PlaceDashboardState createState() => _PlaceDashboardState(email);
}

class _PlaceDashboardState extends State<PlaceDashboard> {
  final format = DateFormat("dd-MM-yyyy");

  String _email;
  String _stateName = 'Available';
  Color _stateColor = Colors.green;
  Map _owner = {};
  DateTime _date = DateTime.now();
  List<Map> _order = [{}];

  _PlaceDashboardState(this._email);

  @override
  void initState() {
    super.initState();
    owner();
    orders();
  }

  void owner() async {
    _owner = await FireStoreServices().getOwner(_email);
  }

  void orders() async {
    _order = await FireStoreServices().getOrders(_email);
  }

  List images(){
    List <Container> list = [];

    for(int i=0; i< _owner['images'].length; i++){
      list.add(
        Container(
          child: _owner['images'][i]!= null
              ? SizedBox(
            height: 250,
            child: CachedNetworkImage(
              imageUrl: _owner['images'][i],
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
            ),
          )

              : Container(width: 0.0, height: 0.0),
        ),
      );
    }

    return list;
  }

  List<Container> reserved(){
    List <Container> list = [];

    for(int i=0; i< _order.length; i++){
      if(_date.compareTo(_order[i]['date']) == 0){
        list.add(
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              boxShadow: shadowList,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('name',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text('time',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text('numberOfSeats',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text('telephone',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_order[i]['name'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(_order[i]['time'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(_order[i]['numberOfSeats'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(_order[i]['telephone'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
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
                      child: Row(
                        children: [
                          ListView(
                            scrollDirection: Axis.horizontal,
                            children: images(),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_owner['name'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text('${_owner['location']}/${_owner['address']}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
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
                                      rating: _owner['star'],
                                      size: 25.0,
                                      isReadOnly: true,
                                      color: Colors.yellowAccent,
                                      borderColor: Colors.yellowAccent,
                                      spacing: 5.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.grey.shade400,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 80.0,
                                width: 200.0,
                                child: DateTimeField(
                                  dateFormat: format,
                                  selectedDate: _date,
                                  initialDatePickerMode: DatePickerMode.day,
                                  onDateSelected: (DateTime value) {
                                    setState(() {
                                      _date = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Switch(value: true, activeColor: _stateColor, onChanged: (value){
                                setState((){
                                  if(value == true){
                                    _stateName = 'Available';
                                    _stateColor = Colors.green;
                                    FireStoreServices().updateState(_email, value);
                                  } else{
                                    _stateName = 'Not Available';
                                    _stateColor = Colors.red;
                                    FireStoreServices().updateState(_email, value);
                                  }
                                });
                              }),
                              SizedBox(width: 5.0),
                              Text(_stateName.tr().toString(),
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top:60.0),
                              child: SingleChildScrollView(
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: reserved(),
                                ), //own(),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 120.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceMenu(email: _email)));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Products'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerReview(email: _email)));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Reviews'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRequests(email: _email)));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Orders'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20),
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
