import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  String name;
  String surname;
  String email;
  String phoneNumber;
  int id;

  setUser(Map userMap) {
    name = userMap['name'];
    surname = userMap['surname'];
    email = userMap['emailAddress'];
    id = userMap['id'];
    notifyListeners();
  }
}