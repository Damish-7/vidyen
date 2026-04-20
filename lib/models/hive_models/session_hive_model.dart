// lib/models/hive_models/session_hive_model.dart
import 'package:hive/hive.dart';

part 'session_hive_model.g.dart';

@HiveType(typeId: 1)
class SessionHiveModel extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String token;

  @HiveField(2)
  late DateTime loginAt;

  @HiveField(3)
  late bool isLoggedIn;

  SessionHiveModel({
    required this.userId,
    required this.token,
    required this.loginAt,
    this.isLoggedIn = true,
  });
}
