import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/pages/order_page.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:verigo/widgets/stacked_display.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
      brightness: Brightness.light,
        title: 'Order Summary',
        blackTitle: true,
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          StackedDisplay(
            title: 'Package Description',
            icon: ImageIcon(
              AssetImage('assets/images/request.png')
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Carrier: Van',
                  style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Small Boxes: 2',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Medium Boxes: 1',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Large Boxes: 4',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

              ],
            )
          ),
          SizedBox(height: 20,),
          StackedDisplay(
              title: 'Pickup Details',
              icon: Icon(FontAwesomeIcons.truckLoading),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("Name: Moyin Samson",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Mobile Number: +2348145372954',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Address: 9092, parlay street, Lagos State.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Date: January 12 2021',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Time: 02:21 pm',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              )
          ),
          SizedBox(height: 20,),
          StackedDisplay(
              title: 'Delivery Details',
              icon: Icon(FontAwesomeIcons.truckPickup),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Name: Oyin Dorcas',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Mobile Number: +23453952305',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Address: 12, Dolphin estate, Lagos State.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Item Description: This is a sample item to be delivered as the mentioned address above. ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              )
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RoundedButton(
              title: 'Confirm',
              active: true,
              onPressed: () {
Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

