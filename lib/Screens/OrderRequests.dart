import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderRequests extends StatefulWidget {
  static const String id = 'RequestsOrder';

  final String email;

  OrderRequests({this.email});

  @override
  _OrderRequestsState createState() => _OrderRequestsState(email);
}

class _OrderRequestsState extends State<OrderRequests> {
  String _email;
  String _id;

  _OrderRequestsState(this._email);

  @override
  void initState() {
    super.initState();
    id();
  }

  void id() async {
    _id = await FireStoreServices().getID(_email);
  }

  List<Widget> order(final user) {
    List<Widget> list = [];

    for(int i=0; i<user.length; i++){
      list.add(
        Row(
          children: [
            Text(
              'Product: ${user[i]['product']}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Quantity: ${user[i]['quantity']}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Requests'),
          elevation: 10,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.red[900],
                      Colors.red[700],
                      Colors.blue[600],
                      Colors.blue[900],
                      Colors.blue
                    ])
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Owners')
                      .doc(_id)
                      .collection('orders')
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final e7gz = snapshot.data.docs;

                      // ignore: non_constant_identifier_names
                      List<Container> Orders = [];

                      for (var hagz in e7gz) {
                        final userDate = hagz.get('date');
                        final userTime = hagz.get('time');
                        final userPhone = hagz.get('telephone');
                        final userSeats = hagz.get('numberOfSeats');
                        final userName = hagz.get('name');
                        final userOrder = hagz.get('order');
                        final userID = hagz.id;
                        final userIsAccepted = hagz.get('isAccepted');

                        if(userIsAccepted == false) {
                          final cardWidget = Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Card(
                                elevation: 15,
                                color: Colors.grey[100],
                                shadowColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Name: $userName',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Phone: $userPhone',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Time: $userTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Date: $userDate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Seats: $userSeats',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                        children: order(userOrder),
                                    ),
                                    SizedBox(height: 10.0),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          loadingButtons(
                                            loadingType: SpinKitCircle(
                                              color: Colors.white,
                                            ),
                                            text: 'Accept',
                                            colour: Colors.green,
                                            width: 70,
                                            //height: 35,
                                            onTap: (startLoading, stopLoading,
                                                btnState) async {
                                              startLoading();

                                              await FireStoreServices()
                                                  .acceptOrder(_email, userID);

                                              stopLoading();
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          loadingButtons(
                                            loadingType: SpinKitFadingCircle(
                                              color: Colors.white,
                                            ),
                                            text: 'Reject',
                                            colour: Colors.red,
                                            width: 70,
                                            // height: 35,
                                            onTap: (startLoading, stopLoading,
                                                btnState) async {
                                              startLoading();

                                              await FireStoreServices()
                                                  .deleteOrder(_email, userID);

                                              stopLoading();
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ));

                          Orders.add(cardWidget);
                        }
                      }
                      return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20),
                        children: Orders,
                      );
                    }

                  })
            ],
          ),
        ),
      ),
    );
  }
}
