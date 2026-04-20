// lib/services/hive_service.dart
// Central Hive initializer — call once in main.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_models/user_hive_model.dart';
import '../models/hive_models/session_hive_model.dart';
import '../models/hive_models/abstract_hive_model.dart';
import '../models/hive_models/preconf_hive_model.dart';
import '../models/hive_models/workshop_hive_model.dart';
import '../models/hive_models/certificate_hive_model.dart';
import '../models/hive_models/settings_hive_model.dart';
import '../utils/hive_boxes.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register all adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(SessionHiveModelAdapter());
    Hive.registerAdapter(AbstractHiveModelAdapter());
    Hive.registerAdapter(PreConfHiveModelAdapter());
    Hive.registerAdapter(WorkshopHiveModelAdapter());
    Hive.registerAdapter(CertificateHiveModelAdapter());
    Hive.registerAdapter(SettingsHiveModelAdapter());

    // Open all boxes
    await Hive.openBox<UserHiveModel>(HiveBoxes.users);
    await Hive.openBox<SessionHiveModel>(HiveBoxes.session);
    await Hive.openBox<AbstractHiveModel>(HiveBoxes.abstracts);
    await Hive.openBox<PreConfHiveModel>(HiveBoxes.preconf);
    await Hive.openBox<WorkshopHiveModel>(HiveBoxes.workshops);
    await Hive.openBox<CertificateHiveModel>(HiveBoxes.certificates);
    await Hive.openBox<SettingsHiveModel>(HiveBoxes.settings);
  }

  static Box<T> box<T>(String name) => Hive.box<T>(name);

  static Future<void> closeAll() async => await Hive.close();

  static Future<void> clearAll() async {
    await Hive.box<UserHiveModel>(HiveBoxes.users).clear();
    await Hive.box<SessionHiveModel>(HiveBoxes.session).clear();
    await Hive.box<AbstractHiveModel>(HiveBoxes.abstracts).clear();
    await Hive.box<PreConfHiveModel>(HiveBoxes.preconf).clear();
    await Hive.box<WorkshopHiveModel>(HiveBoxes.workshops).clear();
    await Hive.box<CertificateHiveModel>(HiveBoxes.certificates).clear();
    await Hive.box<SettingsHiveModel>(HiveBoxes.settings).clear();
  }
}
