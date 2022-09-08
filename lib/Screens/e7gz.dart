import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class E7gz extends StatefulWidget {
  static const id = 'E7gzScreen';
  static String owner;
  static String emailClient;
  final String emailOwner;

  E7gz({this.emailOwner});

  @override
  _E7gzState createState() => _E7gzState(owner, emailClient, emailOwner);
}

class _E7gzState extends State<E7gz> {
  static const Map promoCode = {'promo': 'E7gz', 'discount': 30};
  static const int maximumNumber = 6;

  String _promo;
  String _emailClient;
  String _emailOwner;
  String _name;
  String _phoneNumber;
  String _date;
  String _time;
  String _owner;
  double _totalPrice = 0.0;
  int _numberOfSeats = 1;
  Color _shapeMinus = Colors.red;
  Color _signMinus = Colors.white;
  Color _shapePlus = Colors.red;
  Color _signPlus = Colors.white;
  List<Map> _product = [{}];
  List<String>_categories = [];
  List<Map> _orders = [{}];

  Future<void> getInformation() async {
    List<String> _data = [];

    _data = await FireStoreServices().getUserInformation(_emailClient);

    setState(() {
      _name = _data[0];
      _phoneNumber = _data[2];
    });
  }

  final promoCodes = TextEditingController();

  _E7gzState(this._owner, this._emailClient, this._emailOwner);

  @override
  void initState() {
    super.initState();
    getInformation();
    products();
  }

  void products() async {
    _product = await FireStoreServices().getProducts(_emailOwner);
    choose();
  }

  void choose(){
    for(int i=0; i<_product.length; i++){
      _categories.add(_product[i]["category"]);
    }

    _categories = _categories.toSet().toList();
  }

