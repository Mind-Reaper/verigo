import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/user_provider.dart';

class OrderProvider with ChangeNotifier {


  List<PendingOrder> pendingOrders = [];
  List<PendingOrder> transitOrders = [];
  List<PendingOrder> completedOrders = [];
  PendingOrder order;




  Future<List<PendingOrder>> getPending(context, ) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    try{
     Response response = await dio.get('/api/services/app/Booking/GetUserBookings',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: {
            'status': 1
          }


      );

     List result = await response.data['result']['data'];
     if(result!=null) {
       pendingOrders = result.map((doc) {
         return PendingOrder.fromDocument(doc);
       }).toList().reversed.toList();
       print(result.reversed);
       notifyListeners();

       return pendingOrders.reversed.toList();
     } else {
       pendingOrders = [];
       notifyListeners();
       return [];
     }

  } catch (e) {
      print(e);
      return [];
    }

  

  }



  Future<List<PendingOrder>> getTransit(context, ) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;

    try{
      Response response = await dio.get('/api/services/app/Booking/GetUserBookings',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: {
            'status': 2
          }


      );

      List result = await response.data['result']['data'];
      print(result);
      if(result!=null) {
      transitOrders = result.map((doc) {
          return PendingOrder.fromDocument(doc);
        }).toList().reversed.toList();
        print(result.reversed);
        notifyListeners();
        return transitOrders.reversed.toList();

      } else {
        transitOrders = [];
        notifyListeners();
        return [];
      }

    } catch (e) {
      print(e);
      return [];
    }
  }

 Future<OrderSummary> bookingSummary(context, String bookingId) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false).currentUser.accessToken;
    print(accessToken);
    print(bookingId);

    EasyLoading.show(status: 'Getting Booking Information');

    try {
      Response response = await dio.get('/api/services/app/Booking/Get',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: {
            'id': bookingId,
          });
      print(response.data);

      if(response.data['result']['data'] != null) {
        OrderSummary summary = OrderSummary.fromDocument(response.data['result']['data']);
        EasyLoading.dismiss();
        print(summary.pickupNumber);
        return summary;

      } else {
        EasyLoading.showError('Something went wrong!');
        return null;
      }

    } on TimeoutException{
      EasyLoading.showError('Timeout');
      return null;
    }
    catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong!');
      return null;
    }
  }


  Future<List<PendingOrder>> getCompleted(context, ) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;

    try{
      Response response = await dio.get('/api/services/app/Booking/GetUserBookings',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: {
            'status': 3
          }


      );
      print(response.data);

      List result = await response.data['result']['data'];
      print(result);
      if(result!=null) {
        completedOrders = result.map((doc) {
          return PendingOrder.fromDocument(doc);
        }).toList().reversed.toList();
        print(result.reversed);
        notifyListeners();
        return completedOrders.reversed.toList();

      } else {
        completedOrders = [];
        notifyListeners();
        return [];
      }

    } catch (e) {
      print(e);
      return [];
    }
  }


   getLastRequest(context) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;

    try {
      Response response = await dio.get('/api/services/app/Booking/GetLastDeliveryRequests',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
      );
      print(response.data);
      if(response.data['result']['isSuccess']) {
        order = PendingOrder.fromDocument(response.data['result']['data']);
        notifyListeners();
      } else {

      }

    } catch (e) {
      print(e);

    }

  }

}

class PendingOrder{
  final String bookingId;
  final String reference;
  final String partner;
  final String parcel;
  final int amount;
  final bool veriSure;
  final String status;
  final String ppc;
  final String pdc;
  final String createdOn;


  PendingOrder({
    this.bookingId,
    this.reference,
    this.partner,
    this.parcel,
    this.amount,
    this.veriSure,
    this.status,
    this.ppc,
    this.pdc,
    this.createdOn,
});

  factory PendingOrder.fromDocument(doc){
    return PendingOrder(
      bookingId: doc['bookingId'],
      reference: doc['reference'],
      parcel: doc['parcel'],
      partner: doc['partner'],
      amount: doc['amount'],
      veriSure: doc['veriSure'],
      status: doc['status'],
      pdc: doc['pdc'],
      ppc: doc['ppc'],
      createdOn: doc['createdOn'],
    );
    }
  }



class OrderSummary {
  final String bookingId;
  final String reference;
  final String provider;
  final String providerPhoneNumber;
  final String carrier;
  final String status;
  final String parcel;
  final String pickupName;
  final String pickupNumber;
  final String pickupAddress;
  final String pickupTime;
  final String dropoffName;
  final String dropoffNumber;
  final String dropoffAddress;
  final String description;

  OrderSummary(
      {@required this.bookingId,
        @required this.reference,
        @required this.provider,
        @required this.providerPhoneNumber,
        @required this.carrier,
        @required this.status,
        @required this.pickupName,
        @required this.pickupNumber,
        @required this.pickupAddress,
        @required this.pickupTime,
        @required this.dropoffName,
        @required this.dropoffNumber,
        @required this.dropoffAddress,
        @required this.description,
        @required this.parcel});

  factory OrderSummary.fromDocument(doc) {
    return OrderSummary(
        bookingId: doc['deliveryRequest']['bookingId'],
        reference: doc['deliveryRequest']['reference'],
        provider: doc['deliveryRequest']['provider'],
        providerPhoneNumber: doc['deliveryRequest']['providerPhoneNumber'],
        carrier: doc['deliveryRequest']['carrier'],
        status: doc['deliveryRequest']['status'],
        pickupName: doc['pickupInfo']['name'],
        pickupNumber: doc['pickupInfo']['phoneNumber'],
        pickupAddress: doc['pickupInfo']['address'],
        pickupTime: doc['pickupInfo']['whenToPickup'],
        dropoffName: doc['deliveryInfo']['name'],
        dropoffNumber: doc['deliveryInfo']['phoneNumber'],
        dropoffAddress: doc['deliveryInfo']['address'],
        description: doc['deliveryInfo']['description'],
        parcel: doc['deliveryRequest']['parcel']);
  }
}
