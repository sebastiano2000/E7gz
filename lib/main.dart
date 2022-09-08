import 'package:app_project/Screens/DrawerItSelf.dart';
import 'package:app_project/Screens/FeedBack.dart';
import 'package:app_project/Screens/OTP.dart';
import 'package:app_project/Screens/Profile.dart';
import 'package:app_project/Screens/Settings.dart';
import 'package:app_project/Screens/dashboard.dart';
import 'package:app_project/Screens/drawerCaller.dart';
import 'package:app_project/Screens/e7gz.dart';
import 'package:app_project/Screens/emailValidation.dart';
import 'package:app_project/Screens/getPhone.dart';
import 'package:app_project/Screens/language.dart';
import 'package:app_project/Screens/loading.dart';
import 'package:app_project/Screens/loadingData.dart';
import 'package:app_project/Screens/menu.dart';
import 'package:app_project/Screens/place.dart';
import 'package:app_project/Screens/resetPassword.dart';
import 'package:app_project/Screens/theme.dart';
import 'package:app_project/Screens/welcome.dart';
import 'package:app_project/Screens/forget.dart';
import 'package:app_project/Screens/login.dart';
import 'package:app_project/Screens/registration.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';

import 'Screens/PlaceDashboard.dart';
import 'Screens/changeEmail.dart';
import 'Screens/changeName.dart';
import 'Screens/noNetwork.dart';

void main() {
  runApp(
      EasyLocalization(
        child: MyApp(),
        path: "languages/langs",
        saveLocale: true,
        supportedLocales: [
          Locale('ar', 'EG'),
          Locale('en', 'US'),
        ],
      ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  FSBStatus status;

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, themee) {
        return MaterialApp(
          initialRoute: LoadingScreen.id,
          routes: {
            WelcomeScreen.id : (context) => WelcomeScreen(),
            LoginScreen.id : (context) => LoginScreen(),
            RegistrationScreen.id : (context) => RegistrationScreen(),
            ForgetPassScreen.id : (context) => ForgetPassScreen(),
            DashBoard.id : (context) => DashBoard(),
            OTPScreen.id : (context) => OTPScreen(),
            GetPhone.id : (context) => GetPhone(),
            LoadingScreen.id : (context) => LoadingScreen(),
            EmailValidation.id : (context) => EmailValidation(),
            ResetPassword.id : (context) => ResetPassword(),
            LoadingData.id : (context) => LoadingData(),
            DrawerCaller.id : (context) => DrawerCaller(),
            DrawerItSelf.id : (context) => DrawerItSelf(),
            Settings.id : (context) => Settings(),
            Profile.id : (context) => Profile(),
            LanguageTranslator.id : (context) => LanguageTranslator(),
            theme.id : (context) => theme(),
            FeedBack.id : (context) => FeedBack(),
            ChangeEmail.id: (context) => ChangeEmail(),
            ChangeName.id: (context) => ChangeName(),
            NoNetworkScreen.id: (context) => NoNetworkScreen(),
            PlaceDashboard.id: (context) => PlaceDashboard(),
          },
          debugShowCheckedModeBanner: false,
          theme: themee,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },


    );
  }
}
