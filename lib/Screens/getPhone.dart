import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/auth_services.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/OTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class GetPhone extends StatefulWidget {
  static const String id = 'GetPhone';

  @override
  _GetPhoneState createState() => _GetPhoneState();
}

class _GetPhoneState extends State<GetPhone> {

  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  bool isValid = false;
  TextEditingController _phoneController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  bool _isRegistered;


  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'EG');

    setState(() {
      this.number = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        title: Text('Phone Validation'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 30,color: Colors.black,), onPressed: () {
          Navigator.pop(context);
        }
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.89,
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InternationalPhoneNumberInput(
                        initialValue: number,
                        selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, showFlags: true, useEmoji: true),
                        inputDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepOrangeAccent),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: 'Enter your Phone Number',
                            prefixIcon: Icon(Icons.phone_iphone),
                            filled: true,
                            fillColor: Colors.grey[350],
                            labelText: 'PhoneNumber',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                        autoValidate: true,
                        onInputValidated: (bool isRight) {
                          !isRight ? isValid = false : isValid = true;
                        },
                        onInputChanged: (PhoneNumber newNumber) {
                          number = newNumber;
                        },
                        textFieldController: _phoneController,
                        maxLength: 11,
                      ),
                    ),
                    SizedBox(height: 20,),
                    loadingButtons(
                      loadingType: SpinKitDualRing(
                        color: Colors.white,
                      ),
                      width: 350,
                      textColor: Colors.white,
                      text: 'Continue',
                      colour: Colors.purple,
                      onTap: (startLoading, stopLoading, btnState) async{
                              if(isValid) {
                                _isRegistered =
                                await FireStoreServices().checkPhoneNumber(
                                    number.toString());
                                if (_isRegistered) {
                                  showSnackBar(_scaffoldKey, _isRegistered
                                      ? "Phone Number is Already Registered!"
                                      : "Email address is Already Registered!").show();
                                  _phoneController.clear();
                                  stopLoading();
                                  return;

                                } else {
                                  startLoading();
                                  getPhoneNumber(number.toString());
                                  AuthServices.phoneNumber = number.toString();
                                  Navigator.pushReplacementNamed(context, OTPScreen.id);
                                }
                              }
                        }
                    )
                  ],
                ),
              ),
        ),
      ),
    ));
  }
}
