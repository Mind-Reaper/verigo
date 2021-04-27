import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/payment_provider.dart';
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

  double total;
  double pickupLatitude;
  double pickupLongitude;
  String pickupAddress;
  double dropoffLatitude;
  double dropoffLongitude;
  String dropoffAddress;
  Map carrier = {'icon': FontAwesomeIcons.bicycle, 'name': 'Bicycle', 'index': 1};
  String parcels;
  String parcelDescription;
  double parcelWorth = 0.00;
  double veriSure;
  String pickupTime;
  String pickupName;
  String pickupNumber;
  String dropoffName;
  String dropoffNumber;
  String couponId;
  double discount = 0.00;
  int couponValue;
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
  }) {
    this.parcelWorth = parcelWorth ?? 0.00;

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
    discount = 0.00;
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

  cancelBooking(context, String reason) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);

    try {
      Response response = await dio.post('/api/services/app/Booking/CancelBooking',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {"bookingId": bookingId, "reason": reason});
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

Future<bool> verifyPPC(context, String bookingId, String ppc) async {

    EasyLoading.show(status: 'Verifying');
  String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
  print(accessToken);
  try {
    Response response = await dio.post('/api/services/app/Booking/VerifyPPC',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {"bookingId": bookingId, "code": ppc}).timeout(Duration(seconds: 20));
    print(response.data);
    if(response.data['result']['isSuccess'] == true) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError('Incorrect Verification Code');
      return false;
    }


  } on TimeoutException {
    EasyLoading.showError('Timeout');
    return false;
  }
  catch (e) {
    print(e);
    EasyLoading.showError('Failed');
    return false;
  }

}

  getEstimate(context) async {
    print(carrier['index']);

    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);

    EasyLoading.show(status: 'Estimating...');
    try {
      Response response = await dio.post('/api/services/app/Booking/DeliveryEstimate',
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

    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);

    if (!bg) EasyLoading.show();
    try {
      Response response = await dio.post('/api/services/app/Booking/ServiceProviders',
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
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);
    print(parcelWorth);
    try {
      Response response = await dio.post('/api/services/app/Booking/NewBooking',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "deliveryRequest": {
              "carrier": carrier['index'],
              "parcels": packages,
              "parcelDescription": parcelDescription,
              "parcelWorth": parcelWorth.toInt(),
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
              "couponId": couponId ?? "aee2c9b4-f2ab-4d6b-89b3-08d8ee4b9392",
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
      discount = result['discount'];
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

  nullServiceProvider() {
    serviceProvider = null;
    notifyListeners();
  }

  nullCoupon() {
    couponValue = null;
    couponId = null;
    isPercent = false;
    notifyListeners();
  }

  validateCoupon(context, String code) async {
    EasyLoading.show(status: 'Verifying Coupon');
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);
    try {
      Response response = await dio
          .get(
            '/api/services/app/Promotion/GetValidCoupon',
            queryParameters: {"code": code},
            options: Options(
              headers: {'Authorization': 'Bearer $accessToken'},
            ),
          )
          .timeout(Duration(seconds: 20));
      print(response.data);
      couponId = response.data['result']['data']['couponId'];
      couponValue = response.data['result']['data']['value'];
      isPercent = response.data['result']['data']['isPercent'];
      notifyListeners();
      EasyLoading.dismiss();
    } on TimeoutException {
      EasyLoading.showError('Timeout');
    } catch (e) {
      EasyLoading.showError("Coupon verification failed!");
      print(e);
    }
  }

  Future<bool> updateBooking(context, int paymentMethod ) async {
    EasyLoading.show(status: 'Please wait');
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    var payment = Provider.of<PaymentProvider>(context, listen: false);
    print(accessToken);
    try {
      Response response =
          await dio.put('/api/services/app/Payment/UpdateBooking',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "payMethod": paymentMethod,
            "bookingId": bookingId,
          }
      );

      print(response.data);

      if(response.data['result']['isSuccess'] == true) {
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.showError('Something went wrong');
        return false;
      }

    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    }
    catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return false;
    }
  }

  Future<bool> updatePaymentPaystack(context, {int amount, String email}) async {
    EasyLoading.show(status: 'Please wait');
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    var payment = Provider.of<PaymentProvider>(context, listen: false);

    try {
      EasyLoading.dismiss();
      CheckoutResponse paystackResponse = await payment.payStackPay(context, amount, email);
      bool isSuccess = paystackResponse.status;

      int paymentMethod;

      if (isSuccess == true) {
        EasyLoading.show(status: 'Please Wait...');
        if (paystackResponse.method == CheckoutMethod.card) {
          paymentMethod = 2;
        } else if (paystackResponse.method == CheckoutMethod.bank) {
          paymentMethod = 3;
        }
        try {
          Response response = await dio.post('/api/services/app/Payment/PayWithPayStack',
              options: Options(
                headers: {'Authorization': 'Bearer $accessToken'},
              ),
              data: {
                "type": 1,
                "reference": bookingId,
                "amount": amount,
                "isSuccess": true,
                "gatewayRef": paystackResponse.reference
              }).timeout(Duration(seconds: 20));

          print(response.data);

          EasyLoading.dismiss();
          if (response.data['result']['isSuccess']) {
            String trackingId = response.data['result']['data']['trackingId'];
            String pdc = response.data['result']['data']['pdc'];
            payment.changeTrackingID(trackingId, pdc);
            return true;
          } else {
            return false;
          }
        } on TimeoutException {
          EasyLoading.showError(
            'Something went wrong, if payment has been made, Contact our customer service',
            duration: Duration(seconds: 5),
            dismissOnTap: false,
          );
          return false;
        } catch (e) {
          print(e);
          EasyLoading.showError(
            'Something went wrong, if payment has been made, Contact our customer service',
            duration: Duration(seconds: 5),
            dismissOnTap: false,
          );
          return false;
        }
      } else {
        EasyLoading.showError('Payment Failed');
        return false;
      }
    } catch (e) {
      print(e);
      EasyLoading.showError('Payment failed');
      return false;
    }
  }
}

class ServiceProvider {
  final String partnerId;
  final int agentId;
  final int partnerFee;
  final bool cod;
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
      this.vat,
      this.total,
      this.cod,
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
        cod: doc['acceptPayOnDelivery'],
        distanceText: doc['distanceText'],
        phoneNumber: doc['phoneNumber'],
        distance: doc['distance'],
        partnerFee: doc['fee'],
        dispatchDistance: doc['dispatchDistance']);
  }
}
