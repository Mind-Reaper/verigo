import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:location/location.dart';

class GoogleMapProvider with ChangeNotifier{

  String apiKey = "AIzaSyCxT_RfK3d3T0T2Qu7uUrQ9AbyR1dXjE3Q";



  final LatLng _center = const LatLng(20.5937, 78.9629);

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();

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
controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLocation, zoom: 20, bearing: 30, tilt: 0)));
notifyListeners();

          },
          icon: sourceIcon));
    notifyListeners();
      // destination pin
      markers.add(Marker(
          onTap: () {
            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destLocation, zoom: 20, bearing: 30, tilt: 0)));
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
          patterns: [
            PatternItem.dash(10), PatternItem.gap(10)
          ],
          color: Color(0xff7A4B9D),

          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      polylines.add(polyline);
      notifyListeners();

  }

  CameraPosition initialLocation = CameraPosition(target: LatLng(42.7477863, -71.1699932), bearing: 30, tilt: 0, zoom: 13);

  changeCameraPosition(CameraPosition position) {
    initialLocation = position;
notifyListeners();
  }


  static const double CAMERA_ZOOM = 13;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
 LatLng sourceLocation  = LatLng(42.7477863, -71.1699932);
 LatLng destLocation = LatLng(6.447400, 3.390300);
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyCxT_RfK3d3T0T2Qu7uUrQ9AbyR1dXjE3Q";
  void setSourceAndDestinationIcons(GoogleMapController controller) async {
    final Uint8List bikeIcon =
    await getBytesFromCanvas(40, 50, 'assets/images/minivan.png');
    final Uint8List markerIcon =
    await getBytesFromCanvas(70, 50, 'assets/images/location.png');

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

