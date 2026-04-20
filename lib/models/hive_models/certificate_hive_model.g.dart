// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificateHiveModelAdapter extends TypeAdapter<CertificateHiveModel> {
  @override
  final int typeId = 5;

  @override
  CertificateHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CertificateHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      title: fields[3] as String,
      eventName: fields[4] as String,
      issuedAt: fields[5] as DateTime,
      certificateCode: fields[6] as String,
      isDownloaded: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CertificateHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.eventName)
      ..writeByte(5)
      ..write(obj.issuedAt)
      ..writeByte(6)
      ..write(obj.certificateCode)
      ..writeByte(7)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
