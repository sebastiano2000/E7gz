import 'dart:developer';

import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RequestsScreen extends StatefulWidget {
  static const String id = 'RequestsScreen';

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          leading: Icon(null),
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
                ])),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Admin')
                      .doc('Main')
                      .collection('Requests')
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();

                    if (snapshot.hasData) {
                      final emails = snapshot.data.docs;

                      // ignore: non_constant_identifier_names
                      List<Container> Emails = [];

                      for (var email in emails) {
                        final userEmail = email.get('Email');
                        final userID = email.id;

                        log(userEmail);

                        final cardWidget = Container(
                            padding: const EdgeInsets.only(bottom: 15),
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
                                    'Email: $userEmail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'ID: $userID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        loadingButtons(
                                          loadingType: SpinKitCircle(
                                            color: Colors.white,
                                          ),
                                          text: 'Accept',
                                          colour: Colors.green,
                                          width: 70,
                                          height: 35,
                                          onTap: (startLoading, stopLoading,
                                              btnState) async {
                                            startLoading();
                                            _email = userEmail;

                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.pending, false);
                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.owner, true);
                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.checking, true);

                                            await FireStoreServices()
                                                .deleteRequest(_email);

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
                                          height: 35,
                                          onTap: (startLoading, stopLoading,
                                              btnState) async {
                                            startLoading();
                                            _email = userEmail;

                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.pending, false);
                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.owner, false);
                                            await FireStoreServices().updateStatus(
                                                _email, StatusType.checking, true);

                                            await FireStoreServices()
                                                .deleteRequest(_email);

                                            stopLoading();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));

                        Emails.add(cardWidget);
                      }
                      return ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        children: Emails,
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
