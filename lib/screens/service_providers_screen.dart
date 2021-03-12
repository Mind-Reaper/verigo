import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/screens/order_summary_screen.dart';
import 'package:verigo/screens/payment_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/logistics_widget.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';

class ServiceProvidersScreen extends StatefulWidget {



  @override
  _ServiceProvidersScreenState createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  bool insuranceEnabled = false;
  double verisure = 00.00;
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();


  calculateVerisure(String input) {
    double amount = double.parse(input,

    ) / 10;


    setState(() {
     if(amount >= 1000) {
       verisure = amount;
       
     } else {
       verisure = 500.00;
     }
    });

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Focus.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                pushPage(context, OrderSummaryScreen());
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
                        color: insuranceEnabled ? Color(0xff414141) : Colors.grey),
                  ),
                ),
              ],
            ),


          ),
          SizedBox(height: 10,),
        if(insuranceEnabled)  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            inputFormatters: [
              MoneyInputFormatter()
            ],
              keyboardType: TextInputType.number,
              decoration: fieldDecoration.copyWith(
                fillColor: Colors.white,
                hintText: 'Enter the total monetary value of your packages'
              ),
            onSubmitted: (input) {
              String finalInput = input.replaceAll('.00', '').replaceAll(',', '');

                calculateVerisure(finalInput);
            },


            ),
        ),
          SizedBox(height: 10),
      if(insuranceEnabled)    Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('+ N${verisure.toStringAsFixed(2)}',

            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,

            ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text('Logistics Providers'),
          ),
          LogisticWidget(
            logName: 'Happi Logistics',
            price: '1500',
            rating: 4,
            totalDeliveries: 1204,
            distance: '13 km',
          ),
          LogisticWidget(
            logName: 'Smallworld Logistics',
            price: '1200',
            rating: 2,
            totalDeliveries: 1384,
            distance: '16 km',
          ),
          LogisticWidget(
            logName: 'Mary Joe Parcel',
            price: '2000',
            rating: 5,
            totalDeliveries: 4523,
            distance: '12 km',
          ),
          LogisticWidget(
            logName: 'Freewolf Unlimited',
            price: '1400',
            rating: 3,
            totalDeliveries: 844,
            distance: '20 km',
          ),
          SizedBox(height: 10,),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                child: Stack(
                  children: [
                    TextField(
                      decoration: fieldDecoration.copyWith(
                        fillColor: Colors.white,
                        hintText: 'Enter Voucher Code',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 44,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
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
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Text('Applies only to logistics fee.'),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RoundedButton(
              title: 'Continue',
              active: true,
              onPressed: () {
                pushPage(context, PaymentScreen());
              },
            ),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
}
