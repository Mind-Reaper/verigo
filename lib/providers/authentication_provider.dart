import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:verigo/models/user_model.dart';

final dio = Dio(
  BaseOptions(headers: {
    'clientid': 'F066DBF7-4E1B-493E-9FC3-08D8CAF60EB0',
    'clientsecret': 'VG-3a699aa1-095a-420e-b07b-d7f71f2a008b'
  }, baseUrl: 'https://api.myverigo.com', contentType: "application/json"),
);

class AuthenticationProvider with ChangeNotifier {
  User user = User();
  int userId;
  String token;

  Future<bool> createUserWithEmail(
      {String name,
      String surname,
      String phoneNumber,
      String email,
      String password,
      String referralCode}) async {
    EasyLoading.show(status: 'Creating Account');
    try {
      Response response =
          await dio.post('/api/services/app/Account/User', data: {
        'userType': 1,
        'name': name,
        'surname': surname,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'referralCode': referralCode,
      });
      print(response.data);
      bool success = response.data['result']['isSuccess'];
      userId = response.data['result']['data']['id'];
EasyLoading.showSuccess('Account Created');

      return success;
    } catch (e) {
      print(e);
      EasyLoading.showError('Account Registration Failed!');
      return false;
    }
  }

  Future<bool> verifyPhoneNumber({int userId, String otp}) async {
    EasyLoading.show(status: 'Verifying OTP');
    try {
      Response response = await dio
          .post('/api/services/app/Account/VerifyOTP', queryParameters: {
        'userId': userId != null ? userId : this.userId,
        'otp': otp,
      });
      print(response.data);
      bool success = response.data['result']['isSuccess'];
      EasyLoading.showSuccess('OTP Verification Complete');
      return success;
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      return false;
    }
  }


  Future<String> tokenAuth(String email, String password) async {
    EasyLoading.show(status: 'Signing In');
    try{
    Response response = await   dio.post('/api/TokenAuth/Authenticate', data: {
      "userNameOrEmailAddress": email,
      "password": password,
      "rememberClient": true
      });
    print(response.data);
    String token = response.data['result']['accessToken'];
    userId = response.data['result']['userId'];
    this.token = token;

    return token;

    }
    catch (e)  {
      print(e);
      EasyLoading.dismiss();
      return '';
    }
  }

  Future<User> getUserInfo({int userId, accessToken}) async {
    try{
      Response response = await dio.get('/api/services/app/User/Get',
      queryParameters: {
        'Id': userId
      },

      );
    }
    catch (e) {

    }
  }

  Future<Map> getCurrentUser() async {
    EasyLoading.show(status: 'Signing In');
    try{
      Response response = await dio.get('/api/services/app/Session/GetCurrentLoginInformations',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      )
      );
      print(response.data);
  Map userMap = response.data['result']['user'];


      return userMap;
    }
    catch (e){
      print(e);

      return null;
    }
  }

}
