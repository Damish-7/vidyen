// lib/models/hive_models/preconf_hive_model.dart
import 'package:hive/hive.dart';

part 'preconf_hive_model.g.dart';

@HiveType(typeId: 3)
class PreConfHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String speaker;

  @HiveField(3)
  late String designation;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  late String time;

  @HiveField(7)
  late String venue;

  @HiveField(8)
  late int maxParticipants;

  @HiveField(9)
  late int registeredCount;

  @HiveField(10)
  late bool isRegistered; // current user registered?

  PreConfHiveModel({
    required this.id,
    required this.title,
    required this.speaker,
    required this.designation,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.maxParticipants,
    required this.registeredCount,
    this.isRegistered = false,
  });

  bool get isFull => registeredCount >= maxParticipants;
}