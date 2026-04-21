// lib/controllers/app_bindings.dart
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'dashboard_controller.dart';
import 'home_controller.dart';
import 'abstracts_controller.dart';
import 'preconf_controller.dart';
import 'workshop_controller.dart';
import 'certificates_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<AbstractsController>(() => AbstractsController(), fenix: true);
    Get.lazyPut<PreConfController>(() => PreConfController(), fenix: true);
    Get.lazyPut<WorkshopController>(() => WorkshopController(), fenix: true);
    Get.lazyPut<CertificatesController>(() => CertificatesController(), fenix: true);
  }
}
