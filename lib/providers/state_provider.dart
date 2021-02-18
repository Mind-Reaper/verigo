import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StateProvider extends ChangeNotifier {
  bool online = true;
  changeOnlineStatus(bool value) {
    online = value;
    notifyListeners();
  }

  PageController homePageController = PageController();
  int pageIndex = 0;
  initiateHomePageController() {
    homePageController = PageController();
  }


  changePageIndex(int index) {
    pageIndex = index;
    notifyListeners();
    // homePageController.animateToPage(index,
    //     duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);

  }

  String expandedId = '000';
  changeExpandedId(String id) {
    expandedId = id;
    notifyListeners();
  }

  String selectedLogistic = 'selectedLogistic';
  changeSelectedLogistic(String logName) {
    selectedLogistic = logName;
    notifyListeners();
  }

  String selectedCard;
  changeSelectedCard(String id) {
    selectedCard = id;
    notifyListeners();
  }

  String referralCode = 'VERIME2021';
  changeReferralCode (code) {
    referralCode = code;
    notifyListeners();
  }

  String selectedPayment = 'E-Wallet';
  changeSelectedPayment(value) {
    selectedPayment = value;
    notifyListeners();
  }

}
