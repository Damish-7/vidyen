// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preconf_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreConfHiveModelAdapter extends TypeAdapter<PreConfHiveModel> {
  @override
  final int typeId = 3;

  @override
  PreConfHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreConfHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      speaker: fields[2] as String,
      designation: fields[3] as String,
      description: fields[4] as String,
      date: fields[5] as DateTime,
      time: fields[6] as String,
      venue: fields[7] as String,
      maxParticipants: fields[8] as int,
      registeredCount: fields[9] as int,
      isRegistered: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PreConfHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.speaker)
      ..writeByte(3)
      ..write(obj.designation)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.venue)
      ..writeByte(8)
      ..write(obj.maxParticipants)
      ..writeByte(9)
      ..write(obj.registeredCount)
      ..writeByte(10)
      ..write(obj.isRegistered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreConfHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
