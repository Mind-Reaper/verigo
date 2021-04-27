import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/pages/order_page.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/screens/get_estimate_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:verigo/widgets/stacked_display.dart';

class OrderSummaryScreen extends StatefulWidget {



  final List parcel;
  final String stringedParcel;
  final String pickupTime;
  final String carrier;
  final String pickupName;
  final String pickupNumber;
  final String pickupAddress;
  final String dropoffName;
  final String dropoffNumber;
  final String dropoffAddress;
  final String parcelDescription;
  final String providerNumber;
  final String provider;

  const OrderSummaryScreen({Key key, this.parcel, this.pickupTime, this.carrier, this.pickupName, this.pickupNumber, this.pickupAddress, this.dropoffName, this.dropoffNumber, this.dropoffAddress, this.parcelDescription, this.stringedParcel, this.providerNumber, this.provider}) : super(key: key);


  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  Map parcel;
  DateTime dateTime;
  getParcelName(size) {

      if (size == 1 | 2) {
        parcel = bikePackages.firstWhere((e) => e['size'] == size);
      } else if (size == 1 | 2 | 3) {
        parcel = bikePackages.firstWhere((e) => e['size'] == size);
      } else if (size == 2 | 3 | 4) {
        parcel = bikePackages.firstWhere((e) => e['size'] == size);
      } else if (size == 3 | 4) {
        parcel = bikePackages.firstWhere((e) => e['size'] == size);
      } else if (size >= 5 || size <= 24) {
        parcel = bikePackages.firstWhere((e) => e['size'] == size);
      }

  }

  @override
  Widget build(BuildContext context) {
    var booking = Provider.of<BookingProvider>(context);
  if(widget.pickupTime != null) dateTime = DateTime.parse(widget.pickupTime);
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
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Carrier: ${widget.carrier}',
                  style: TextStyle(fontSize: 18),
                  ),
                ),
              widget.parcel != null  ?ListView.builder(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                    int size = packages[index]['size'];
                   getParcelName(size);

                    int quantity = packages[index]['quantity'];
                      return  Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text('${parcel['name']}: $quantity',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                ):
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('${widget.stringedParcel.replaceAll(', ', '\n')}',
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
                    padding: const EdgeInsets.all(3.0),
                    child: Text("${widget.pickupName}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.pickupNumber}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.pickupAddress}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
           if(widget.pickupTime!= null)       Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${Jiffy(dateTime).format("MMMM d, hh:mm a")}',
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
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.dropoffName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.dropoffNumber}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.dropoffAddress}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              if(widget.parcelDescription!= null)    Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('Description: ${booking.parcelDescription}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              )
          ),
          SizedBox(height: 20),
         if(widget.provider != null) StackedDisplay(
              title: 'Service Provider',
              icon: ImageIcon(
                AssetImage('assets/images/logo.png')
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.provider}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text('${widget.providerNumber}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )
          ),
          if(widget.provider != null)    SizedBox(height: 20),
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

