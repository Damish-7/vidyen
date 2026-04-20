// lib/controllers/app_bindings.dart
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'dashboard_controller.dart';
import 'abstracts_controller.dart';
import 'preconf_controller.dart';
import 'workshop_controller.dart';
import 'certificates_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Put eagerly (not lazy) so all controllers are available immediately
    // when any screen in the bottom nav tries to access them
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<AbstractsController>(AbstractsController(), permanent: true);
    Get.put<PreConfController>(PreConfController(), permanent: true);
    Get.put<WorkshopController>(WorkshopController(), permanent: true);
    Get.put<CertificatesController>(CertificatesController(), permanent: true);
  }
}