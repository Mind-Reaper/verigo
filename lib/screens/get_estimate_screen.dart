import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';
import 'delivery_request_screen.dart';

Map<String, int> packages = {};

class GetEstimateScreen extends StatefulWidget {
  @override
  _GetEstimateScreenState createState() => _GetEstimateScreenState();
}

class _GetEstimateScreenState extends State<GetEstimateScreen> {
  bool intra = false;
  String selectedState = 'Select State';
  IconData carrierIcon = FontAwesomeIcons.motorcycle;
  String selectedCarrier = 'Motorcycle';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  intra ? 'Intra' : 'Inter',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: intra
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                ),
                SizedBox(width: 5),
                CupertinoSwitch(
                  value: intra,
                  onChanged: (value) {
                    setState(() {
                      intra = value;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (!intra)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: FloatingContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedState,
                      style: TextStyle(
                          fontSize: 20,
                          color: selectedState == 'Select State'
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
            child: TextField(
              decoration: fieldDecoration.copyWith(
                fillColor: Colors.white,
                hintText: 'Enter Pickup Location',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: fieldDecoration.copyWith(
                fillColor: Colors.white,
                hintText: 'Enter Delivery Location',
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
                        carrierIcon,
                      ),
                      SizedBox(width: 20),
                      Text(
                        selectedCarrier,
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
                                    selectedCarrier = carrier[index]['name'];
                                    carrierIcon = carrier[index]['icon'];
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
          Package(box: 'small_boxes'),
          Package(box: 'medium_boxes'),
          Package(
            box: 'large_boxes',
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DottedBorder(
                dashPattern: [3, 5],
                borderType: BorderType.RRect,
                color: Color(0xff414141),
                radius: const Radius.circular(15),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text("N1500.00 - N2300.00",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                        "Calculate estimated shipping cost based on order value and total weight of the item."))
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RoundedButton(
              title: 'Book Now',
              active: true,
              onPressed: () {
                pushPage(context, DeliveryRequestScreen());
              },
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class Package extends StatefulWidget {
  final String box;

  const Package({Key key, this.box}) : super(key: key);

  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  int selectedBoxNumber = 0;

  updatePackages() {
    packages[widget.box] = selectedBoxNumber;
    print(packages);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Text(
                      widget.box == 'small_boxes'
                          ? 'Small Boxes'
                          : widget.box == 'medium_boxes'
                              ? 'Medium Boxes'
                              : 'Large Boxes',
                      style:
                          TextStyle(fontSize: 20, color: Color(0xff414141)),
                    ),
                  ]))),
          SizedBox(width: 10),
          Expanded(
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
                                          updatePackages();
                                        });
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
