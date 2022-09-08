import 'dart:io';
import 'dart:math' as math;
import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreateOwner extends StatefulWidget {
  static const String id = 'BecomeOwnerScreen';

  static String email;

  @override
  _CreateOwnerState createState() => _CreateOwnerState(email);
}

class _CreateOwnerState extends State<CreateOwner> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _CreateOwnerState(this._email);
  String _email;

  File image;
  String imgUrl;

  final _addressText = TextEditingController();
  String _address;

  final _locationText = TextEditingController();
  String _location;

  final nameText = TextEditingController();
  String _newName;

  final _formKey = GlobalKey<FormState>();

  String _category;

  List<Asset> images = List<Asset>();
  // ignore: non_constant_identifier_names
  List<Asset> AssetsSelected = List<Asset>();
  List<Asset> imagesOfPlaces = List<Asset>();
  List<Asset> imagesOfMenus = List<Asset>();
  List<Asset> imagesOfId = List<Asset>();

  List list = [];
  List list2 = [];
  List list3 = [];

  List<Asset> resultList = List<Asset>();

  // ignore: non_constant_identifier_names
  int _NumberOfPlaceImages = 0;
  // ignore: non_constant_identifier_names
  int _NumberOfMenuImages = 0;
  // ignore: non_constant_identifier_names
  int _NumberOfIdImages = 0;

  // bool _isUploaded = false;

  bool _showSpinner = false;

  bool _validate = false;

  Future<void> loadAssets(int number) async {
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: 'Cafe/Restaurant images'.tr().toString(),
          allViewTitle: 'All Photos'.tr().toString(),
          useDetailsView: false,
          selectCircleStrokeColor: "#FB5012",
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      AssetsSelected = resultList;
      if (number == 1) {
        imagesOfPlaces = AssetsSelected;
        _NumberOfPlaceImages = imagesOfPlaces.length;
        print(_NumberOfPlaceImages);
      } else if (number == 2) {
        imagesOfMenus = AssetsSelected;
        _NumberOfMenuImages = imagesOfMenus.length;
        print(_NumberOfMenuImages);
      } else if (number == 3) {
        imagesOfId = AssetsSelected;
        _NumberOfIdImages = imagesOfId.length;
      }
      images.clear();
    });
  }

  Future<void> realUpload(
      String category, String name, String address, String location) async {
    String id = await FireStoreServices().createNewOwner(_email);

    for (int i = 0; i < imagesOfPlaces.length; i++) {
      await saveImage(imagesOfPlaces[i], 1);
    }
    await FireStoreServices().addPathToDatabase(list, 1, id);

    for (int i = 0; i < imagesOfMenus.length; i++) {
      await saveImage(imagesOfMenus[i], 2);
    }

    await FireStoreServices().addPathToDatabase(list2, 2, id);

    for (int i = 0; i < imagesOfId.length; i++) {
      await saveImage(imagesOfId[i], 3);
    }

    await FireStoreServices().addPathToDatabase(list3, 3, id);

    await FireStoreServices()
        .addFields(category, name, address, location, _email, id);

    // await FireStoreServices().updateStatus(_email, StatusType.pending, true);

    // await FireStoreServices().makeRequest(_email);
  }

  Future<void> saveImage(Asset asset, int number) async {
    try {
      print(2);
      ByteData byteData =
          await asset.getByteData(); // requestOriginal is being deprecated
      List<int> imageData = byteData.buffer.asUint8List();

      int randomNumber = math.Random().nextInt(1000000);

      String imageLocation = 'images/image$randomNumber.jpg';

      StorageReference ref = FirebaseStorage()
          .ref()
          .child(imageLocation); // To be aligned with the latest firebase API(4.0)
      StorageUploadTask uploadTask = ref.putData(imageData);

      await uploadTask.onComplete;

      final refs = FirebaseStorage().ref().child(imageLocation);

      var imageString = await refs.getDownloadURL();

      if (number == 1) {
        list.add(imageString);
      } else if (number == 2) {
        list2.add(imageString);
      } else if (number == 3) {
        list3.add(imageString);
      }

      print(3);
      if (uploadTask.isComplete) {
        // _isUploaded = true;
        //Success! Upload is complete
      }
    } catch (e) {
      print('$e +10');
    }
  }

  // Future getImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   _UploadImageToFirebase(image);
  // }
  //
  // Future<void> _UploadImageToFirebase(File image) async {
  //   try {
  //     int randomNumber = Random().nextInt(1000000);
  //     String imageLocation = 'images/image${randomNumber}.jpg';
  //
  //     final StorageReference storageReference =
  //         FirebaseStorage().ref().child(imageLocation);
  //     final StorageUploadTask uploadTask = storageReference.putFile(image);
  //     await uploadTask.onComplete;
  //     FireStoreServices().addPathToDatabase(_uid, imageLocation);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Become an Owner'.tr().toString(),
        ),
        leading: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.pushNamed(context, DrawerItSelf.id);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          opacity: 0.5,
          progressIndicator: Lottie.asset('assets/indicator.json',
              height: 100, fit: BoxFit.cover, animate: true, repeat: true),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type of your Place'.tr().toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: DropDownFormField(
                      autovalidate: _validate,
                      errorText: 'Choose Type of the Place',
                      contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                      required: true,
                      titleText: 'My Place'.tr().toString(),
                      hintText: 'Choose Type'.tr().toString(),
                      value: _category,
                      onSaved: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": 'Cafe'.tr().toString(),
                          "value": 'Cafe'.tr().toString(),
                        },
                        {
                          "display": 'Restaurant'.tr().toString(),
                          "value": 'Restaurant'.tr().toString(),
                        },
                        {
                          "display": 'Gym'.tr().toString(),
                          "value": 'Gym'.tr().toString(),
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Cafe/Restaurant Name'.tr().toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Form(
                      key: _formKey,
                      child: LTextField(
                        icon: Icons.restaurant_menu,
                        isSecured: false,
                        hintText: 'Enter Name'.tr().toString(),
                        keyboardType: TextInputType.name,
                        maxLength: 30,
                        validator: Validations().cafeValidator,
                        onChanged: (String val) => _newName = val,
                        controller: nameText,
                        isAutoValidate: _validate,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Enter Your Cafe/Restaurant Location'.tr().toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      maxLines: null,
                      controller: _locationText,
                      onChanged: (value) {
                        setState(() {
                          _location = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        hintText: 'Area'.tr().toString(),
                        hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Your Cafe/Restaurant Address'.tr().toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      maxLines: null,
                      controller: _addressText,
                      onChanged: (value) {
                        setState(() {
                          _address = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        hintText: 'Street/Unit'.tr().toString(),
                        hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    'Upload Photos of your Place'.tr().toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadAssets(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 55,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '\t\t\t\t$_NumberOfPlaceImages\t\t' +
                              'Images Selected'.tr().toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Upload Photos of Your Cafe/Restaurant Menu'.tr().toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadAssets(2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 55,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '\t\t\t\t$_NumberOfMenuImages\t\t' +
                              'Images Selected'.tr().toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Upload Your Id Card (Double Faces)'.tr().toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadAssets(3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 55,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '\t\t\t\t$_NumberOfIdImages\t\t' +
                              'Images Selected'.tr().toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate() &&
                          imagesOfPlaces.length != 0 &&
                          imagesOfMenus.length != 0 &&
                          imagesOfId.length != 0 &&
                          _category != null &&
                          _newName != null &&
                          _location != null &&
                          _address != null) {
                        setState(() {
                          _showSpinner = true;
                          _validate = false;
                        });

                        await realUpload(_category, _newName, _address, _location);

                        _category = null;
                        nameText.clear();
                        _locationText.clear();
                        _addressText.clear();

                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // bool isDeleted = prefs.get('isMain');
                        //
                        // if(isDeleted == null)
                        //   await FireStoreServices().deleteRequest('');
                        //
                        // prefs.setBool('pendingScreen', true);
                        //
                        // Navigator.pushReplacementNamed(
                        //     context, ConfirmationScreen.id);

                        setState(() {
                          _showSpinner = false;
                        });
                      } else {
                        setState(() {
                          _validate = true;
                        });
                        if (_category == null) {
                          alertFlutter(
                            'You did not specify the place Type',
                            'Please choose place Type',
                            AlertType.error,
                            Colors.red,
                          );
                        } else if (nameText.toString() == null) {
                          alertFlutter(
                            'You did not specify the name of the Place',
                            'Please provide a name',
                            AlertType.error,
                            Colors.red,
                          );
                        } else if (_location == null) {
                          alertFlutter(
                            'You did not specify the Area of the place',
                            'Please provide an exact Area',
                            AlertType.error,
                            Colors.red,
                          );
                        } else if (_address == null) {
                          alertFlutter(
                            'You did not specify the Address of the place',
                            'Please provide an Address',
                            AlertType.error,
                            Colors.red,
                          );
                        } else if (imagesOfPlaces.length == 0 ||
                            imagesOfMenus.length == 0 ||
                            imagesOfId.length == 0) {
                          alertFlutter(
                            'You did not upload the required images',
                            'Please upload the missing images',
                            AlertType.error,
                            Colors.red,
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding:
                          EasyLocalization.of(context).locale == Locale('ar', 'EG')
                              ? const EdgeInsets.only(top: 50, right: 17)
                              : const EdgeInsets.only(left: 20, top: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue[900],
                        ),
                        child: Center(
                          child: Text(
                            'Apply'.tr().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 33,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        height: 56,
                        width: 310,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void alertFlutter(String title, String desc, AlertType icon, Color color) {
    var style = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: color,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: icon,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            'Confirm'.tr().toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
