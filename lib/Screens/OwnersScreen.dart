import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OwnersScreen extends StatefulWidget {
  static const String id = 'OwnersScreen';

  @override
  _OwnersScreenState createState() => _OwnersScreenState();
}

class _OwnersScreenState extends State<OwnersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: Icon(null),
        title: Text('Owners'),
        elevation: 10,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                Colors.green,
                Colors.green[900],
                Colors.green[700],
                Colors.green[500],
                Colors.green[300],
                Colors.green[100]
              ])),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('isOwner', isEqualTo: true)
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();

                  if (snapshot.hasData) {
                    final owners = snapshot.data.docs;

                    // ignore: non_constant_identifier_names
                    List<Container> Owners = [];

                    for (var owner in owners) {
                      final ownerName = owner.get('FullName');
                      final ownerEmail = owner.get('Email');
                      final ownerNumber = owner.get('PhoneNumber');
                      final ownerId = owner.id;

                      log(ownerName);
                      log(ownerEmail);
                      log(ownerNumber);

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
                                  'Name: $ownerName',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Email: $ownerEmail',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'PhoneNumber: $ownerNumber',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ID: $ownerId',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ],
                            ),
                          ));

                      Owners.add(cardWidget);
                    }
                    return ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      children: Owners,
                    );
                  }
                })
          ],
        ),
      ),
    ));
  }
}
