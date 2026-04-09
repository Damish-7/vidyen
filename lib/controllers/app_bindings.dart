// lib/controllers/app_bindings.dart
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'dashboard_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}