  Container product(String name, double price){
  int orderQuantity = 0;
    
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('$name',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5.0),
              Text('$price',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawMaterialButton(
                    fillColor: Colors.white,
                    elevation: 6.0,
                    constraints: BoxConstraints.tightFor(
                      width: 30.0,
                      height: 30.0,
                    ),
                    child: Icon(FontAwesomeIcons.minus,
                      color: Colors.black,
                    ),
                    shape: CircleBorder(),
                    onPressed: () {
                      setState(() {
                        if (orderQuantity > 0){
                          orderQuantity--;
                          _totalPrice -= price;
                          if(orderQuantity >= 1){
                            int x = _orders.indexWhere((element) => element.containsValue(name));
                            _orders[x].update('quantity', (value) => value = orderQuantity);
                          }
                          else if(orderQuantity == 0){
                            bool contain = _orders.contains(name);
                            if(contain){
                              _orders.removeWhere((element) => element.containsValue(name));
                            }
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5.0),
                  Text('$orderQuantity',
                    style: TextStyle(color: Colors.black,fontSize: 20),
                  ),
                  SizedBox(width: 5.0),
                  RawMaterialButton(
                    fillColor: Colors.white,
                    elevation: 6.0,
                    constraints: BoxConstraints.tightFor(
                      width: 30.0,
                      height: 30.0,
                    ),
                    child: Icon(FontAwesomeIcons.plus,
                      color: Colors.black,
                    ),
                    shape: CircleBorder(),
                    onPressed: () {
                      setState(() {
                        if (orderQuantity >= 0 && orderQuantity < maximumNumber){
                          orderQuantity++;
                          _totalPrice += price;
                          if(orderQuantity == 1) {
                            _orders.add({
                              'product': name,
                              'quantity': orderQuantity
                            });
                          }
                          else if(orderQuantity > 1){
                            int x = _orders.indexWhere((element) => element.containsValue(name));
                            _orders[x].update('quantity', (value) => value = orderQuantity);
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  List<Container> orders(String name){
    List<Container> list = [];

    for(int i=0; i<_product.length; i++){
      if(name.compareTo(_product[i]['category']) == 0){
        list.add(product(_product[i]['product'], _product[i]['price']));
      }
    }

    return list;
  }

  List<Expanded> reserveProducts(){
    List<Expanded> list = [];

    for(int i=0; i<_categories.length; i++){
      list.add(
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text('${_categories[i]}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.0),
                Column(
                  children: orders(_categories[i]),
                ),
              ],
            ),
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
                  SizedBox(height: 100.0),
                  Container(
                    height: 600.0,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('Date'.tr().toString(),
                                    style: TextStyle(color: Colors.white,fontSize: 12),
                                  ),
                                  SizedBox(height: 5.0),
                                  DateTimeField(
                                    selectedDate: null,
                                    initialDatePickerMode: DatePickerMode.day,
                                    onDateSelected: (DateTime value) {
                                      _date = value.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('Time'.tr().toString(),
                                    style: TextStyle(color: Colors.white,fontSize: 12),
                                  ),
                                  SizedBox(height: 5.0),
                                  GestureDetector(
                                    onTap: () async {
                                      TimeOfDay _picked = await showTimePicker(
                                        context: context,
                                        initialEntryMode: TimePickerEntryMode.dial,
                                        initialTime: TimeOfDay.now(),
                                        builder: (BuildContext context, Widget child) {
                                          return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(alwaysUse24HourFormat: true),
                                            child: child,
                                          );
                                        },
                                      );
                                      _time = _picked.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListView(
                              children: reserveProducts(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
                            Navigator.pop(context);
                          }),
                          SizedBox(width: 20.0),
                          Text(_owner,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total'.tr().toString(),
                                      style: TextStyle(color: Colors.white,fontSize: 12),
                                    ),
                                    Text('Number of seats'.tr().toString(),
                                      style: TextStyle(color: Colors.white,fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$_totalPrice',
                                      style: TextStyle(color: Colors.black,fontSize: 20),
                                    ),
                                    RawMaterialButton(
                                      fillColor: _shapeMinus,
                                      elevation: 6.0,
                                      constraints: BoxConstraints.tightFor(
                                        width: 56.0,
                                        height: 56.0,
                                      ),
                                      child: Icon(FontAwesomeIcons.minus,
                                        color: _signMinus,
                                      ),
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        setState(() {
                                          if (_numberOfSeats > 1){
                                            _numberOfSeats--;
                                            _shapeMinus = Colors.white;
                                            _signMinus = Colors.red;
                                          }
                                          else if (_numberOfSeats == 1){
                                            _shapeMinus = Colors.white;
                                            _signMinus = Colors.red;
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10.0),
                                    Text('$_numberOfSeats',
                                      style: TextStyle(color: Colors.black,fontSize: 20),
                                    ),
                                    SizedBox(width: 10.0),
                                    RawMaterialButton(
                                      fillColor: _shapePlus,
                                      elevation: 6.0,
                                      constraints: BoxConstraints.tightFor(
                                        width: 56.0,
                                        height: 56.0,
                                      ),
                                      child: Icon(FontAwesomeIcons.plus,
                                        color: _signPlus,
                                      ),
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        setState(() {
                                          if (_numberOfSeats >= 1){
                                            _numberOfSeats++;
                                            _shapeMinus = Colors.white;
                                            _signMinus = Colors.red;
                                          }
                                          else if (_numberOfSeats == maximumNumber){
                                            _shapeMinus = Colors.white;
                                            _signMinus = Colors.red;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Icon(Icons.card_giftcard,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10.0),
                                TextField(
                                  maxLines: 1,
                                  controller: promoCodes,
                                  onChanged: (value) {
                                    setState((){
                                      _promo = value;
                                      if(_promo.compareTo(promoCode['promo']) == 0){
                                          _totalPrice *= 1-(promoCode['discount']/100);
                                      }
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
                                      hintText: 'Apply Promo Code'.tr().toString(),
                                      hintStyle: TextStyle(fontSize: 20),
                                      filled: true,
                                      fillColor: Colors.grey[200]),
                                  cursorColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                          ),
                          child: Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await FireStoreServices().order(_emailOwner, _emailClient, _name, _phoneNumber,
                                    _date, _time, _numberOfSeats, _totalPrice, _orders);
                                Navigator.pushNamed(context, DashBoard.id);
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text('E7gz'.tr().toString(),
                                    style: TextStyle(color: Colors.white,fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
