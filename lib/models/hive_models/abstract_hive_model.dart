// lib/models/hive_models/abstract_hive_model.dart
import 'package:hive/hive.dart';

part 'abstract_hive_model.g.dart';

@HiveType(typeId: 2)
class AbstractHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String authors;

  @HiveField(3)
  late String institution;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String abstractText;

  @HiveField(6)
  late String status; // 'pending' | 'accepted' | 'rejected'

  @HiveField(7)
  late String presentationType; // 'oral' | 'poster'

  @HiveField(8)
  late DateTime submittedAt;

  @HiveField(9)
  String? submittedByUserId;

  AbstractHiveModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.institution,
    required this.category,
    required this.abstractText,
    required this.status,
    required this.presentationType,
    required this.submittedAt,
    this.submittedByUserId,
  });
}
