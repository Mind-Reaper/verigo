import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:verigo/screens/signup_screen.dart';
import 'package:verigo/widgets/buttons.dart';

import '../constants.dart';
import 'login_screen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController pageController = PageController();
  ValueNotifier _currentPageNotifier = ValueNotifier<int>(0);
  List<Widget> pages = [
    IntroPage(
        title: 'Rapid Delivery',
        subtitle: 'Your parcels are delivered as quicky as possible.'),
    IntroPage(
        title: 'Monitor your parcel easily',
        subtitle:
            "Track your item to know how far your delivery have gone using your tracking ID."),
    IntroPage(
        title: 'Pickup & Drop System',
        subtitle:
            "Get your items picked up & delivered from the comfort of your home."),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: Center(
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        image: AssetImage(
          'assets/images/container.jpg',
        ),
        fit: BoxFit.cover,
          )),
child:    Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 40),
                  child: namedLogo(),
                ),
                Expanded(
                  child: Container(
                    child: PageView.builder(
                        physics: BouncingScrollPhysics(),
                        // controller: pageController,
                        itemCount: 3,
                        onPageChanged: (page) {
                          _currentPageNotifier.value = page;
                        },
                        itemBuilder: (context, page) {
                          return pages[page];
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CirclePageIndicator(
                    currentPageNotifier: _currentPageNotifier,
                    itemCount: 3,
                  ),
                ),
                Container(
                    height: 120,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Let's get started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: RoundedButton(
                                    title: 'Sign In',
                                    active: true,
                                    inverse: true,
                                    onPressed: () {
                                      pushPage(context, LoginScreen());
                                    })),
                            SizedBox(width: 20),
                            Expanded(
                                child: RoundedButton(
                                    title: 'Sign Up',
                                    active: true,
                                    inverse: true,
                                    onPressed: () {
                                      pushPage(context, SignupScreen());
                                    })),
                          ])
                        ],
                      ),
                    ))
              ]),
        ),
      )),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const IntroPage({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Theme.of(context).primaryColor),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 150,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(top: 50, bottom: 40),
//         child: namedLogo(),
//       ),
//       Container(
//         child: PageView.builder(
//             physics: BouncingScrollPhysics(),
//             // controller: pageController,
//             itemCount: 3,
//             onPageChanged: (page) {
//               _currentPageNotifier.value = page;
//             },
//             itemBuilder: (context, page) {
//               return pages[page];
//             }),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: CirclePageIndicator(
//           currentPageNotifier: _currentPageNotifier,
//           itemCount: 3,
//         ),
//       ),
//       Container(
//           height: 120,
//           width: double.infinity,
//           color: Theme.of(context).primaryColor,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 Text(
//                   "Let's get started",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Row(children: [
//                   Expanded(
//                       child: RoundedButton(
//                           title: 'Sign In',
//                           active: true,
//                           inverse: true,
//                           onPressed: () {
//                             pushPage(context, LoginScreen());
//                           })),
//                   SizedBox(width: 20),
//                   Expanded(
//                       child: RoundedButton(
//                           title: 'Sign Up',
//                           active: true,
//                           inverse: true,
//                           onPressed: () {
//                             pushPage(context, SignupScreen());
//                           })),
//                 ])
//               ],
//             ),
//           ))
//     ])