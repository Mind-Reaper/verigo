import 'package:flutter/material.dart';

import 'my_container.dart';

class StackedDisplay extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget child;


  const StackedDisplay({Key key, this.icon, this.title, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FloatingContainer(
                color: Color(0xfff6f6f6),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingContainer(
              width: double.infinity,
              // height: 60,
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 15),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline3,
                  )
                ],
              )),
        )
      ],
    );
  }
}

class StackedOrder extends StatelessWidget {

  final String id;
  final bool transit;
  final bool pending;
  final bool completed;
  final String logName;
  final String senderName;
  final String receiverName;
  final String senderNo;
  final String receiverNo;
  final String orderDate;
  final String pickupDate;
  final String deliveryDate;
  final String trackingId;
  final String carrier;
  final String price;


  const StackedOrder({Key key, this.id, this.transit: false, this.pending: false, this.completed: false, this.logName, this.senderName, this.receiverName, this.senderNo, this.receiverNo, this.orderDate, this.pickupDate, this.deliveryDate, this.trackingId, this.carrier, this.price, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FloatingContainer(
                color: Color(0xfff6f6f6),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logName,
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                             if(transit)     Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Sender's Name: $senderName",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  if(completed)      Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Receiver's Name: $receiverName",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  if(completed)    Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Receiver's Mobile Number: $receiverNo",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  if(transit)    Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Sender's Mobile Number: $senderNo",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Carrier: $carrier",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),

                                  if(pending)    Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Order Date: $orderDate",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  if(transit)     Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Pickup Date: $pickupDate",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  if(completed)    Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Delivery Date: $deliveryDate",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Tracking ID: $trackingId",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           ImageIcon(
                            transit?   AssetImage('assets/images/transit.png') : completed? AssetImage('assets/images/completed.png') : pending? null:null,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingContainer(
              padding: false,
              width: double.infinity,
              // height: 60,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              topRight: Radius.circular(18)),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              'N$price',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: Row(
                      children: [
                        ImageIcon(AssetImage('assets/images/request.png')),
                        SizedBox(width: 15),
                        Text(
                          "Order ID-$id",
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
