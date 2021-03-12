// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCreditCardAdapter extends TypeAdapter<UserCreditCard> {
  @override
  final int typeId = 0;

  @override
  UserCreditCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCreditCard(
      cardHolder: fields[0] as String,
      cardNumber: fields[1] as String,
      expiryDate: fields[2] as String,
      cvv: fields[3] as String,
      cardIssuer: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserCreditCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cardHolder)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.expiryDate)
      ..writeByte(3)
      ..write(obj.cvv)
      ..writeByte(4)
      ..write(obj.cardIssuer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCreditCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
