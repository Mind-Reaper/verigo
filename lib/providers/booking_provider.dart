import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/get_estimate_screen.dart';

import 'authentication_provider.dart';

class BookingProvider with ChangeNotifier {
  UserProvider user = UserProvider();

  bool estimated = false;
  int minimumEstimation;
  int maximumEstimation;
  String distance;
  double vat;
  double serviceFee;

  int total;
  double pickupLatitude;
  double pickupLongitude;
  String pickupAddress;
  double dropoffLatitude;
  double dropoffLongitude;
  String dropoffAddress;
  Map carrier = {
    'icon': FontAwesomeIcons.bicycle,
    'name': 'Bicycle',
    'index': 1
  };
  String parcels;
  String parcelDescription;
  double parcelWorth;
  double veriSure;
  String pickupTime;
  String pickupName;
  String pickupNumber;
  String dropoffName;
  String dropoffNumber;
  String couponId;
  double couponValue;
  bool isPercent = false;
  ServiceProvider serviceProvider;
  List<ServiceProvider> serviceProviders;
  String bookingId;
  String paymentId;
  String bookingReference;
  int customerId;
  int paymentMethod;
  int paymentStatus;

  changeCarrier(carrier) {
    this.carrier = carrier;
    print(carrier['index']);
    notifyListeners();
  }

  changeEstimated(bool value) {
    estimated = value;
    notifyListeners();
  }

  changeOrderInfo({
    double parcelWorth,
    String couponId,
    double couponValue,
    bool isPercent: false,
  }) {
    this.parcelWorth = parcelWorth;
    this.couponId = couponId;
    this.couponValue = couponValue;
    this.isPercent = isPercent;
    notifyListeners();
  }

  selectServiceProvider(int index) {
    serviceProvider = serviceProviders[index];
    notifyListeners();
  }

  changeDetails(
      {String senderName,
      String pickupTime,
      String senderNumber,
      String receiverName,
      String receiverNumber,
      String itemDescription}) {
    pickupName = senderName;
    pickupNumber = senderNumber;
    this.pickupTime = pickupTime ?? null;
    dropoffName = receiverName;
    dropoffNumber = receiverNumber;
    parcelDescription = itemDescription;
    notifyListeners();
  }

  changeBookingLocation(
      {String pickupAddress,
      String dropoffAddress,
      double pickupLatitude,
      double pickupLongitude,
      double dropoffLatitude,
      double dropoffLongitude}) {
    this.pickupAddress = pickupAddress ?? this.pickupAddress;
    this.dropoffAddress = dropoffAddress ?? this.dropoffAddress;
    this.pickupLatitude = pickupLatitude ?? this.pickupLatitude;
    this.pickupLongitude = pickupLongitude ?? this.pickupLongitude;
    this.dropoffLatitude = dropoffLatitude ?? this.dropoffLatitude;
    this.dropoffLongitude = dropoffLongitude ?? this.dropoffLongitude;
    print(this.pickupLatitude);
    print(this.pickupLongitude);
    print(this.dropoffLatitude);
    print(this.dropoffLongitude);

    notifyListeners();
  }

  clearBooking() {
    estimated = false;
    customerId = null;
    bookingReference = null;
    serviceFee = null;
    serviceProviders = null;
    minimumEstimation = null;
    maximumEstimation = null;
    distance = null;
    pickupLatitude = null;
    pickupLongitude = null;
    pickupAddress = null;
    dropoffLatitude = null;
    dropoffLongitude = null;
    dropoffAddress = null;
    carrier = null;
    parcels = null;
    parcelDescription = null;
    parcelWorth = null;
    veriSure = null;
    vat = null;
    total = null;
    pickupTime = null;
    pickupName = null;
    pickupNumber = null;
    dropoffName = null;
    dropoffNumber = null;
    couponId = null;
    couponValue = null;
    isPercent = false;
    serviceProvider = null;
    bookingId = null;
    paymentId = null;
    paymentMethod = null;
    paymentStatus = null;
    notifyListeners();
  }

