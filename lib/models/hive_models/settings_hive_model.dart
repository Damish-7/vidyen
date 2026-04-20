// lib/models/hive_models/settings_hive_model.dart
import 'package:hive/hive.dart';

part 'settings_hive_model.g.dart';

@HiveType(typeId: 6)
class SettingsHiveModel extends HiveObject {
  @HiveField(0)
  late bool notificationsEnabled;

  @HiveField(1)
  late bool emailAlertsEnabled;

  @HiveField(2)
  late String language; // 'en', 'hi', etc.

  @HiveField(3)
  late bool biometricEnabled;

  @HiveField(4)
  late DateTime lastSyncAt;

  SettingsHiveModel({
    this.notificationsEnabled = true,
    this.emailAlertsEnabled = true,
    this.language = 'en',
    this.biometricEnabled = false,
    required this.lastSyncAt,
  });
}