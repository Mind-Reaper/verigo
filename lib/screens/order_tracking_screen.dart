import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/google_map_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import 'dart:ui' as ui;

import '../constants.dart';

enum StatusProgress { pending, progress, done }

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController mapController;

  void onMapCreated(
    GoogleMapController controller,
  ) {
    var map = Provider.of<GoogleMapProvider>(context, listen: false);
    // controller.setMapStyle(Utils.mapStyles);
    mapController = controller;
    map.setMapPins(mapController, 0.0);

  }

  StatusProgress orderPlacedStatus = StatusProgress.done;
  StatusProgress pendingStatus = StatusProgress.done;
  StatusProgress enrouteStatus = StatusProgress.done;
  StatusProgress deliveredStatus = StatusProgress.done;




  getInitialLocation() async {

    var map = Provider.of<GoogleMapProvider>(context, listen: false);
    LocationData mylocation =  await Location().getLocation();

    LatLng location = LatLng(mylocation.latitude, mylocation.longitude);
 await    map.setSourceLocation(location);
 map.setMapPins(mapController, mylocation.heading);
 print(mylocation.heading);
   await  map.setPolylines();
    setState(() {
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: location,
                  bearing: 30,
                  tilt: 0,
                  zoom: 16))).then((value)  {
                    showRiderButton = false;
      });

    });

  }

  Stream locationStream;
  Location location ;


  @override
  void initState() {
    super.initState();
    var map = Provider.of<GoogleMapProvider>(context, listen: false);

location = Location();

      location.onLocationChanged.listen((event) async {
        await   map.setSourceLocation(LatLng(event.latitude, event.longitude));
        map.setMapPins( mapController, event.heading);
        if(mounted) {
          if (followRider) {
            setState(() {
              mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(event.latitude, event.longitude),
                          bearing: 30,

                          tilt: 0,
                          zoom: 16)));
            });
          }
        }
      });


    getInitialLocation();
    map.setSourceAndDestinationIcons(mapController);







  }

  // Future<ui.Image> loadImage(List<int> img) async {
  //   final Completer<ui.Image> completer = new Completer();
  //   ui.decodeImageFromList(img, (ui.Image img) {
  //     setState(() {
  //       isImageloaded = true;
  //     });
  //     return completer.complete(img);
  //   });
  //   return completer.future;
  // }
  //
  // bool isImageloaded;

  bool showRiderButton = true;
  bool followRider = true;

  @override
  Widget build(BuildContext context) {
    var map = Provider.of<GoogleMapProvider>(context);

    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          title: 'Tracking ID-58398595',
          centerTitle: false,
          blackTitle: true),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingContainer(
                padding: false,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Listener(
                        onPointerMove: (event) {
                          setState(() {
                            followRider = false;
                            showRiderButton = true;
                          });
                },
                        child: GoogleMap(
                          onMapCreated: onMapCreated,
                          mapType: MapType.normal,
                          initialCameraPosition: map.initialLocation != null
                              ? map.initialLocation
                              : CameraPosition(
                                  target: LatLng(42.7477863, -71.1699932),
                                  bearing: 30,
                                  tilt: 0,
                                  zoom: 13),
                          myLocationButtonEnabled: false,

                          // myLocationEnabled: true,
                          onCameraMove: (cameraPosition) async {


                            // setState(() {
                            //
                            //   if (cameraPosition.target.latitude.toStringAsFixed(6) == map.sourceLocation.latitude.toStringAsFixed(6) && cameraPosition.target.longitude.toStringAsFixed(3) == map.sourceLocation.longitude.toStringAsFixed(3)) {
                            //     showRiderButton = false;
                            //
                            //   } else {
                            //     showRiderButton = true;
                            //
                            //   }
                            // });
                          },
                          compassEnabled: true,
                          tiltGesturesEnabled: false,
                          markers: map.markers,
                          polylines: map.polylines,
                        ),
                      ),
                      if (showRiderButton)
                        AnimatedAlign(
                          duration: Duration(milliseconds: 500),
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textColor: Colors.white,
                                  child: FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Rider')
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      followRider = true;
                                      showRiderButton= false;
                                      map.changeCameraPosition(  CameraPosition(
                                          target: LatLng(
                                              42.7477863, -71.1699932),
                                          bearing: 30,
                                          tilt: 0,
                                          zoom: 13));
                                      mapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: map.sourceLocation,

                                                  bearing: 30,
                                                  tilt: 10,
                                                  zoom: 16)));
                                    });

                                  }),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                width: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  OrderStatus(
                    title: 'Order Placed',
                    statusProgress: orderPlacedStatus,
                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Pending Confirmation',
                    statusProgress: pendingStatus,
                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Shipment Enroute',
                    statusProgress: enrouteStatus,
                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Parcel Delivered',
                    statusProgress: deliveredStatus,
                    date: 'Wednesday 13-01',
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: RoundedButton(
              active: true,
              title: 'Rate Your Experience',
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String title;
  final bool showDivider;

  final StatusProgress statusProgress;
  final String date;

  const OrderStatus(
      {Key key,
      this.title,
      this.showDivider: true,
      this.statusProgress,
      this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              statusProgress == StatusProgress.done
                  ? Icons.check_circle_rounded
                  : statusProgress == StatusProgress.pending
                      ? Icons.swap_horizontal_circle
                      : Icons.swap_horizontal_circle,
              color: statusProgress == StatusProgress.done
                  ? showDivider
                      ? primaryColor
                      : Colors.green
                  : statusProgress == StatusProgress.pending
                      ? Colors.grey
                      : primaryColor,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  title: title,
                  color: statusProgress == StatusProgress.done
                      ? showDivider
                          ? primaryColor
                          : Colors.green
                      : statusProgress == StatusProgress.pending
                          ? Colors.grey
                          : primaryColor,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(date)
              ],
            ),
          ],
        ),
        if (showDivider)
          SpaceDivider(
            color: statusProgress == StatusProgress.done
                ? showDivider
                    ? primaryColor
                    : Colors.green
                : statusProgress == StatusProgress.pending
                    ? Colors.grey
                    : primaryColor,
          )
      ],
    );
  }
}

class SpaceDivider extends StatelessWidget {
  final Color color;

  const SpaceDivider({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 6.5,
          ),
          SizedBox(
            height: 40,
            child: VerticalDivider(
              thickness: 2.5,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final Color color;

  const CustomContainer({Key key, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
