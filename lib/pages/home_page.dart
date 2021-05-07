import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/pages/order_page.dart';
import 'package:verigo/providers/google_map_provider.dart';
import 'package:verigo/providers/order_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/get_estimate_screen.dart';
import 'package:verigo/screens/notifications_screen.dart';
import 'package:verigo/screens/order_tracking_screen.dart';
import 'package:verigo/widgets/history_widget.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool online = true;
  PendingOrder order;



  buildHomePage() {
    var stateProvider = Provider.of<StateProvider>(context);
    var orderProvider = Provider.of<OrderProvider>(context);
    var map = Provider.of<GoogleMapProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(children: [
          SizedBox(height: 200),
          FloatingContainer(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                    onSubmitted: (reference) {
                      if(reference.isNotEmpty) {
                        map.trackBooking(context, reference).then((order) {
                          if(order != null) {
                            if (order.length == 1) {
                              pushPage(context, TrackingScreen(reference,
                                orderStage: order.orderPlacedStage,
                                orderPlacedDate: order.orderPlacedDate,
                                dispatchedDate: order.dispatchDate,
                                enrouteDate: order.enrouteDate,
                                deliveredDate: order.deliveredDate,
                                notes: order.orderPlacedNotes,
                              ),);
                            }
                            if(order.length == 2) {
                              pushPage(context, TrackingScreen(reference,
                                orderStage: order.dispatchStage,
                                orderPlacedDate: order.orderPlacedDate,
                                dispatchedDate: order.dispatchDate,
                                enrouteDate: order.enrouteDate,
                                deliveredDate: order.deliveredDate,
                                notes: order.dispatchNotes,
                              ),);
                            }
                            if(order.length == 3) {
                              pushPage(context, TrackingScreen(reference,
                                orderStage: order.enrouteStage,
                                orderPlacedDate: order.orderPlacedDate,
                                dispatchedDate: order.dispatchDate,
                                enrouteDate: order.enrouteDate,
                                deliveredDate: order.deliveredDate,
                                notes: order.enrouteNotes,
                              ),);
                            }
                            if(order.length == 4) {
                              pushPage(context, TrackingScreen(reference,
                                orderStage: order.deliveredStage,
                                orderPlacedDate: order.orderPlacedDate,
                                dispatchedDate: order.dispatchDate,
                                enrouteDate: order.enrouteDate,
                                deliveredDate: order.deliveredDate,
                                notes: order.deliveredNotes,
                              ),);
                            }
                          }
                        });
                      }

                    },
                      decoration: fieldDecoration.copyWith(
                        fillColor: Colors.white,
hintText: "Tracking number",
                        prefixIcon: Icon(Icons.search, color: Color(0xfff48043), size: 30,)
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: ImageIcon(
                         AssetImage('assets/images/barcode.png'),
                        color: Colors.white,

                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xfff48043),
                      borderRadius: BorderRadius.circular(5),

                    )
                  )
                ],
              )
          ),
          SizedBox(height: 20),
          Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 30),

              if(orderProvider.order != null)    OrderHistory(
                    orderId: orderProvider.order.reference,
                    timestamp: orderProvider.order.createdOn,
                    orderStatus: orderProvider.order.status,
                    verisure: orderProvider.order.veriSure,
                    logistics: orderProvider.order.partner,
                  ),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {

                  stateProvider.changePageIndex(1);
                },
                child: FloatingContainer(
                    width: double.infinity,
                    // height: 60,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/history.png'),
                                size: 23,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Order History',
                                style: Theme.of(context).textTheme.headline3,
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 15, color: Colors.grey)
                        ])),
              )
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              pushPage(context, GetEstimateScreen());
            },
            child: FloatingContainer(
                width: double.infinity,
                // height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ImageIcon(
                          AssetImage('assets/images/fastcar.png'),
                          size: 23,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'New Delivery Request',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),

                    Icon(Icons.add,
                        size: 15, color: Colors.grey)
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
     orderProvider.getLastRequest(context);

  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var stateProvider = Provider.of<StateProvider>(context);
    online = stateProvider.online;
    return GestureDetector(

      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Stack(children: [
        buildHomePage(),
        Container(
          height: 225,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/banner.png'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Container(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              stateProvider.changePageIndex(2);
              },
                            child: Container(
                              height: 55,
                              width: 55,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                AssetImage('assets/images/profilepic.jpg'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome,",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${userProvider.currentUser.name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(color: Colors.white),
                                    )
                                  ]),
                            ),
                          ),

                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          FloatingActionButton(
                            heroTag: 'notify',
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.notifications_active),
                            onPressed: () {
                              pushPage(context, KeepAlivePage(child: NotificationScreen()));
                            },
                          )
                        ])
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
