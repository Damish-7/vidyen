// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionHiveModelAdapter extends TypeAdapter<SessionHiveModel> {
  @override
  final int typeId = 1;

  @override
  SessionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionHiveModel(
      userId: fields[0] as String,
      token: fields[1] as String,
      loginAt: fields[2] as DateTime,
      isLoggedIn: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.loginAt)
      ..writeByte(3)
      ..write(obj.isLoggedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
