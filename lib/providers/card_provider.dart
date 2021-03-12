import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:verigo/models/card_model.dart';

class CreditCardProvider extends ChangeNotifier{

  List _creditCardList = <UserCreditCard>[];
  List get creditCardList => _creditCardList;

  addItem(UserCreditCard item) async {
    var box = await Hive.openBox<UserCreditCard>('user_credit_card');

    box.add(item);
    getItem();

    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<UserCreditCard>('user_credit_card');

    _creditCardList = box.values.toList();

    notifyListeners();
  }

  updateItem(int index, UserCreditCard creditCard) {
    final box = Hive.box<UserCreditCard>('user_credit_card');

    box.putAt(index, creditCard);
    getItem();

    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<UserCreditCard>('user_credit_card');

    box.deleteAt(index);
    getItem();

    notifyListeners();
  }
}