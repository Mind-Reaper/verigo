import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/user_model.dart';
import 'package:verigo/providers/authentication_provider.dart';

class UserProvider with ChangeNotifier {
  // String name;
  // String surname;
  // String email;
  // String phoneNumber;
  // int id;
  // String accessToken;

  User currentUser;

  Future saveUser(User user) async {
    var box = await Hive.openBox<User>('user');
    await box.add(user);
   await  getUser();
    notifyListeners();
  }

 Future updateUser(User user) async {
    var box = await Hive.openBox<User>('user');

    int userType =  box.getAt(0)?.userType;
    String name = box.get(0)?.name;
    String surname = box.get(0)?.surname;
    String fullname = box.get(0)?.fullname;
    String phoneNumber = box.get(0)?.phoneNumber;
    int id = box.get(0)?.id;
    String emailAddress = box.get(0)?.emailAddress;
    bool isActive = box.get(0)?.isActive;
    String lastLoginTime = box.get(0)?.lastLoginTime;
    String creationTime = box.get(0)?.creationTime;
    String accessToken = box.get(0)?.accessToken;
    List roleNames = box.get(0)?.roleNames;
    String verigoNumber = box.get(0)?.verigoNumber;
    int walletBalance = box.get(0)?.walletBalance;


  await  box.putAt(
        0,
        User(
            userType: user.userType ?? userType,
            name: user.name ?? name,
            surname: user.surname ?? surname,
            fullname: user.fullname ?? fullname,
            phoneNumber: user.phoneNumber ?? phoneNumber,
            id: user.id ?? id,
            emailAddress: user.emailAddress ?? emailAddress,
            isActive: user.isActive ?? isActive,
            lastLoginTime: user.lastLoginTime ?? lastLoginTime,
            creationTime: user.creationTime ?? creationTime,
            accessToken: user.accessToken ?? accessToken,
            roleNames: user.roleNames ?? roleNames,
            verigoNumber: user.verigoNumber ?? verigoNumber,
            walletBalance: user.walletBalance ?? walletBalance)).then((value){
              getUser();
  });




    notifyListeners();
  }

  Future getUser() async {
    var box = await Hive.openBox<User>('user');

    currentUser =   box.get(0);

    notifyListeners();

  }

  Future logout() async {
    var box = await Hive.openBox<User>('user');
    await box.deleteFromDisk();

  currentUser = null;
    notifyListeners();
  }

  Future<bool> updateUserApi(context, {String name, String surname , String mobileNumber}) async {
    EasyLoading.show(status: 'Updating');
    var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    try{

      // print(name + ' ' + currentUser.surname + ' ' + currentUser.phoneNumber );
      Response response = await dio.post(
       '/api/services/app/Account/ProfileUpdate',
        options: Options(
          headers: {'Authorization': 'Bearer ${currentUser.accessToken}'},
        ),
        data: {
          "name": name ?? currentUser.name,
          "surname": surname ?? currentUser.surname,
          "phoneNumber": mobileNumber ?? currentUser.phoneNumber
        }
      ).timeout(Duration(seconds: 20));
      print(response.data);
      if(response.data['result']['isSuccess']) {
        authProvider.getCurrentUser(context, accessToken: currentUser.accessToken).then((userMap) async {
          if (userMap != null) {
            await updateUser(User(
              name: userMap['name'],
              surname: userMap['surname'],
              emailAddress: userMap['emailAddress'],
              id: userMap['id'],
              walletBalance: userMap['walletBalance'],
              phoneNumber: userMap['phoneNumber'],
              verigoNumber: userMap['affiliateCode'],
            ));
          }

        });
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.showError("Something went wrong!");
        return false;
      }



    }
    on TimeoutException {
      EasyLoading.showError('Timeout');
      return false;
    }

    catch (e) {
      print(e);
    EasyLoading.showError('Profile Update Failed');
    return false;
    }
  }
}
