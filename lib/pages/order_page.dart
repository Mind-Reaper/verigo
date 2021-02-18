import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/screens/delivery_request_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:verigo/widgets/stacked_display.dart';

import '../constants.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  PageController pageController = PageController();

  int cupertinoTabBarIVValue = 0;
  int cupertinoTabBarIVValueGetter() => cupertinoTabBarIVValue;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(
        context,
        title: 'My Orders',
        blackTitle: true,
        centerTitle: false,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        showbackArrow: false
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoTabBar.CupertinoTabBar(
                Colors.transparent,
                Theme.of(context).primaryColor,
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                        color: cupertinoTabBarIVValue == 0
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: Text(
                      "In Transit",
                      style: TextStyle(
                        color: cupertinoTabBarIVValue == 1
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: Text(
                      "Completed",
                      style: TextStyle(
                        color: cupertinoTabBarIVValue == 2
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                cupertinoTabBarIVValueGetter,
                (int index) {
                  setState(() {
                    cupertinoTabBarIVValue = index;
                    pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                  });
                },
                useShadow: false,
                innerVerticalPadding: 0,
                outerHorizontalPadding: 0,
                borderRadius: BorderRadius.circular(15),
                // curve: Curves.bounceOut,
                // duration: Duration(seconds: 1),

              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {


                if(cupertinoTabBarIVValue != index) {
                  cupertinoTabBarIVValue = index;
                }
                });
              },
              children: [Pending(),
              Transit(),
                Completed()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Pending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        if (order['pending']) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: StackedOrder(
              id: order['id'],
              logName: order['log_name'],
              price: order['price'],
              pending: order['pending'],
              orderDate: order['order_date'],
              senderName: order['s_name'],
              receiverName: order['r_name'],
              pickupDate: order['pickup_date'],
              deliveryDate: order['delivery_date'],
              trackingId: order['tracking_id'],
              completed: order['completed'],
              transit: order['transit'],
              senderNo: order['s_no'],
              receiverNo: order['r_no'],
              carrier: order['carrier'],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class Transit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        if (order['transit']) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: StackedOrder(
              id: order['id'],
              logName: order['log_name'],
              price: order['price'],
              pending: order['pending'],
              orderDate: order['order_date'],
              senderName: order['s_name'],
              receiverName: order['r_name'],
              pickupDate: order['pickup_date'],
              deliveryDate: order['delivery_date'],
              trackingId: order['tracking_id'],
              completed: order['completed'],
              transit: order['transit'],
              senderNo: order['s_no'],
              receiverNo: order['r_no'],
              carrier: order['carrier'],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        if (order['completed']) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: StackedOrder(
              id: order['id'],
              logName: order['log_name'],
              price: order['price'],
              pending: order['pending'],
              orderDate: order['order_date'],
              senderName: order['s_name'],
              receiverName: order['r_name'],
              pickupDate: order['pickup_date'],
              deliveryDate: order['delivery_date'],
              trackingId: order['tracking_id'],
              completed: order['completed'],
              transit: order['transit'],
              senderNo: order['s_no'],
              receiverNo: order['r_no'],
              carrier: order['carrier'],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}