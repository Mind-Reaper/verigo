import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/google_map_provider.dart';
import 'package:verigo/providers/order_provider.dart';
import 'package:verigo/screens/order_summary_screen.dart';
import 'package:verigo/screens/order_tracking_screen.dart';

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

class PendingStackedOrder extends StatelessWidget {
  final String bookingId;
  final String reference;
  final String partner;
  final String parcel;
  final int amount;
  final bool veriSure;
  final String status;
  final String ppc;
  final String pdc;
  final String createdOn;

  const PendingStackedOrder(
      {Key key,
      this.bookingId,
      this.reference,
      this.partner,
      this.parcel,
      this.amount,
      this.veriSure,
      this.status,
      this.ppc,
      this.pdc,
      this.createdOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(createdOn);
    var orderProvider = Provider.of<OrderProvider>(context);
    var booking = Provider.of<BookingProvider>(context);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                partner,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              if(parcel!= null)     Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "${parcel.trim().replaceAll(', ', '\n')}",
                                  style: TextStyle(fontSize: 16
                                      ,height: 1.2
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Verisure Premium ${veriSure? '✔' : '✖️'}️',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              //    ImageIcon(
                              // AssetImage('assets/images/transit.png'),
                              //   size: 30,
                              //   color: Theme.of(context).primaryColor,
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async{
                                if (status != 'PENDINGPAYMENT') {

                                  var result = await showTextInputDialog(
                                      context: context,
                                      title: 'Verify Parcel Code',
                                      message: 'Input parcel code from rider to verify he is the one to pick your packages',
                                      okLabel: 'Verify',
                                      textFields: [
                                        DialogTextField(

                                          hintText: 'Parcel Verification Code',
                                        )
                                      ]);
                                  if(result != null) {
                                    booking.verifyPPC(context, bookingId, result[0]).then((value) {
                                      if(value) {
                                        orderProvider.getTransit(context);
                                        orderProvider.getPending(context);
                                        showSnackBarSuccess(context, 'Pickup Verified');
                                      }
                                    });
                                  } else {
                                   showSnackBar(context, 'Verification Cancelled');
                                  }
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: status != 'PENDINGPAYMENT'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.verified_user_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Verify',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${Jiffy(dateTime).format("MMMM d, hh:mm a")}",
                                style: TextStyle(fontSize: 16),
                              ),
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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
orderProvider.bookingSummary(context, bookingId).then((summary) {
  if(summary!=null) {
    pushPage(context, OrderSummaryScreen(
carrier: summary.carrier,
      stringedParcel: summary.parcel,
      dropoffAddress: summary.dropoffAddress,
      pickupAddress: summary.pickupAddress,
      dropoffName: summary.dropoffName,
      pickupName: summary.pickupName,
      dropoffNumber: summary.dropoffNumber,
      pickupNumber: summary.pickupNumber,
      pickupTime: summary.pickupTime,
      parcelDescription: summary.description,
      provider: summary.provider,
      providerNumber: summary.providerPhoneNumber,

    ));
  }
});
            },
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
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              topRight: Radius.circular(18)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                'N$amount',
                                style: Theme.of(context).textTheme.button,
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
                          Flexible(
                            child: Text(
                              "Reference-$reference",
                              style: Theme.of(context).textTheme.button.copyWith(
                                  color: Color(0xff414141),
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(width: 50),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}

class TransitStackedOrder extends StatelessWidget {
  final String bookingId;
  final String reference;
  final String partner;
  final String parcel;
  final int amount;
  final bool veriSure;
  final String status;
  final String ppc;
  final String pdc;
  final String createdOn;

  const TransitStackedOrder(
      {Key key,
      this.bookingId,
      this.reference,
      this.partner,
      this.parcel,
      this.amount,
      this.veriSure,
      this.status,
      this.ppc,
      this.pdc,
      this.createdOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(createdOn);
    var orderProvider = Provider.of<OrderProvider>(context);
    var map = Provider.of<GoogleMapProvider>(context, listen: false);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                partner,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                         if(parcel!= null)     Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "${parcel.trim().replaceAll(', ', '\n')}",
                                  style: TextStyle(fontSize: 16, height: 1.2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Verisure Premium ${veriSure? '✔' : '✖️'}️',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {


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



                              },
                              child: ImageIcon(
                                AssetImage(
                                    'assets/images/${status == "INTRANSIT" ? 'transit' : 'completed'}.png'),
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${Jiffy(dateTime).format("MMMM d, hh:mm a")}",
                                style: TextStyle(fontSize: 16),
                              ),
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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              orderProvider.bookingSummary(context, bookingId).then((summary) {
                if(summary!=null) {
                  pushPage(context, OrderSummaryScreen(
                    carrier: summary.carrier,
                    stringedParcel: summary.parcel,
                    dropoffAddress: summary.dropoffAddress,
                    pickupAddress: summary.pickupAddress,
                    dropoffName: summary.dropoffName,
                    pickupName: summary.pickupName,
                    dropoffNumber: summary.dropoffNumber,
                    pickupNumber: summary.pickupNumber,
                    pickupTime: summary.pickupTime,
                    parcelDescription: summary.description,
                    provider: summary.provider,
                    providerNumber: summary.providerPhoneNumber,

                  ));
                }
              });
            },
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
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              topRight: Radius.circular(18)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                'N$amount',
                                style: Theme.of(context).textTheme.button,
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
                          Flexible(
                            child: Text(
                              "Reference-$reference",
                              style: Theme.of(context).textTheme.button.copyWith(
                                  color: Color(0xff414141),
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(width: 50),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}
