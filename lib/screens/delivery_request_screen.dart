

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:verigo/screens/service_providers_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';

class DeliveryRequestScreen extends StatefulWidget {

  final String dropoff;
  final String pickup;

  const DeliveryRequestScreen({Key key, this.dropoff, this.pickup}) : super(key: key);

  @override
  _DeliveryRequestScreenState createState() => _DeliveryRequestScreenState();
}

class _DeliveryRequestScreenState extends State<DeliveryRequestScreen> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();
  DateTime pickupDate;
  TimeOfDay pickupTime;
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pickupController.text = widget.pickup;
      dropoffController.text = widget.dropoff;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(context,
        title: 'Delivery Request',
          brightness: Brightness.light,
          blackTitle: true,
          centerTitle: false,
          backgroundColor: Colors.transparent,
        ),
body: ListView(
  children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Text('Pickup Details'),

      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(
          controller: pickupController,
          decoration: fieldDecoration.copyWith(hintText: 'Pickup Address', fillColor: Colors.white),
          enabled: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(

          decoration: fieldDecoration.copyWith(hintText: "Sender's Full Name", fillColor: Colors.white),

        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(
          inputFormatters: [PhoneInputFormatter()],
          keyboardType: TextInputType.phone,

          decoration: fieldDecoration.copyWith(hintText: "Sender's Mobile Number", fillColor: Colors.white),

        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: FloatingContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pickupDate != null ? Jiffy(pickupDate).format("MMMM d yyy, hh:mm a")  : 'Pickup Date (Optional)',
                style:
                TextStyle(
                    fontSize: 20,

                )
                ,),
              InkWell(
                // splashColor: Theme.of(context).primaryColor,
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: (context) {
                    return Container(
                      color: Colors.white,
                      height: 300,
                      child: CupertinoDatePicker(

                        minimumDate: DateTime.now().add(Duration(hours: 2)),
                        maximumDate: DateTime.now().add(Duration(days: 7)),
                        initialDateTime: DateTime.now().add(Duration(hours: 2)),
                        onDateTimeChanged: (dateTime) {

                          setState(() {
                            pickupDate= dateTime;

                          });
                        },
                      )
                    );
                  }
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 20,),
                ),
              )
            ],
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 16),
        child: DottedBorder(
            padding: EdgeInsets.zero,
            dashPattern: [2, 6],
            color: Colors.grey,
            child: Container()),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Text('Delivery Details'),

      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(
          controller: dropoffController,
          decoration: fieldDecoration.copyWith(hintText: 'Delivery Address', fillColor: Colors.white),
          enabled: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(

          decoration: fieldDecoration.copyWith(hintText: "Receiver's Full Name", fillColor: Colors.white),

        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(
          inputFormatters: [PhoneInputFormatter()],
          keyboardType: TextInputType.phone,

          decoration: fieldDecoration.copyWith(hintText: "Receiver's Mobile Number", fillColor: Colors.white),

        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextField(
minLines: 4,
          maxLines: 5,
          decoration: fieldDecoration.copyWith(hintText: "Item Description", fillColor: Colors.white),

        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 16),
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
            Icon(FontAwesomeIcons.infoCircle, color: Colors.grey, size: 30,),
            SizedBox(width: 5),
            Flexible(child: Text("Any vital information that the user should know, goes here."))
          ],
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RoundedButton(
          title: 'Proceed',
          active: true,
          onPressed: () {
pushPage(context, ServiceProvidersScreen());
          },
        ),
      ),
      SizedBox(height: 30),
  ],
),
      ),
    );
  }
}

