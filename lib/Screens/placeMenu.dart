import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PlaceMenu extends StatefulWidget {
  static const id = 'PlaceMenu';

  static List<Map> products;

  final String email;

  PlaceMenu({this.email});

  @override
  _PlaceMenuState createState() => _PlaceMenuState(products, email);
}

class _PlaceMenuState extends State<PlaceMenu> {
  int _count = 1;
  String _email;
  List<String> _category = [];
  List<String> _product = [];
  List<double> _price = [];
  List<String> _categories = [];
  List<Map> _oldProducts = [{}];
  List<Map> _newProducts = [{}];

  _PlaceMenuState(this._oldProducts, this._email);

  @override
  void initState() {
    super.initState();
    products();
  }

  void products() async {
    _oldProducts = await FireStoreServices().getMenu(_email);
  }

  void choose(){
      for(int i=0; i<_oldProducts.length; i++){
          _categories.add(_oldProducts[i]["category"]);
      }
      _categories = _categories.toSet().toList();
      _newProducts = _oldProducts;
  }

  List objects(){

    choose();

    List <Container> list = [];

    for(int i=0; i<_oldProducts.length; i++){
      list.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: shadowList,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: DropDownField(
                  itemsVisibleInDropdown: _categories.length,
                  controller: categoryChoice,
                  hintText: _oldProducts[i]["category"],
                  enabled: true,
                  items: _categories,
                  onValueChanged: (value) {
                    setState(() {
                      _newProducts[i].update('category', (v) => value);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  validator: Validations().productValidator,
                  onChanged: (value){
                    setState(() {
                      _newProducts[i].update('product', (v) => value);
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
                    fillColor: Colors.grey[200],
                    hintText: _oldProducts[i]['product'],
                    filled: true,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  maxLines: 1,
                  validator: Validations().priceValidator,
                  textAlign: TextAlign.center,
                  onChanged: (value){
                    setState(() {
                      var n = double.parse(value);
                      _newProducts[i].update('price', (v) => n);
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
                    fillColor: Colors.grey[200],
                    hintText: _oldProducts[i]['price'],
                    filled: true,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    for(int i=0; i<_count; i++){
      list.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: shadowList,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: DropDownField(
                  itemsVisibleInDropdown: _categories.length,
                  controller: categoryChoice,
                  hintText: 'Enter category',
                  enabled: true,
                  items: _categories,
                  onValueChanged: (value) {
                    setState(() {
                      _category.add(value);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  validator: Validations().productValidator,
                  onChanged: (value){
                    setState(() {
                      _product.add(value);
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
                    fillColor: Colors.grey[200],
                    hintText: 'Enter product',
                    filled: true,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  maxLines: 1,
                  validator: Validations().priceValidator,
                  textAlign: TextAlign.center,
                  onChanged: (value){
                    setState((){
                      var n = double.parse(value);
                      _price.add(n);
                      if(value != null){
                        _count++;
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
                    fillColor: Colors.grey[200],
                    hintText: 'Enter price',
                    filled: true,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  final categoryChoice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                children: objects(),
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
                  ],
                ),
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
                          showAlertDialog(context).showDialog();
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Add new category'.tr().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          bool changed = false;

                          for(int i=0; i<_oldProducts.length; i++){
                            if(_newProducts[i]['category'] != _oldProducts[i]['category'] ||
                                _newProducts[i]['product'] != _oldProducts[i]['product'] ||
                                _newProducts[i]['price'] != _oldProducts[i]['price']){
                              changed = true;
                            }
                          }

                          if(changed == true){
                            FireStoreServices().changeProducts(_email, _newProducts);
                          }

                          if(_count > 1){
                            FireStoreServices().addProducts(_email, _product, _categories, _price);
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Save'.tr().toString(),
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

  showAlertDialog(BuildContext context) {
    String _name;
    bool _used = false;

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget saveButton = FlatButton(
      child: Text("Save"),
      onPressed:  () {
        for(int i=0; i<_categories.length; i++){
          if(_categories[i].compareTo(_name) == 0){
            _used = true;
          }
        }

        if(_used == false){
          _categories.add(_name);
          Navigator.of(context).pop();
        }
        else{
          EdgeAlert.show(context, title: 'category already exists!', gravity: EdgeAlert.BOTTOM,
              backgroundColor: Colors.red, duration: 2);
          _used = false;
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Add a new category"),
      content: TextFormField(
          maxLines: 1,
          textAlign: TextAlign.center,
          validator: Validations().productValidator,
          onChanged: (value){
            _name = value;
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
            fillColor: Colors.grey[200],
            hintText: 'Enter category'.tr().toString(),
            filled: true,
          ),
          cursorColor: Colors.black,
        ),
      actions: [
        cancelButton,
        saveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}