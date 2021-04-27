import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/service_providers_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';

class DeliveryRequestScreen extends StatefulWidget {
  final String dropoff;
  final String pickup;

  const DeliveryRequestScreen({Key key, this.dropoff, this.pickup})
      : super(key: key);

  @override
  _DeliveryRequestScreenState createState() => _DeliveryRequestScreenState();
}

class _DeliveryRequestScreenState extends State<DeliveryRequestScreen> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();
  TextEditingController senderNameController = TextEditingController();
  TextEditingController senderNumberController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String senderNameError = '';
  String senderNumberError = '';
  String receiverNumberError = '';
  String receiverNameError = '';
  String descriptionError = '';
  String pickupTime;
  bool buttonActive = false;

  DateTime pickupDate;
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var booking = Provider.of<BookingProvider>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;

    senderNameController.addListener(() {
      setState(() {
        if (senderNameController.text.trim().split(' ').length < 2 ||
            senderNameController.text.trim().split(' ').length > 3) {
          senderNameError = 'Please input full name only';
        } else {
          senderNameError = null;
        }
      });
      activateButton();
    });
    receiverNameController.addListener(() {
      setState(() {
        if (receiverNameController.text.trim().split(' ').length < 2 ||
            receiverNameController.text.trim().split(' ').length > 3) {
          receiverNameError = 'Please input full name only';
        } else {
          receiverNameError = null;
        }
      });
      activateButton();
    });
    senderNumberController.addListener(() {
      setState(() {
        if (senderNumberController.text
            .trim()
            .length < 11 || senderNumberController.text
            .trim()
            .length > 11) {
          senderNumberError = 'Mobile number is too short or too long';
        } else if (!senderNumberController.text.trim().startsWith('0')) {
          senderNumberError = 'Begin number with 0';
        } else {
          senderNumberError = null;
        }
      });
      activateButton();
    });
    receiverNumberController.addListener(() {
      setState(() {
        if (receiverNumberController.text
            .trim()
            .length < 11 || receiverNumberController.text
            .trim()
            .length > 11) {
          receiverNumberError = 'Mobile number is too short or too long';
        } else if (!receiverNumberController.text.trim().startsWith('0')) {
          receiverNumberError = 'Begin number with 0';
        } else {
          receiverNumberError = null;
        }
      });
      activateButton();
    });

    descriptionController.addListener(() {
      setState(() {
        if (descriptionController.text.trim().replaceAll(" ", '').length < 10 ||
            descriptionController.text.trim().replaceAll(" ", '').length >
                60) {
          descriptionError = 'Description should be between 10-60 characters';
        } else {
          descriptionError = null;
        }
      });
      activateButton();
    });
    setState(() {
      booking.getServiceProviders(context, bg: true);
      pickupController.text = booking.pickupAddress;
      dropoffController.text = booking.dropoffAddress;
      senderNameController.text = "${user.name} ${user.surname}";
      senderNumberController.text = user.phoneNumber.replaceFirst('+234', '0');
    });
  }

  activateButton() {
    if (senderNameError == null &&
        receiverNameError == null &&
        receiverNumberError == null &&
        senderNumberError == null &&
        descriptionError == null) {
      setState(() {
        buttonActive = true;
      });
    } else {
      setState(() {
        buttonActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var booking = Provider.of<BookingProvider>(context);
    var stateProvider = Provider.of<StateProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      onVerticalDragDown: (details) =>
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(
          context,
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
                style: TextStyle(color: Colors.grey),
                decoration: fieldDecoration.copyWith(
                    hintText: 'Pickup Address', fillColor: Colors.white),
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: senderNameController,
                decoration: fieldDecoration.copyWith(
                    hintText: "Sender's Full Name",
                    fillColor: Colors.white,
                    errorText: senderNameError),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: senderNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: fieldDecoration.copyWith(
                    hintText: "Sender's Number e.g 08145963953",
                    fillColor: Colors.white,
                    errorText: senderNumberError),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: FloatingContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pickupDate != null
                          ? Jiffy(pickupDate).format("MMMM d yyy, hh:mm a")
                          : 'Pickup Date (Optional)',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      // splashColor: Theme.of(context).primaryColor,
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return Container(
                                  color: Colors.white,
                                  height: 300,
                                  child: CupertinoDatePicker(
                                    minimumDate:
                                        DateTime.now().add(Duration(hours: 2)),
                                    maximumDate:
                                        DateTime.now().add(Duration(days: 7)),
                                    initialDateTime:
                                        DateTime.now().add(Duration(hours: 2)),
                                    onDateTimeChanged: (dateTime) {
                                      setState(() {
                                        pickupDate = dateTime;
                                        pickupTime = pickupDate.toString();
                                      });
                                    },
                                  ));
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
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
                style: TextStyle(color: Colors.grey),
                controller: dropoffController,
                decoration: fieldDecoration.copyWith(
                    hintText: 'Delivery Address', fillColor: Colors.white),
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: receiverNameController,
                decoration: fieldDecoration.copyWith(
                    hintText: "Receiver's Full Name",
                    fillColor: Colors.white,
                    errorText: receiverNameError),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: receiverNumberController,
maxLength: 11,
                keyboardType: TextInputType.phone,
                decoration: fieldDecoration.copyWith(
                    hintText: "Receiver's Number e.g 08145035832",
                    fillColor: Colors.white,
                    errorText: receiverNumberError),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 5,
                decoration: fieldDecoration.copyWith(
                    hintText: "Item Description",
                    fillColor: Colors.white,
                    errorText: descriptionError),
              ),
            ),
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
                          "Any vital information that the user should know, goes here."))
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoundedButton(
                title: 'Proceed',
                active: buttonActive,
                onPressed: () {
                  booking.changeDetails(
                    senderName: senderNameController.text,
                    receiverName: receiverNameController.text,
                    senderNumber:
                        formatPhoneNumber(senderNumberController.text),

                    receiverNumber:
                    formatPhoneNumber(receiverNumberController.text),
                    itemDescription: descriptionController.text,
                    pickupTime: pickupTime,
                  );
                  booking.nullCoupon();
                  stateProvider.changeSelectedLogistic(null);
                  if (booking.serviceProviders == null) {
                    booking.getServiceProviders(context).then((value) {
                      if (value) pushPage(context, ServiceProvidersScreen());
                    });
                  } else {
                    pushPage(context, ServiceProvidersScreen());
                  }
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
