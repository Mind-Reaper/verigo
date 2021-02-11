import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StateProvider extends ChangeNotifier {
  bool online = true;
  changeOnlineStatus(bool value) {
    online = false;
    notifyListeners();
  }

  PageController homePageController = PageController();
  int pageIndex = 0;
  changePageIndex(int index) {
    pageIndex = index;
    homePageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    notifyListeners();
  }

  String expandedId = '000';
  changeExpandedId(String id) {
    expandedId = id;
    notifyListeners();
  }

  String selectedCard;
  changeSelectedCard(String id) {
    selectedCard = id;
    notifyListeners();
  }
}