  getEstimate(context) async {
    print(carrier);

    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    EasyLoading.show(status: 'Estimating...');
    try {
      Response response =
          await dio.post('/api/services/app/Booking/DeliveryEstimate',
              options: Options(
                headers: {'Authorization': 'Bearer $accessToken'},
              ),
              data: {
            "pickup": {
              "address": pickupAddress,
              "latitude": pickupLatitude,
              "longitude": pickupLongitude
            },
            "dropOff": {
              "address": dropoffAddress,
              "latitude": dropoffLatitude,
              "longitude": dropoffLongitude
            },
            "carrier": carrier['index'],
            "parcels": packages,
          }).timeout(Duration(seconds: 30));
      print(response.data);
      estimated = true;
      EasyLoading.dismiss();

      minimumEstimation = response.data['result']['data']['minimum'];
      maximumEstimation = response.data['result']['data']['maximum'];
      distance = response.data['result']['data']['distance'];
      notifyListeners();
    } on TimeoutException {
      EasyLoading.showError('Timeout');
    } catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
    }
    notifyListeners();
  }

  Future<bool> getServiceProviders(context, {bool bg: false}) async {
    serviceProviders = null;

    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    if (!bg) EasyLoading.show();
    try {
      Response response =
          await dio.post('/api/services/app/Booking/ServiceProviders',
              options: Options(
                headers: {'Authorization': 'Bearer $accessToken'},
              ),
              data: {
            "pickup": {
              "address": pickupAddress,
              "latitude": pickupLatitude,
              "longitude": pickupLongitude
            },
            "dropOff": {
              "address": dropoffAddress,
              "latitude": dropoffLatitude,
              "longitude": dropoffLongitude
            },
            "carrier": carrier['index'],
            "parcels": packages,
          }).timeout(Duration(seconds: 30));
      print(response.data);
      List providers = response.data['result']['data'];
      serviceProviders = providers.map((doc) {
        return ServiceProvider.fromDocument(doc);
      }).toList();
      EasyLoading.dismiss();

      print(serviceProviders[0].name);

      notifyListeners();
      return true;
    } on TimeoutException {
      if (!bg) EasyLoading.showError('Timeout');
      return false;
    } catch (e) {
      print(e);
      if (!bg) EasyLoading.showError('Something went wrong');
      notifyListeners();
      return false;
    }
  }

  Future<bool> createNewOrder(BuildContext context) async {
    EasyLoading.show();
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    try {
      Response response = await dio.post('/api/services/app/Booking/CreateNew',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "deliveryRequest": {
              "carrier": carrier['index'],
              "parcels": packages,
              "parcelDescription": parcelDescription,
              "parcelWorth": parcelWorth,
            },
            "pickupDetails": {
              "pickupTime": pickupTime,
              "address": pickupAddress,
              "name": pickupName,
              "phoneNumber": pickupNumber
            },
            "deliveryDetails": {
              "address": dropoffAddress,
              "name": dropoffName,
              "phoneNumber": dropoffNumber
            },
            "serviceProvider": {
              "partnerId": serviceProvider.partnerId,
              "name": serviceProvider.name,
              "phoneNumber": serviceProvider.phoneNumber,
              "dispatchDistance": serviceProvider.dispatchDistance,
              "partnerFee": serviceProvider.partnerFee,
            },
            "discount": {
              "couponId": couponId ?? "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              "value": couponValue ?? 0,
              "isPercent": isPercent
            }
          }).timeout(Duration(seconds: 30));
      print(response.data);
      Map result = response.data['result']['data'];
      bookingId = result['bookingId'];
      bookingReference = result['bookingReference'];
      customerId = result['customerId'];
      serviceFee = result['serviceFee'];
      vat = result['vat'];
      veriSure = result['veriSure'];
      total = result['total'];
      notifyListeners();
      EasyLoading.dismiss();
      return true;
    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    } catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return false;
    }
  }
}

class ServiceProvider {
  final String partnerId;
  final int agentId;
  final int partnerFee;
  final int serviceFee;
  final int vat;
  final int total;
  final String name;
  final int distanceCovered;
  final int deliveries;
  final int rating;
  final String logo;
  final String distanceText;
  final int distance;
  final String phoneNumber;
  final int dispatchDistance;

  ServiceProvider(
      {this.partnerId,
      this.deliveries,
      this.distanceCovered,
      this.logo,
      this.name,
      this.agentId,
      this.partnerFee,
      this.serviceFee,
      this.vat,
      this.total,
      this.rating,
      this.distanceText,
      this.distance,
      this.phoneNumber,
      this.dispatchDistance});

  factory ServiceProvider.fromDocument(Map doc) {
    return ServiceProvider(
        partnerId: doc['partnerId'],
        name: doc['name'],
        rating: doc['rating'],
        distanceCovered: doc['distanceCovered'],
        deliveries: doc['deliveries'],
        logo: doc['logo'],
        distanceText: doc['distanceText'],
        phoneNumber: doc['phoneNumber'],
        distance: doc['distance'],
        partnerFee: doc['fee'],
        dispatchDistance: doc['dispatchDistance']);
  }
}
