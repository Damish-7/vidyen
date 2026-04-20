// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbstractHiveModelAdapter extends TypeAdapter<AbstractHiveModel> {
  @override
  final int typeId = 2;

  @override
  AbstractHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbstractHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      authors: fields[2] as String,
      institution: fields[3] as String,
      category: fields[4] as String,
      abstractText: fields[5] as String,
      status: fields[6] as String,
      presentationType: fields[7] as String,
      submittedAt: fields[8] as DateTime,
      submittedByUserId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AbstractHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.institution)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.abstractText)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.presentationType)
      ..writeByte(8)
      ..write(obj.submittedAt)
      ..writeByte(9)
      ..write(obj.submittedByUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbstractHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
