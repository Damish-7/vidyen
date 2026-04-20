// lib/models/hive_models/certificate_hive_model.dart
import 'package:hive/hive.dart';

part 'certificate_hive_model.g.dart';

@HiveType(typeId: 5)
class CertificateHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String type; // 'participation' | 'presenter' | 'workshop' | 'preconf'

  @HiveField(3)
  late String title; // e.g. "Certificate of Participation"

  @HiveField(4)
  late String eventName;

  @HiveField(5)
  late DateTime issuedAt;

  @HiveField(6)
  late String certificateCode; // unique verification code

  @HiveField(7)
  late bool isDownloaded;

  CertificateHiveModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.eventName,
    required this.issuedAt,
    required this.certificateCode,
    this.isDownloaded = false,
  });
}