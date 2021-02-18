import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'constants.dart';
import 'providers/state_provider.dart';
import 'screens/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => StateProvider())],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
    Timer(Duration(seconds: 3), () {
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
