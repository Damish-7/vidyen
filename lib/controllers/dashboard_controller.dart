// lib/controllers/dashboard_controller.dart
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;
  void changeTab(int i) => currentIndex.value = i;
}