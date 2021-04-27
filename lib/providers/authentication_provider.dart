import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/user_model.dart';
import 'package:verigo/providers/user_provider.dart';
import 'dart:io' show Platform;

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
    int channel;
    if(Platform.isAndroid) {
      channel = 2;
    } else if (Platform.isIOS) {
      channel = 3;

    }



    try {
      Response response =
          await dio.post('/api/services/app/Account/NewUser', data: {
        'userType': 1,
        'name': name,
        'surname': surname,
        'phoneNumber': phoneNumber,
        'emailAddress': email,
            'channel': channel,
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
    try {
      Response response = await dio.post('/api/TokenAuth/Authenticate', data: {
        "userNameOrEmailAddress": email,
        "password": password,
        "rememberClient": true
      });
      // print(response.data);
      String token = response.data['result']['accessToken'];
      userId = response.data['result']['userId'];
      this.token = token;
      print(this.token);


      return token;
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      return '';
    }
  }

  // Future<User> getUserInfo({int userId, accessToken}) async {
  //   try {
  //     Response response = await dio.get(
  //       '/api/services/app/User/Get',
  //       queryParameters: {'Id': userId},
  //     );
  //   } catch (e) {}
  // }

  Future<Map> getCurrentUser(context, {String accessToken}) async {

    try {
      Response response = await dio.get(
          '/api/services/app/Session/GetCurrentLoginInformations',
          options: Options(headers: {'Authorization': 'Bearer ${token ?? accessToken}'}));
      print(response.data);


      Map userMap = response.data['result']['user'];


      return userMap;

    } catch (e) {
      print(e);

      return null;
    }
  }

  Future<int> forgotPassword (context, String email) async {
    EasyLoading.show(status: 'Please wait');
    try {
      Response response = await dio.post('/api/services/app/Account/ForgotPassword',

          data: {
            "emailAddress": email,
          }
      ).timeout(Duration(seconds: 20));

      print(response.data);
      if(response.data['result']['isSuccess']) {
        EasyLoading.dismiss();
        int id = response.data['result']['data']['userId'];
        return id;

      } else {
        EasyLoading.showError('User does not exist!');
        return null;
      }

    } on TimeoutException{
      EasyLoading.showError('Timeout');
      return null;
    }
    catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return null;
    }
  }

  Future<bool> resetPassword(context, int userId, String password ) async {
    EasyLoading.show(status: 'Please wait');
    print(userId);
    print(password);
    try {
      Response response = await dio.post('/api/services/app/Account/ResetPassword',

          data: {
            "userId": userId,
            "newPassword": password,
          }
      ).timeout(Duration(seconds: 20));
      print(response.data);

      if(response.data['result']['isSuccess']) {
        EasyLoading.dismiss();
        return  true;
      } else {
        EasyLoading.showError('Something went wrong');
        return false;
      }


    }
    on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    } catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return false;
    }

  }

  Future<bool> verifyCode(context, int userId, String code ) async {
    EasyLoading.show(status: 'Please wait');
    try {
      Response response = await dio.post('/api/services/app/Account/VerifyCode',

          data: {
            "userId": userId,
            "code": code,
          }
      ).timeout(Duration(seconds: 20));
      print(response.data);
      if(response.data['result']['isSuccess']) {
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.showError('Wrong Verification Code');
        return false;
      }

    }
    on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    } catch (e) {
      print(e);
      EasyLoading.showError('Something went wrong');
      return false;
    }

  }

  Future<bool> changePassword(context, {String accessToken, String currentPassword, String newPassword}) async {
    EasyLoading.show(status: 'Please wait');
    try {
      Response response = await dio.post('/api/services/app/Account/ChangePassword',

          options: Options(headers: {'Authorization': 'Bearer ${token ?? accessToken}'}),

      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }
      ).timeout(Duration(seconds: 20));

print(response.data);

if(response.data['result']['isSuccess']) {
  EasyLoading.dismiss();
  return true;
} else {
  EasyLoading.showError('Wrong Current Password'
  );
  return false;
}


    } on TimeoutException{
      EasyLoading.showError('Timeout'
          );
      return false;
    }

    catch (e) {
      print(e);
      EasyLoading.showError('Failed');
      return false;
    }
  }

}
