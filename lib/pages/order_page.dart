import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/order_provider.dart';
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
      appBar: appBar(context,
          title: 'My Orders',
          blackTitle: true,
          centerTitle: false,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          showbackArrow: false),
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
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: cupertinoTabBarIVValue == 0
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        "In Transit",
                        style: TextStyle(
                          color: cupertinoTabBarIVValue == 1
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          color: cupertinoTabBarIVValue == 2
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                cupertinoTabBarIVValueGetter,
                (int index) {
                  setState(() {
                    cupertinoTabBarIVValue = index;
                    pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn);
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
                  if (cupertinoTabBarIVValue != index) {
                    cupertinoTabBarIVValue = index;
                  }
                });
              },
              children: [
                KeepAlivePage(child: Pending()),
                KeepAlivePage(child: Transit()),
                KeepAlivePage(child: Completed())
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Pending extends StatefulWidget {
  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  String searchResult ='';
  List<PendingOrder> searchedPending = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadPage();
  }

  Future<void> reloadPage() async {
    Provider.of<OrderProvider>(context, listen: false).getPending(context);
    await Future.delayed(Duration(seconds: 8));
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    if(searchResult.isNotEmpty) {
    searchedPending = orderProvider.pendingOrders.where((e) =>
          e.reference.contains(searchResult)).toList();
    } else {
      searchedPending = orderProvider.pendingOrders;
    }
    return RefreshIndicator(
      onRefresh: reloadPage,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchResult = value.toUpperCase();
                  });
                },
                autocorrect: false,
                decoration: fieldDecoration.copyWith(
                    fillColor: Colors.white,
                    hintText: 'Input Reference Number',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xffF48043),
                    ))),
          ),
          Expanded(
            child: Builder(

                builder: (context) {
                  if (orderProvider.pendingOrders.isEmpty) {
                    return ListView(

                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "You don't have any pending order.\nDrag down to reload",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                  if (searchedPending.isEmpty) {
                    return ListView(

                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "No results",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: searchedPending.length,
                    itemBuilder: (context, index) {
                      PendingOrder order = searchedPending[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: PendingStackedOrder(
                          bookingId: order.bookingId,
                          reference: order.reference,
                          parcel: order.parcel,
                          partner: order.partner,
                          pdc: order.pdc,
                          ppc: order.ppc,
                          amount: order.amount,
                          veriSure: order.veriSure,
                          createdOn: order.createdOn,
                          status: order.status,
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Transit extends StatefulWidget {
  @override
  _TransitState createState() => _TransitState();
}

class _TransitState extends State<Transit> {

  String searchResult  = '' ;
  List<PendingOrder> searchedTransit = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadPage();
  }

  Future<void> reloadPage() async {
   Provider.of<OrderProvider>(context, listen: false).getTransit(context);

    await Future.delayed(Duration(seconds: 8));
  }
  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    if(searchResult.isNotEmpty) {
      searchedTransit = orderProvider.transitOrders.where((e) =>
          e.reference.contains(searchResult)).toList();
    } else {
      searchedTransit = orderProvider.transitOrders;
    }
   return RefreshIndicator(
      onRefresh: reloadPage,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchResult = value.toUpperCase();
                });
              },
                autocorrect: false,
                decoration: fieldDecoration.copyWith(
                    fillColor: Colors.white,
                    hintText: 'Input Reference Number',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xffF48043),
                    ))),
          ),
          Expanded(
            child: Builder(

                builder: (context, ) {
                  if (orderProvider.transitOrders.isEmpty) {
                    return ListView(

                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "You don't have any order in transit.\nDrag down to reload",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                  if (searchedTransit.isEmpty) {
                    return ListView(

                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "No results",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: searchedTransit.length,
                    itemBuilder: (context, index) {
                      PendingOrder order = searchedTransit[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TransitStackedOrder(
                          bookingId: order.bookingId,
                          reference: order.reference,
                          parcel: order.parcel,
                          partner: order.partner,
                          pdc: order.pdc,
                          ppc: order.ppc,
                          amount: order.amount,
                          veriSure: order.veriSure,
                          createdOn: order.createdOn,
                          status: order.status,
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadPage();
  }

  String searchResult = '';
  List<PendingOrder> searchedCompleted;



  Future<void> reloadPage() async {
     Provider.of<OrderProvider>(context, listen: false).getCompleted(context);
    await Future.delayed(Duration(seconds: 8));
  }
  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    if(searchResult.isNotEmpty) {
      searchedCompleted = orderProvider.completedOrders.where((e) =>
          e.reference.contains(searchResult)).toList();
    } else {
      searchedCompleted = orderProvider.completedOrders;
    }

   return RefreshIndicator(
      onRefresh: reloadPage,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchResult = value.toUpperCase();
                });
              },
                autocorrect: false,
                decoration: fieldDecoration.copyWith(
                    fillColor: Colors.white,
                    hintText: 'Input Reference Number',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xffF48043),
                    ))),
          ),
          Expanded(
            child:
               Builder(

                 builder: (context) {
                   if (orderProvider.completedOrders.isEmpty) {
                     return ListView(

                       children: [
                         SizedBox(height: 200),
                         Center(
                           child: Text(
                             "You don't have any delivered order.\nDrag down to reload",
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ],
                     );
                   }
                   if (searchedCompleted.isEmpty) {
                     return ListView(

                       children: [
                         SizedBox(height: 200),
                         Center(
                           child: Text(
                             "No results",
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ],
                     );
                   }
                   return ListView.builder(
                        itemCount: searchedCompleted.length,
                        itemBuilder: (context, index) {
                          PendingOrder order = searchedCompleted[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TransitStackedOrder(
                              bookingId: order.bookingId,
                              reference: order.reference,
                              parcel: order.parcel,
                              partner: order.partner,
                              pdc: order.pdc,
                              ppc: order.ppc,
                              amount: order.amount,
                              veriSure: order.veriSure,
                              createdOn: order.createdOn,
                              status: order.status,
                            ),
                          );
                        },
                      );
                 }
               ),

          ),
        ],
      ),
    );
  }
}


class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
