import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/screens/order_summary_screen.dart';
import 'package:verigo/screens/payment_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/logistics_widget.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';
import 'get_estimate_screen.dart';

class ServiceProvidersScreen extends StatefulWidget {
  @override
  _ServiceProvidersScreenState createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  bool insuranceEnabled = false;

  double parcelWorth = 00.00;
  String couponCode = '';

  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();

  calculateVerisure(String input) {
    setState(() {
      parcelWorth = double.parse(input);
    });

    // double amount = double.parse(input,
    //
    // ) / 10;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var booking = Provider.of<BookingProvider>(context, listen: false);
    Future.microtask(() => booking.nullServiceProvider());
  }

  @override
  Widget build(BuildContext context) {
    var booking = Provider.of<BookingProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(
        context,
        title: 'Service Providers',
        backgroundColor: Colors.transparent,
        blackTitle: true,
        centerTitle: false,
        brightness: Brightness.light,
      ),
      body: ListView(children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: GestureDetector(
            onTap: () {
              pushPage(context, OrderSummaryScreen(
                parcel: packages,
                parcelDescription: booking.parcelDescription,
                pickupTime: booking.pickupTime,
                pickupName: booking.pickupName,
                pickupNumber: booking.pickupNumber,
                pickupAddress: booking.pickupAddress,
                dropoffName: booking.dropoffName,
                  dropoffAddress: booking.dropoffAddress,
                dropoffNumber: booking.dropoffNumber,
                carrier: booking.carrier['name'],
              ));
            },
            child: FloatingContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      if (insuranceEnabled) {
                        insuranceEnabled = false;
                        parcelWorth = 0.00;
                      } else {
                        insuranceEnabled = true;
                      }
                    });
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: Icon(
                    insuranceEnabled
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: Theme.of(context).primaryColor,
                  )),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Buy VeriSure (Premium Protection)',
                  style: TextStyle(
                      color:
                          insuranceEnabled ? Color(0xff414141) : Colors.grey),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        if (insuranceEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              inputFormatters: [MoneyInputFormatter()],
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: fieldDecoration.copyWith(
                  fillColor: Colors.white,
                  hintText: 'Enter the total monetary value of your packages'),
              onChanged: (input) {
                if (input.length > 0) {
                  String finalInput =
                      input.replaceAll('.00', '').replaceAll(',', '');

                  calculateVerisure(finalInput);
                }
              },
            ),
          ),
        SizedBox(height: 10),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text('Logistics Providers'),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: booking.serviceProviders.length,
            itemBuilder: (context, index) {
              ServiceProvider provider = booking.serviceProviders[index];
              return LogisticWidget(
                logName: provider.name,
                index: index,
                price: provider.partnerFee,
                rating: provider.rating,
                totalDeliveries: provider.deliveries,
                distance: provider.distanceText,
                cod: provider.cod,
              );
            }),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              child: booking.couponId == null
                  ? Stack(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              couponCode = value;
                            });
                          },
                          decoration: fieldDecoration.copyWith(
                            fillColor: Colors.white,
                            hintText: 'Enter Voucher Code',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (couponCode.isNotEmpty)
                                booking.validateCoupon(context, couponCode);
                            },
                            child: Container(
                              height: 44,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: couponCode.isNotEmpty
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Apply',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          booking.isPercent
                              ? '-${booking.couponValue}%'
                              : '-N${booking.couponValue}',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                              fontSize: 50),
                        ),
                      ],
                    ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Text('Applies only to logistics fee.'),
        ),
        SizedBox(height: 10,),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: DottedBorder(
              padding: EdgeInsets.zero,
              color: Colors.grey,
              dashPattern: [2, 6],
              child: Container()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.infoCircle,
                color: Colors.grey,
                size: 30,
              ),
              SizedBox(width: 5),
              Flexible(
                  child: Text(
                      "COD stands for 'Cash On Delivery'"))
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RoundedButton(
            title: 'Continue',
            active: insuranceEnabled
                ? parcelWorth >= 1000 && booking.serviceProvider != null
                    ? true
                    : false
                : booking.serviceProvider != null
                    ? true
                    : false,
            // active: booking.serviceProvider != null ? insuranceEnabled
            //     ? parcelWorth >= 1000 ? true
            //     : false : true : false,
            onPressed: () {
              booking.changeOrderInfo(parcelWorth: parcelWorth);
              booking.createNewOrder(context).then((value) {
                if (value) {
                  pushPage(context, PaymentScreen());
                }
              });
            },
          ),
        ),
        SizedBox(height: 30),
      ]),
    );
  }
}
