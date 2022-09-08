import 'package:app_project/Screens/e7gz.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_project/Components/fireStore_services.dart';

class Menu extends StatefulWidget {
  static const id = 'menuScreen';

  final bool available;
  final String email;

  Menu({@required this.available, @required this.email});

  @override
  _MenuState createState() => _MenuState(email, available);
}

class _MenuState extends State<Menu> {
  final String _email;
  final bool _available;
  List<String> _menus = [];

  _MenuState(this._email, this._available);
  
  @override
  void initState() {
    super.initState();
    menu();
  }

  void menu() async {
    _menus = await FireStoreServices().getMenuImages(_email);
  }

  List images(){
    List <Container> list = [];

    for(int i=0; i<_menus.length; i++){
      list.add(
        Container(
          child: _menus[i]!= null
              ? SizedBox(
            height: 250,
            child: CachedNetworkImage(
              imageUrl: _menus[i],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(flex: 1, child: null),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20.0),
                              ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Container(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: images(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: (){
                              // ignore: unnecessary_statements
                              _available? Navigator.push(context, MaterialPageRoute(builder:
                              // ignore: unnecessary_statements
                                  (context) => E7gz(emailOwner: _email))) : null;
                            },
                            child: Container(
                              height: 60.0,
                              width: 200.0,
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20.0)),
                              child: Center(
                                child: Text('E7gz'.tr().toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: null),
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
