import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/user_provider.dart';

import 'authentication_provider.dart';

class GoogleMapProvider with ChangeNotifier {
  String apiKey = "AIzaSyCxT_RfK3d3T0T2Qu7uUrQ9AbyR1dXjE3Q";

  final LatLng _center = const LatLng(20.5937, 78.9629);

  Future<Uint8List> getBytesFromCanvas(int width, int height, String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void setMapPins(GoogleMapController controller, double direction) {
    print(direction);
    markers.clear();
    // source pin
    markers.add(Marker(
        rotation: direction,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('sourcePin'),
        position: sourceLocation,
        onTap: () {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: sourceLocation, zoom: 20, bearing: 30, tilt: 0)));
          notifyListeners();
        },
        icon: sourceIcon));
    notifyListeners();
    // destination pin
    markers.add(Marker(
        onTap: () {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: destLocation, zoom: 20, bearing: 30, tilt: 0)));
          notifyListeners();
        },
        markerId: MarkerId('destPin'),
        position: destLocation,
        icon: destinationIcon));
    notifyListeners();
  }

  setPolylines() async {
    polylines = {};
    polylineCoordinates.clear();
    notifyListeners();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destLocation.latitude, destLocation.longitude));

    notifyListeners();
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // create a Polyline instance
    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
        width: 5,
        polylineId: PolylineId("poly"),
        color: Color(0xff7A4B9D),
        points: polylineCoordinates);

    // add the constructed polyline as a set of points
    // to the polyline set, which will eventually
    // end up showing up on the map
    polylines.add(polyline);
    notifyListeners();
  }

  CameraPosition initialLocation =
      CameraPosition(target: LatLng(42.7477863, -71.1699932), bearing: 30, tilt: 0, zoom: 13);

  changeCameraPosition(CameraPosition position) {
    initialLocation = position;
    notifyListeners();
  }

  static const double CAMERA_ZOOM = 13;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
  LatLng sourceLocation = LatLng(42.7477863, -71.1699932);
  LatLng destLocation = LatLng(6.447400, 3.390300);
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyCxT_RfK3d3T0T2Qu7uUrQ9AbyR1dXjE3Q";
  void setSourceAndDestinationIcons(GoogleMapController controller) async {
    final Uint8List bikeIcon = await getBytesFromCanvas(40, 50, 'assets/images/minivan.png');
    final Uint8List markerIcon = await getBytesFromCanvas(70, 50, 'assets/images/location.png');

    sourceIcon = BitmapDescriptor.fromBytes(bikeIcon);

    destinationIcon = BitmapDescriptor.fromBytes(markerIcon);
    notifyListeners();

    setMapPins(controller, 0.0);
    notifyListeners();
  }

  setSourceLocation(location) {
    sourceLocation = location;
    notifyListeners();
  }

  Future<TrackedOrder> trackBooking(context, String trackingId) async {
    EasyLoading.show(status: 'Tracking Order');
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);
    print(trackingId);

    try {
      Response response = await dio.get('/api/services/app/Booking/GetBookingUpdate',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: {
            'trackingNo': trackingId,
          }).timeout(Duration(seconds: 30));
      print(response.data);
      EasyLoading.dismiss();
      TrackedOrder order = TrackedOrder.fromDocument(response.data['result']['data']);
      return order;
    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return null;
    } catch (e) {
      print(e);
      EasyLoading.showError('Failed to track order,\nMake sure Order has been picked up!');
      return null;
    }
  }

//   getMyLocation(GoogleMapController controller) async {
// Position mylocation =  await Geolocator.getCurrentPosition();
// LatLng location = LatLng(mylocation.latitude, mylocation.longitude);
//
// sourceLocation = location;
// setMapPins(controller);
//
// notifyListeners();
//
//   }

}

class TrackedOrder {
  final String orderPlacedDate;
  final String orderPlacedStage;
  final String orderPlacedNotes;
  final String dispatchDate;
  final String dispatchStage;
  final String dispatchNotes;
  final int length;
  final String enrouteStage;
  final String enrouteNotes;
  final String enrouteDate;
  final String deliveredStage;
  final String deliveredNotes;
  final String deliveredDate;

  TrackedOrder(
      {this.orderPlacedDate,
        this.length,
      this.orderPlacedStage,
      this.orderPlacedNotes,
      this.dispatchDate,
      this.dispatchStage,
      this.dispatchNotes,
        this.enrouteStage,
        this.enrouteNotes,
        this.enrouteDate,
        this.deliveredDate,
        this.deliveredNotes,
        this.deliveredStage
      });

  factory TrackedOrder.fromDocument(doc) {
    return TrackedOrder(
      orderPlacedDate: doc[0]['date'],
      orderPlacedStage: doc[0]['stage'],
      orderPlacedNotes: doc[0]['notes'],
      dispatchDate: doc[1]['date'],
      dispatchNotes: doc[1]['notes'],
      dispatchStage: doc[1]['stage'],
      length: doc.length,
      enrouteDate: doc[2]['date'],
      enrouteNotes: doc[2]['notes'],
      enrouteStage: doc[2]['stage'],
      deliveredDate: doc[3]['date'],
      deliveredNotes: doc[3]['notes'],
      deliveredStage: doc[3]['stage'],
    );
  }
}
