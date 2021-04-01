import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final int userType;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String surname;

  @HiveField(3)
  final String emailAddress;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final String fullname;

  @HiveField(6)
  final String lastLoginTime;

  @HiveField(7)
  final String creationTime;

  @HiveField(8)
  final List roleNames;

  @HiveField(9)
  final int id;

  @HiveField(10)
  final String phoneNumber;

  @HiveField(11)
  final String accessToken;

  @HiveField(12)
  final String verigoNumber;

  @HiveField(13)
  final double walletBalance;

  User(
      {this.walletBalance, this.phoneNumber, this.verigoNumber, this.accessToken, this.userType, this.name, this.surname, this.emailAddress, this.isActive, this.fullname, this.lastLoginTime, this.creationTime, this.roleNames, this.id});
}