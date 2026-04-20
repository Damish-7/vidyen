// lib/models/hive_models/user_hive_model.dart
import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  String? username;

  @HiveField(4)
  String? avatar;

  @HiveField(5)
  String? designation;

  @HiveField(6)
  String? institution;

  @HiveField(7)
  late String passwordHash; // stored hashed, never plain text

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.avatar,
    this.designation,
    this.institution,
    required this.passwordHash,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}