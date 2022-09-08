import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');
  CollectionReference _admin = FirebaseFirestore.instance
      .collection('Admin')
      .doc('Main')
      .collection('Requests');
  bool _isUsed;
  bool _isTaken;

  String OwnerId;

  Future<void> addUser(String email, String password, String name, String number,
      String photo) async {
    await _fireStore.collection('Users').add({
      'Email': email,
      'FullName': name,
      'Password': password,
      'PhoneNumber': number,
      'Photo': photo,
      'isOwner': false,
      'isPending': false,
      'isChecked': false
    });

    log('User added successfully!');
  }

  Future<void> addFeedBack(
      String title, String feedback, double stars, String email) async {
    await _fireStore
        .collection('FeedBack')
        .add({'Email': email, 'Title': title, 'feedback': feedback, 'stars': stars})
        .then((value) => print('FeedBack Added'))
        .catchError(
          (error) => print("Failed to add feedback: $error"),
        );
  }

  Future<bool> checkPhoneNumber(String number) async {
    await _fireStore
        .collection('Users')
        .where('PhoneNumber', isEqualTo: number)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('found');
        _isUsed = true;
      } else {
        log('not Found');
        _isUsed = false;
      }
    });

    return _isUsed;
  }

  Future<bool> checkName(String name) async {
    await _fireStore
        .collection('Users')
        .where('FullName', isEqualTo: name)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('found');
        _isTaken = true;
      } else {
        log('not Found');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<bool> checkEmail(String email) async {
    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('found');
        _isTaken = true;
      } else {
        log('not Found');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<String> getPassword(String email) async {
    String password;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        password = value.docs.first.get('Password');
      } else {
        log('something wrong happened');
      }
    });

    return password;
  }

  Future<void> updatePassword(String email, String password, String uid) async {
    await _users.doc(uid).update({'Password': password}).then(
        (value) => log('Client password changed successfully'));
  }

  Future<void> changeName(String newName, String email, String uid) async {
    await _users
        .doc(uid)
        .update({'FullName': newName})
        .then((value) => log("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> changeEmail(String newEmail, String email, String uid) async {
    await _users
        .doc(uid)
        .update({'Email': newEmail})
        .then((value) => log("Email Updated"))
        .catchError((error) => log("Failed to update user: $error"));
  }

  Future<List<String>> getUserInformation(String email) async {
    List<String> data = [];

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        data.add(value.docs.first.get('FullName'));
        data.add(value.docs.first.get('Password'));
        data.add(value.docs.first.get('PhoneNumber'));
        data.add(value.docs.first.get('Photo'));
        data.add(value.docs.first.id);
        log('Data Collected');
      }
    });

    return data;
  }

  Future<String> getUserId(String email) async {
    String _uid;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        _uid = value.docs.first.id;
        log('id Collected');
      }
    });

    return _uid;
  }

  Future<bool> checkUser(String email) async {
    bool _isChecked;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        _isChecked = value.docs.first.get('isChecked');
      }
    });

    return _isChecked;
  }

  Future<void> updateStatus(String email, String statusType, bool state) async {
    if (await checkUser(email)) {
      log('User got rejected before!');

      return;
    } else {
      await _users
          .doc(await getUserId(email))
          .update({statusType: state})
          .then((value) => log('$statusType status updated'))
          .catchError((error) => log('something wrong happened here $error'));
    }
  }

  Future<void> makeRequest(String email) async {
    await _admin.add({
      'Email': email,
    });
  }

  Future<void> deleteRequest(String email) async {
    if (email.compareTo('') == 0) {
      await _admin
          .doc('Main')
          .delete()
          .then((value) => log("Main Deleted"))
          .catchError((error) => log("Failed to delete Main: $error"));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isMain', true);
    } else {
      String _uid;

      await _admin.where('Email', isEqualTo: email).get().then((value) {
        if (value.docs.isNotEmpty) {
          _uid = value.docs.first.id;
        }
      });

      await _admin
          .doc(_uid)
          .delete()
          .then((value) => log("User Deleted"))
          .catchError((error) => log("Failed to delete user: $error"));
    }
  }

  Future<bool> checkOwner(String email) async {
    bool _isOwner;

    await _users.where('Email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.get('isOwner') == true ? _isOwner = true : _isOwner = false;
      }
    }).catchError((error) => log("Failed to Check user: $error"));

    return _isOwner;
  }

  Future<String> createNewOwner(String emailOwner) async {
    String id;
    try {
      await _fireStore
          .collection('Users')
          .where('Email', isEqualTo: emailOwner)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await _fireStore.collection('PendingOwners').add({
            'address': null,
            'email': null,
            'name': null,
            'location': null,
            'star': 0,
            'state': true,
            'category': null,
            'placeImages': [],
            'placeMenu': [],
            'OwnerId': []
          }).then((value) {
            id = value.id;
          });
        }
      }).catchError((e) => log('please check your internet connecetion' + e));
      return id;
    } catch (e) {
      log('$e +11');
    }
  }

  Future<void> addFields(String category, String name, String address,
      String location, String emailOwner, String id) async {
    try {
      await _fireStore.collection('PendingOwners').doc(id).update({
        'address': address,
        'category': category,
        'email': emailOwner,
        'name': name,
        'location': location
      }).catchError((e) => log('please check your internet connecetion' + e));
    } catch (e) {
      log('$e +13');
    }
  }

  Future<void> addPathToDatabase(List list, int number, String id) async {
    try {
      if (number == 1) {
        try {
          await _fireStore
              .collection('PendingOwners')
              .doc(id)
              .update({'placeImages': FieldValue.arrayUnion(list)}).catchError(
                  (e) => log('please check your internet connecetion' + e));
        } catch (e) {
          log('$e +1');
        }
      } else if (number == 2) {
        try {
          await _fireStore
              .collection('PendingOwners')
              .doc(id)
              .update({'placeMenu': FieldValue.arrayUnion(list)}).catchError(
                  (e) => log('please check your internet connecetion' + e));
        } catch (e) {
          log('$e +2');
        }
      } else if (number == 3) {
        try {
          await _fireStore
              .collection('PendingOwners')
              .doc(id)
              .update({'OwnerId': FieldValue.arrayUnion(list)}).catchError(
                  (e) => log('please check your internet connecetion' + e));
        } catch (e) {
          log('$e +678');
        }
      }
    } catch (e) {
      log('$e +3');
    }
  }

  Future<void> order(
      String emailOwner,
      String emailClient,
      String name,
      String telephone,
      String date,
      String time,
      int numberOfSeats,
      double totalPrice,
      List<Map> order) async {
    String id;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: emailOwner)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore.collection('Owners').doc(id).collection('orders').add({
      'name': name,
      'email': emailClient,
      'telephone': telephone,
      'date': date,
      'time': time,
      'numberOfSeats': numberOfSeats,
      'order': FieldValue.arrayUnion(order)
    });
  }

  Future<List<String>> getMenuImages(String email) async {
    String id;
    List<String> data = [];

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('placeMenu')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        data.addAll(value.docs.first.get('images'));
      }
    });

    return data;
  }

  Future<List<Map>> getMenu(String email) async {
    String id;
    List<Map> data = [];

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('menu')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((result) {
          data.add({
            "category": result.get("category"),
            "product": result.get("product"),
            "price": result.get("price"),
          });
        });
      }
    });

    return data;
  }

  Future<void> addProducts(String email, List<String> products,
      List<String> categories, List<double> prices) async {
    String id;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore.collection('Owners').doc(id).collection('menu').add({
      'category': categories,
      'product': products,
      'price': prices,
    });
  }

  Future<String> getID(String email) async {
    String id;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    return id;
  }

  Future<void> deleteOrder(String email, String orderID) async {
    String id;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('reviews')
        .doc(orderID)
        .delete();
  }

  Future<void> acceptOrder(String email, String orderID) async {
    String id;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('reviews')
        .doc(orderID)
        .update({'isAccepted': true});
  }

  Future<void> addReview(String emailOwner, String emailClient, String name,
      String review, double star, String telephone) async {
    String id;
    List<double> list = [];
    double stars = 0.0;
    int i = 0;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: emailOwner)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore.collection('Owners').doc(id).collection('reviews').add({
      'name': name,
      'review': review,
      'star': star,
      'telephone': telephone,
      'email': emailClient
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('reviews')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                list.add(element.get('star'));
              }),
              for (i; i < list.length; i++)
                {
                  stars += list[i],
                },
              stars /= i,
            });

    await _fireStore.collection('Owners').doc(id).update({'star': stars});
  }

  Future<void> changeProducts(String email, List<Map> products) async {
    String id;
    int count = 0;

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('menu')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.data().update('category', products[count]['category']);
        element.data().update('product', products[count]['product']);
        element.data().update('price', products[count]['price']);

        count++;
      });
    });
  }

  Future<Map> getOwner(String email) async {
    Map owner = {};

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        owner.addAll({
          "id": value.docs.first.id,
          "name": value.docs.first.get("name"),
          "category": value.docs.first.get("category"),
          "location": value.docs.first.get("location"),
          "address": value.docs.first.get("address"),
          "email": value.docs.first.get("email"),
          "state": value.docs.first.get("state"),
          "star": value.docs.first.get("star"),
          "images": value.docs.first.get('placeImages')
        });
      }
    });

    return owner;
  }

  Future<List<Map>> getOrders(String email) async {
    String id;
    List<Map> order = [{}];

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('orders')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.get('isAccepted') == true) {
            order.add({
              'name': element.get('name'),
              'time': element.get('time'),
              'numberOfSeats': element.get('numberOfSeats'),
              'telephone': element.get('telephone'),
              'date': element.get('date')
            });
          }
        });
      }
    });

    return order;
  }

  Future<void> updateState(String email, bool state) async {
    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        _fireStore
            .collection('Owners')
            .doc(value.docs.first.id)
            .update({'state': state});
      }
    });
  }

  Future<List<Map>> getProducts(String email) async {
    String id;
    List<Map> list = [{}];

    await _fireStore
        .collection('Owners')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;
      }
    });

    await _fireStore
        .collection('Owners')
        .doc(id)
        .collection('menu')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                list.add({
                  'category': element.get('category'),
                  'product': element.get('product'),
                  'price': element.get('price'),
                });
              })
            });

    return list;
  }
}
