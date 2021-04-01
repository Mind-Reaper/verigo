import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentProvider with ChangeNotifier {
  final dio = Dio(
    BaseOptions(
        headers: {
      'Authorization':
          'Bearer sk_test_30a4e9b494a363cf4f700cd265f6cf4c12a7e0f3',
    },
     baseUrl: 'https://api.paystack.co', contentType: "application/json"),
  );

  Charge charge = Charge();
  String accessCode;
  String reference;
  String authUrl;

  Future<bool> authorize(email, amount) async {
    try {
      EasyLoading.show();
      Response response = await dio.post('/transaction/initialize',
          data: {'email': email, 'amount': amount});

      accessCode = response.data['data']['access_code'];
      reference = response.data['data']['reference'];
      authUrl = response.data['data']['authorization_url'];

      EasyLoading.dismiss();
      return true;
    } catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return false;
    }
  }

  int editInt(int amount) {
    String i = "${amount}00";
    int edited = int.parse(i);
    print(edited);
    return edited;
  }

  Future<bool> fundWallet(BuildContext context, int amount, String email) async {
   int finalAmount = editInt(amount);
    try {
      bool success = await authorize(email, amount);
      if (success) {
        charge
          ..amount = finalAmount
          ..reference = reference
          ..email = email
          ..accessCode = accessCode
          ..currency = 'NGN';

       

        CheckoutResponse response = await PaystackPlugin().checkout(
          context,
          logo: Image(
            image: AssetImage('assets/images/logo.png'),
            height: 40,
            width: 40,
          ),
          // fullscreen: true,
          charge: charge,
        );

        print(response.status);
        return response.status;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }


}
