import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/user_model.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'user_provider.dart';

class PaymentProvider with ChangeNotifier {
  final payDio = Dio(
    BaseOptions(headers: {
      'Authorization':
          'Bearer sk_test_30a4e9b494a363cf4f700cd265f6cf4c12a7e0f3',
    }, baseUrl: 'https://api.paystack.co', contentType: "application/json"),
  );

  Charge charge = Charge();
  String accessCode;
  String reference;
  String authUrl;
  String trackingId;
  String pdc;
  String liveSecretKey = "sk_live_bd8486a65986f5f25dba231c06c7f0edd784d971";
  String livePublicKey = "pk_live_109f1f60fc3c58c194d2481f3ce14e73c43ea485";
  String testSecretKey = "sk_test_30a4e9b494a363cf4f700cd265f6cf4c12a7e0f3";
  String testPublicKey = "pk_test_162f59052b353792406b069174446f4419d1f599";

  Future<bool> authorize(email, amount) async {


    try {

      Response response = await payDio.post('/transaction/initialize',
          data: {'email': email, 'amount': amount});

      accessCode = response.data['data']['access_code'];
      reference = response.data['data']['reference'];
      authUrl = response.data['data']['authorization_url'];


      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }


  changeTrackingID(String trackingId, String pdc) {
    this.trackingId = trackingId;
    this.pdc = pdc;
    notifyListeners();
  }

  int editInt(int amount) {

    int edited = amount * 100;
    print(edited);
    return edited;
  }

  Future<CheckoutResponse> payStackPay(

      BuildContext context, int amount, String email) async {
    int finalAmount = editInt(amount);
    final plugin = PaystackPlugin();
   await  plugin.initialize(publicKey: testPublicKey);
   print(plugin.sdkInitialized);
    try {
      bool success = await authorize(email, finalAmount);
      if (success) {
        charge
          ..amount = finalAmount
          ..reference = reference
          ..email = email
          ..accessCode = accessCode
          ..currency = 'NGN';

        CheckoutResponse response = await plugin.checkout(
          context,

          logo: Image(
            image: AssetImage('assets/images/logo.png'),
            height: 40,
            width: 40,
          ),
          // fullscreen: true,
          charge: charge,
        );

        print(response.reference);
        print(response.status);
        print(response.message);
        print(response.verify);
        print(response.method);
       return response;

      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> payWithWallet(context,
      {String reference, double amount, String pin}) async {
    EasyLoading.show(status: 'Please Wait..');
    var authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    String accessToken = userProvider.currentUser.accessToken;
    print(accessToken);
    var booking = Provider.of<BookingProvider>(context, listen: false);

    try {
      Response response = await dio.post(
          '/api/services/app/Payment/PayWithWallet',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "reference": reference,
            "amount": amount.toInt(),
            "pin": pin
          }).timeout(Duration(seconds: 20));
      print(response.data);
      trackingId = response.data['result']['data']['trackingId'];
      bool isSuccess = response.data['result']['isSuccess'];
      pdc = response.data['result']['data']['pdc'];
      print(isSuccess);


      if(response.data['result']['message'] == 'Invalid wallet PIN')   {
        EasyLoading.showError('Invalid Pin');
      }

if(isSuccess) {
  EasyLoading.dismiss();
  authProvider
      .getCurrentUser(context, accessToken: accessToken)
      .then((userMap) {
    userProvider.updateUser(User(walletBalance: userMap['walletBalance']));
  });
}
EasyLoading.dismiss();

      return isSuccess;
    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    } catch (e) {

      print(e);


        EasyLoading.showError('Make sure PIN is correct or check your connection');

      return false;
    }
  }

  Future<bool> transferWallet (BuildContext context, int amount, String recipient, String pin) async {
    EasyLoading.show(status: 'Transfer In Progress');
    var authProvider =
    Provider.of<AuthenticationProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    String accessToken = userProvider.currentUser.accessToken;
    print(accessToken);
    var booking = Provider.of<BookingProvider>(context, listen: false);
    try{
      Response response =
          await dio.post('/api/services/app/Payment/WalletTransfer',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "receiverPhoneNumber": recipient,
            "amount": amount,
            "pin": pin
          }).timeout(Duration(seconds: 30));
      print(response.data);
      if(response.data['result']['isSuccess']) {

        authProvider
            .getCurrentUser(context, accessToken: accessToken)
            .then((userMap) {
          userProvider.updateUser(
              User(walletBalance: userMap['walletBalance']));
        });
        EasyLoading.dismiss();
        return true;
      } else {
        if(response.data['result']['message'] == 'Insufficient wallet balance') {
         await EasyLoading.showError('Insufficient Funds', duration: Duration(seconds: 5));
        }
        if (response.data['result']['message'] == 'Record not found') {
        await  EasyLoading.showError('Recipient does not exist.', duration: Duration(seconds: 5));
        }


        return false;

      }
    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;

    }
    catch (e){
      print(e);
      EasyLoading.showError('Failed, Try again or check that number is registered on Verigo!');
      return false;
    }
  }


  Future<bool> fundWallet (BuildContext context, int amount, String email) async {
    EasyLoading.show(status: 'Please Wait ...');
    var authProvider =
    Provider.of<AuthenticationProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    String accessToken = userProvider.currentUser.accessToken;
    print(accessToken);
    var booking = Provider.of<BookingProvider>(context, listen: false);
EasyLoading.dismiss();
    try {

      CheckoutResponse paystackResponse  =  await payStackPay(context, amount, email);
      bool isSuccess = paystackResponse.status;
      if (isSuccess == true) {
        EasyLoading.show(status: 'Please Wait...');

        try {
          Response response =
          await dio.post('/api/services/app/Payment/PayWithPayStack',
              options: Options(
                headers: {'Authorization': 'Bearer $accessToken'},
              ),
              data: {
                "type": 2,
                // "reference": bookingId,
                "amount": amount,
                "isSuccess": true,
                "gatewayRef": paystackResponse.reference
              }).timeout(Duration(seconds: 20));

          print(response.data);

          EasyLoading.dismiss();
          if (response.data['result']['isSuccess']) {
            EasyLoading.dismiss();
            authProvider
                .getCurrentUser(context, accessToken: accessToken)
                .then((userMap) {
              userProvider.updateUser(User(walletBalance: userMap['walletBalance']));
            });
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
    } on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    }

    catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong, Please try again.');
      return false;
    }



  }

  Future<bool> changeWalletPin(context, String currentPin, String newPin) async {
    EasyLoading.show(status: 'Please wait');
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    try {
      Response response =
      await dio.post('/api/services/app/Payment/ChangeWalletPIN',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          "currentPIN": currentPin,
          "newPIN": newPin
        }
      );

      print(response.data);

      if(response.data['result']['isSuccess'] == true) {
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.showError('Incorrect Current Pin');
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


  getBanks(context) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    try {
      Response response =
          await dio.get('/api/services/app/Payment/GetBanks',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

 Future<List<WalletTransaction>> getWalletTransactions(context) async {
    String accessToken = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);

    try {
      Response response =
      await dio.get('/api/services/app/Payment/GetWalletTransactions',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),);
      print(response.data);

      List result = await response.data['result']['data'];
      if(result!=null) {
        List<WalletTransaction> transactions = result.map((doc) {
          return WalletTransaction.fromDocument(doc);
        }).toList();
        print(result.reversed);
        notifyListeners();

        return transactions;
      } else {

        notifyListeners();
        return [];
      }

    } catch (e) {
      print(e);
      return [];
    }

  }

}


class WalletTransaction{
  final String id;
  final String sender;
  final String receiver;
  final double amount;
  final bool isCredit;
  final String createdOn;

  WalletTransaction({this.id, this.sender, this.receiver, this.amount, this.isCredit, this.createdOn});

  factory WalletTransaction.fromDocument(doc) {
    return WalletTransaction(
      id: doc['id'],
      sender: doc['fromName'],
      receiver: doc['toName'],
      amount: doc['amount'],
      isCredit: doc['isCredit'],
      createdOn: doc['createdOn']
    );
  }

}