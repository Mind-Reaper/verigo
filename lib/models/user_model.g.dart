// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      walletBalance: fields[13] as int,
      phoneNumber: fields[10] as String,
      verigoNumber: fields[12] as String,
      accessToken: fields[11] as String,
      userType: fields[0] as int,
      name: fields[1] as String,
      surname: fields[2] as String,
      emailAddress: fields[3] as String,
      isActive: fields[4] as bool,
      fullname: fields[5] as String,
      lastLoginTime: fields[6] as String,
      creationTime: fields[7] as String,
      roleNames: (fields[8] as List)?.cast<dynamic>(),
      id: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.userType)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.surname)
      ..writeByte(3)
      ..write(obj.emailAddress)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.fullname)
      ..writeByte(6)
      ..write(obj.lastLoginTime)
      ..writeByte(7)
      ..write(obj.creationTime)
      ..writeByte(8)
      ..write(obj.roleNames)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.accessToken)
      ..writeByte(12)
      ..write(obj.verigoNumber)
      ..writeByte(13)
      ..write(obj.walletBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
