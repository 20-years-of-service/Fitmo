// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      gender: fields[4] as String?,
      age: fields[5] as int?,
      weight: fields[6] as double?,
      height: fields[7] as double?,
      objective: fields[8] as String?,
      secondaryObjectives: (fields[9] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.height)
      ..writeByte(8)
      ..write(obj.objective)
      ..writeByte(9)
      ..write(obj.secondaryObjectives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
