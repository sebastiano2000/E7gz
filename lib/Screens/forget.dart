import 'package:app_project/Components/Constants.dart';
import 'package:app_project/Components/FadeAnimation.dart';
import 'package:app_project/Components/fireStore_services.dart';
import 'package:app_project/Screens/emailValidation.dart';
import 'package:app_project/Screens/resetPassword.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';

class ForgetPassScreen extends StatefulWidget {
  static const String id = 'ForgetScreen';

  @override
  _ForgetPassScreenState createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  String _adminEmail = 'E7gzTeam@gmail.com';
  String _adminPassword = 'E7gz1234';

  String _email;
  String _code;

  @override
  void initState() {
    super.initState();
    _code = '';
  }

  void getCode() {
    for (int i = 0; i < 6; i++) {
      _code += Random().nextInt(10).toString();
    }
  }

  bool showSpinner = false;

  void sendEmail(String userEmail) async {
    getCode();

    final smtpServer = gmail(_adminEmail, _adminPassword);

    // ignore: non_constant_identifier_names
    var Date = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, '\t', h, ':', nn, ' ', am]);

    final message = Message()
      ..from = Address(_adminEmail, 'E7gz Team')
      ..recipients.add(_email)
      ..subject = 'Reset your password for E7gz Application $Date'
      ..text = 'Hello,'
          '\n\nPlease Enter this confirmation code in your application to reset your password:\n\n'
          ' $_code'
          ' \n\nIf you didn\'t ask to reset your password, you can ignore this email.\n\n'
          'Thanks,\n\n'
          'Your E7gz Team.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFd4ebe8),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      key: _scaffoldKey,
      backgroundColor: Color(0xFFd4ebe8),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        opacity: 0.5,
        progressIndicator: Lottie.asset(
            'assets/indicator.json',
            height: 100,
            fit: BoxFit.cover,
            animate: true,
            repeat: true),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [
              Container(
                height: 400,
                child: FlareActor(
                  'assets/read.flr',
                  animation: 'read',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FadeAnimation(
                1.2,
                AutoSizeText(
                  'We will send you an email\n to reset your password',
                  style: TextStyle(fontSize: 20),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: FadeAnimation(
                    1.3,
                    LTextField(
                      icon: Icons.email,
                      isSecured: false,
                      hintText: "Enter your email address",
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 30,
                      validator: Validations().emailValidator,
                      onChanged: (String val) => _email = val,
                      controller: _emailController,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                1.4,
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: loadingButtons(
                      loadingType: SpinKitFadingCircle(
                        color: Colors.white,
                      ),
                      colour: Colors.green,
                      text: 'Send',
                      width: 350,
                      textColor: Colors.white,
                      onTap: (startLoading, stopLoading, btnState) async {
                        if (_formKey.currentState.validate()) {
                          startLoading();
                          setState(() {
                            showSpinner = true;
                          });

                          bool _isConnected =
                              await Connection().checkConnection();

                          if (_isConnected) {
                            try {
                              bool isValid =
                                  await FireStoreServices().checkEmail(_email);

                              if (isValid) {
                                sendEmail(_email);

                                setState(() {
                                  EmailValidation.emailCode = _code;
                                  ResetPassword.userEmail = _email;
                                });

                                Navigator.pushNamed(
                                    context, EmailValidation.id);

                                stopLoading();
                                setState(() {
                                  showSpinner = false;
                                });
                                _emailController.clear();
                              } else {
                                showSnackBar(_scaffoldKey,
                                        "Email address does not exist!\n please try again")
                                    .show();

                                setState(() {
                                  showSpinner = false;
                                  _emailController.clear();
                                });

                                stopLoading();

                                return;
                              }
                            } catch (e) {
                              stopLoading();
                              setState(() {
                                showSpinner = false;
                                _emailController.clear();
                              });
                              showSnackBar(_scaffoldKey,
                                      "Email address does not exist!\n please try again")
                                  .show();
                            }
                          } else {
                            showSnackBar(_scaffoldKey, 'No internet connection')
                                .show();
                            stopLoading();
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      }),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
