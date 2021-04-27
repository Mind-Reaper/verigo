import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:verigo/models/card_model.dart';
import 'package:verigo/models/user_model.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/google_map_provider.dart';
import 'package:verigo/providers/notification_provider.dart';
import 'package:verigo/providers/order_provider.dart';
import 'package:verigo/providers/payment_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/home_screen.dart';

import 'constants.dart';
import 'providers/booking_provider.dart';
import 'providers/state_provider.dart';
import 'screens/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserCreditCardAdapter());
  Hive.registerAdapter(UserAdapter());
  PaystackPlugin().initialize(publicKey: 'pk_test_162f59052b353792406b069174446f4419d1f599');
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 15.0
    ..progressColor = Color(0xff7A4B9D)
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Color(0xff7A4B9D)
    ..textAlign = TextAlign.center
    ..textColor = Colors.white
    ..textStyle = TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0)
    ..maskType = EasyLoadingMaskType.black

    ..infoWidget = Icon(
      FontAwesomeIcons.infoCircle,
      size: 50,
      color: Colors.white,
    )
    ..successWidget = Icon(
      FontAwesomeIcons.solidCheckCircle,
      size: 50,
      color: Colors.white,
    )
    ..errorWidget = Icon(
      Icons.cancel,
      size: 50,
      color: Colors.white,
    )
    ..userInteractions = false
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
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
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
    

    // Show Splash Screen For Few Seconds
    Timer(Duration(seconds: 1), () async {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      var authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      await userProvider.getUser();
      User user = userProvider.currentUser;

      Location().enableBackgroundMode(enable: true);

      if (user?.accessToken == null) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => IntroductionScreen(),
            ));
      } else {
       await authProvider
            .getCurrentUser(context, accessToken: user.accessToken)
            .then((userMap) async {
          if (userMap == null) {
            EasyLoading.showInfo('Session Expired');
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => IntroductionScreen(),
                ));
          } else {
            await userProvider.updateUser(User(
              name: userMap['name'],
              surname: userMap['surname'],
              emailAddress: userMap['emailAddress'],
              id: userMap['id'],
              walletBalance: userMap['walletBalance'],
              phoneNumber: userMap['phoneNumber'],
              verigoNumber: userMap['affiliateCode'],
            ));

            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                ));
          }
        }).timeout(Duration(seconds: 10), onTimeout: () {
          EasyLoading.showInfo('Session Expired');
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => IntroductionScreen(),
              ));
        });
      }
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
