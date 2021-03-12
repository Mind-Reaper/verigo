import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:verigo/models/card_model.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/google_map_provider.dart';
import 'package:verigo/providers/user_provider.dart';

import 'constants.dart';
import 'providers/state_provider.dart';
import 'screens/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserCreditCardAdapter());
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.rotatingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 15.0
    ..progressColor = Color(0xff7A4B9D)
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Color(0xffF48043)
    ..textAlign = TextAlign.center
    ..textColor = Colors.white
    ..textStyle = TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0)
    ..maskType = EasyLoadingMaskType.black
    ..infoWidget = Icon(FontAwesomeIcons.infoCircle, size: 50, color: Colors.white,)
    ..successWidget = Icon(FontAwesomeIcons.solidCheckCircle, size: 50, color: Colors.white,)
    ..errorWidget = Icon(Icons.cancel, size: 50, color: Colors.white,)
    ..userInteractions = true
..toastPosition = EasyLoadingToastPosition.bottom


    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (context) => StateProvider()),
        ChangeNotifierProvider(create: (context) => CreditCardProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => GoogleMapProvider()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          theme: ThemeData(
              fontFamily: 'LeagueSpartan',
              primaryColor: Color(0xff7A4B9D),
              scaffoldBackgroundColor: Color(0xfffefefe),
              textTheme: TextTheme(
                  headline1: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xff414141),
                  ),
                  headline2: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                    color: Color(0xff414141),
                  ),
                  headline3: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color(0xff414141),
                  ),
                  button: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xfffefefe),
                  ),
                  bodyText1: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xff414141),
                  ),
                  bodyText2: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black54,
                  ))),
          home: SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.openBox('app_data');

    // Show Splash Screen For Few Seconds
    Timer(Duration(seconds: 2), () async {
      Location().enableBackgroundMode(enable: true);
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => IntroductionScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: namedLogo(),
      ),
    );
  }
}
