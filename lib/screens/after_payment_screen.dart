import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/screens/home_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

class AfterPaymentScreen extends StatelessWidget {
  final bool paymentComplete;
  final String trackingId;

  const AfterPaymentScreen({Key key, this.paymentComplete, this.trackingId}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
      title: paymentComplete? 'Payment Complete' : 'Request Submitted',
        blackTitle: true,
        showbackArrow: false,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light
      ),
      body: Column(
        children: [
          Expanded(child: ListView(
            children: [
              SizedBox(height: 40,),
              Image(
                image: AssetImage(paymentComplete ? 'assets/images/complete.png': 'assets/images/submitted.png'),
                height: 120,
              ),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  'Successful!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),


                ),

              ),
              SizedBox(height: 20,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
               paymentComplete ?     'You will hear from our customer service or service provider concerning your delivery request shortly.'
                    :  "Your order has been submitted and you will get a notification as soon as your payment has been verified.\nPayment verification is usually done within 1-3hours.",
                    style: TextStyle(
                      color: Color(0xff414141),
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: Text('Order Tracking ID',
                style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 23, fontWeight: FontWeight.w500)
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: DottedBorder(
                      dashPattern: [3, 5],
                      borderType: BorderType.RRect,
                      color: Theme.of(context).primaryColor,
                      radius: const Radius.circular(15),
                      child: Container(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.copy, color: Theme.of(context).primaryColor,),
                            SizedBox(width: 10,),
                            Text(trackingId,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: RoundedButton(
              title: 'Done',
              active: true,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
              },
            ),
          ),

        ],
      ),
    );
  }
}
