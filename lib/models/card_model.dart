import 'package:hive/hive.dart';

part 'card_model.g.dart';




@HiveType(typeId: 0)
class UserCreditCard{


  @HiveField(0)
  final String cardHolder;

  @HiveField(1)
  final String cardNumber;

  @HiveField(2)
  final String expiryDate;

  @HiveField(3)
  final String cvv;

  @HiveField(4)
  final String cardIssuer;

  UserCreditCard({this.cardHolder, this.cardNumber, this.expiryDate, this.cvv, this.cardIssuer});
}

