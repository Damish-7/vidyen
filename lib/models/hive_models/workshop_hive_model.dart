// lib/models/hive_models/workshop_hive_model.dart
import 'package:hive/hive.dart';

part 'workshop_hive_model.g.dart';

@HiveType(typeId: 4)
class WorkshopHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String facilitator;

  @HiveField(3)
  late String designation;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  late String time;

  @HiveField(7)
  late String duration; // e.g. "3 hours"

  @HiveField(8)
  late String venue;

  @HiveField(9)
  late int maxParticipants;

  @HiveField(10)
  late int registeredCount;

  @HiveField(11)
  late bool isRegistered;

  @HiveField(12)
  late List<String> topics; // workshop topics/agenda

  WorkshopHiveModel({
    required this.id,
    required this.title,
    required this.facilitator,
    required this.designation,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    required this.venue,
    required this.maxParticipants,
    required this.registeredCount,
    this.isRegistered = false,
    required this.topics,
  });

  bool get isFull => registeredCount >= maxParticipants;
}