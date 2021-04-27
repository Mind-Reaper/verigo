import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:google_maps_webservice/src/core.dart';

import '../constants.dart';
import 'delivery_request_screen.dart';

// Map<int, List<Map<String, int>>> packages = {
//
//
// };
List packages = [];


class GetEstimateScreen extends StatefulWidget {
  @override
  _GetEstimateScreenState createState() => _GetEstimateScreenState();
}

class _GetEstimateScreenState extends State<GetEstimateScreen> {
  bool intra = false;
  String selectedState = 'Select Delivery State';
  IconData carrierIcon = FontAwesomeIcons.motorcycle;
  Map selectedCarrier;
  List selectedPackageList = bicyclePackages;
  List packageWidgets = [];

  TextEditingController pickupController = TextEditingController();

  TextEditingController dropoffController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var booking = Provider.of<BookingProvider>(context, listen: false);
    selectedCarrier = carrier[0];
    Future.microtask(() =>
    booking.clearBooking());
    packages = [];
    setState(() {
      packageWidgets.add('packages');
    });
    Future.microtask(() =>
    booking.changeEstimated(false));
  }

  @override
  Widget build(BuildContext context) {
    var booking = Provider.of<BookingProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(
          context,
          title: 'Get Estimate',
          blackTitle: true,
          centerTitle: false,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    intra ? 'Intra-city' : 'Inter-city',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          fontSize: 20,
                          color: intra
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                  ),
                  SizedBox(width: 5),
                  CupertinoSwitch(
                    value: false,
                    onChanged: (value) {
                      showOkAlertDialog(context: context,
                        title: 'Coming Soon.',
                        message: 'This service is not currently available.'

                      );
                      // setState(() {
                      //   intra = value;
                      // });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (intra)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text('Select drop-off state'),
              ),
            if (intra)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: FloatingContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedState,
                        style: TextStyle(
                            fontSize: 20,
                            color: selectedState == 'Select Delivery State'
                                ? Colors.grey
                                : Color(0xff414141)),
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
                                  child: CupertinoPicker.builder(
                                      itemExtent: 25,
                                      childCount: states.length,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedState = states[index];
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Text(states[index]);
                                      }),
                                );
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: apiKey,
                        region: 'ng',
                        hidePlaceDetailsWhenDraggingPin: false,
                        searchForInitialValue: true,
                        selectInitialPosition: false,
                        initialSearchString: pickupController.text,
                        autocompleteComponents: [
                          Component(Component.country, "ng"),
                        ],

                        // Put YOUR OWN KEY here.
                        onPlacePicked: (result) {

                          setState(() {

                            pickupController.text = result.formattedAddress;
                          });
                          booking.changeBookingLocation(
pickupAddress: result.formattedAddress,
                            pickupLatitude: result.geometry.location.lat,
                            pickupLongitude: result.geometry.location.lng,
                          );
                          Navigator.of(context).pop();
                        },
                        initialPosition: LatLng(6.7477863, 3.1699932),
                        useCurrentLocation: false,
                      ),
                    ),
                  );
                },
                child: TextField(
                  controller: pickupController,
                  enabled: false,
                  decoration: fieldDecoration.copyWith(
                    fillColor: Colors.white,
                    hintText: 'Enter Pickup Location',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: apiKey,
                        initialSearchString: dropoffController.text,
                        autocompleteComponents: [
                          Component(Component.country, "ng"),
                        ],
                        hidePlaceDetailsWhenDraggingPin: false,
                        searchForInitialValue: true, // Put YOUR OWN KEY here.
                        onPlacePicked: (result) {

                          setState(() {
                            dropoffController.text = result.formattedAddress;
                          });
                          booking.changeBookingLocation(
                            dropoffAddress: result.formattedAddress,
                            dropoffLatitude: result.geometry.location.lat,
                            dropoffLongitude: result.geometry.location.lng
                          );
                          Navigator.of(context).pop();
                        },
                        initialPosition: LatLng(6.7477863, 3.1699932),
                        useCurrentLocation: false,
                      ),
                    ),
                  );
                },
                child: TextField(
                  controller: dropoffController,
                  enabled: false,
                  decoration: fieldDecoration.copyWith(
                    fillColor: Colors.white,
                    hintText: 'Enter Delivery Location',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Text('Carrier'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: FloatingContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          selectedCarrier['icon'],
                        ),
                        SizedBox(width: 20),
                        Text(
                          selectedCarrier['name'],
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff414141)),
                        ),
                      ],
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
                                child: CupertinoPicker.builder(
                                  itemExtent: 25,
                                  childCount: carrier.length,
                                  onSelectedItemChanged: (index) {
                                    setState(() {

                                      selectedCarrier = carrier[index];
                                      booking.changeCarrier(selectedCarrier);
                                   int   carrierIndex = selectedCarrier['index'];


                                      if (carrierIndex == 1) {
                                        selectedPackageList = bicyclePackages;
                                      } else if (carrierIndex ==
                                          2) {
                                        selectedPackageList = bikePackages;
                                      } else if (carrierIndex == 3) {
                                        selectedPackageList = tricyclePackages;
                                      } else if (carrierIndex == 4) {
                                        selectedPackageList = busPackages;
                                      } else if (carrierIndex == 5) {
                                        selectedPackageList = truckPackages;
                                      }
                                      packages = [];
                                      packageWidgets = [];

                                      //   packageWidgets.add('packages');
                                      //
                                      // booking.changeEstimated(false);
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          carrier[index]['icon'],
                                          size: 12,
                                        ),
                                        SizedBox(width: 10),
                                        Text(carrier[index]['name']),
                                      ],
                                    );
                                  },
                                ),
                              );
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
            ListView.builder(
                itemCount: packageWidgets.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Package(
                    packageList: selectedPackageList,
                    index: index,
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if(packageWidgets.length != selectedPackageList.length) {
                        setState(() {
                          packageWidgets.add('packages');
                        });
                        booking.changeEstimated(false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        packageWidgets.length > 0
                            ? 'Add Another Package'
                            : 'Add A Package',
                        style: TextStyle(
                            color: packageWidgets.length == selectedPackageList.length? Colors.grey:Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (packageWidgets.length > 0) {
                        print(packageWidgets.length);
                        setState(() {

                          packages.removeAt(packages.length - 1);
                          packageWidgets.removeAt(packageWidgets.length - 1);
                        });
                        booking.changeEstimated(false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'Delete Package',
                        style: TextStyle(
                            color: packageWidgets.length > 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            booking.minimumEstimation != null && booking.maximumEstimation!= null
                ?     Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DottedBorder(
                  dashPattern: [3, 5],
                  borderType: BorderType.RRect,
                  color: Color(0xff414141),
                  radius: const Radius.circular(15),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            booking.minimumEstimation != null && booking.maximumEstimation!= null
                                ? "N${booking.minimumEstimation}.00 - N${booking.maximumEstimation}.00"
                                : "N0.00 - N0.00",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                ),
              ),
            ) : Container(),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: DottedBorder(
            //       padding: EdgeInsets.zero,
            //       color: Theme.of(context).primaryColor,
            //       dashPattern: [2, 6],
            //       child: Container()),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     children: [
            //       Icon(
            //         FontAwesomeIcons.infoCircle,
            //         color: Colors.grey,
            //         size: 30,
            //       ),
            //       SizedBox(width: 5),
            //       Flexible(
            //           child: Text(
            //               "Calculate estimated shipping cost based on order value and total weight of the item."))
            //     ],
            //   ),
            // ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoundedButton(
                title: booking.estimated ? 'Book Now' : 'Get Estimate',
                active: pickupController.text.length > 2 &&
                        dropoffController.text.length > 2  &&
                        packages.length >= 1

                    ? true
                    : false,
                onPressed: !booking.estimated
                    ? ()  {
booking.changeCarrier(selectedCarrier);
booking.getEstimate(context);
                }
                    : () {

                        pushPage(
                            context,
                            DeliveryRequestScreen(
                              pickup: pickupController.text,
                              dropoff: dropoffController.text,
                            ));
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

class Package extends StatefulWidget {
  final List packageList;
  final int index;

  const Package({Key key, this.packageList, this.index}) : super(key: key);

  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  int selectedBoxNumber = 1;
  Map selectedPackage ;

  updatePackages(int index) {
    var booking = Provider.of<BookingProvider>(context, listen: false);
    booking.changeEstimated(false);



    setState(() {
      if (packages.length > index) {

        packages[index] = {'size': selectedPackage['size'], 'quantity': selectedBoxNumber};
      } else {
        packages.add({'size': selectedPackage['size'], 'quantity': selectedBoxNumber});
      }
      // print(selectedPackage);


      print(packages);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedPackage = widget.packageList[0];
      print(selectedPackage);
      print('hey');
    });
    Timer(Duration(milliseconds: 500), () {
      updatePackages(packages.length);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('Size'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: FloatingContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            selectedPackage['name'],
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff414141)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
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
                                    child: CupertinoPicker.builder(
                                      itemExtent: 25,
                                      childCount: widget.packageList.length,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedPackage =
                                              widget.packageList[index];
                                        });
                                        updatePackages(widget.index);
                                      },
                                      itemBuilder: (context, index) {
                                        return Text(widget.packageList[index]['name']);
                                      },
                                    ),
                                  );
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
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('Number'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: FloatingContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedBoxNumber.toString(),
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff414141)),
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
                                    child: CupertinoPicker.builder(
                                      itemExtent: 25,
                                      childCount: boxNumber.length,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedBoxNumber = boxNumber[index];
                                        });
                                        updatePackages(widget.index);
                                      },
                                      itemBuilder: (context, index) {
                                        return Text(
                                            boxNumber[index].toString());
                                      },
                                    ),
                                  );
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
              ],
            ),
          ),
        ]));
  }
}
