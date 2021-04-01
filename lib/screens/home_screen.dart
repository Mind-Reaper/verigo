import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:verigo/pages/home_page.dart';
import 'package:verigo/pages/more_page.dart';
import 'package:verigo/pages/order_page.dart';
import 'package:verigo/pages/profile_page.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/state_provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

int oldPageIndex = 0;
PageController _controller = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    var stateProvider = Provider.of<StateProvider>(context, listen: false);
    // stateProvider.initiateHomePageController();
   stateProvider.addListener(() {
     if(oldPageIndex != stateProvider.pageIndex)
     _controller.animateToPage(stateProvider.pageIndex,
         duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
     oldPageIndex = stateProvider.pageIndex;

   });

    Provider.of<CreditCardProvider>(context, listen: false).getItem();

  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = Provider.of<StateProvider>(context);



    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          OrderPage(),
         ProfilePage(),
         MorePage(),
        ],
      ),
      backgroundColor: Color(0xfff6f6f6),
      bottomNavigationBar: SnakeNavigationBar.color(
        height: 60,
        unselectedItemColor: Color(0xff141414),
        snakeViewColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 12),
        unselectedLabelStyle: TextStyle(color: Color(0xff141414), fontSize: 12),
        snakeShape: SnakeShape(
            padding: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21))),
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/home.png'), size: 18),
              label: 'Home'),
          BottomNavigationBarItem(
              icon:
              ImageIcon(AssetImage('assets/images/request.png'), size: 18),
              label: 'My Orders'),
          BottomNavigationBarItem(
              icon:
              ImageIcon(AssetImage('assets/images/profile.png'), size: 18),
              label: 'Profile'),
          BottomNavigationBarItem(
              icon:
              ImageIcon(AssetImage('assets/images/more.png'), size: 18),
              label: 'More'),
        ],
        currentIndex: stateProvider.pageIndex,
        onTap: (int index) {
          stateProvider.changePageIndex(index);
        },
      ),
    );
  }
}
