// lib/controllers/workshop_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/hive_models/workshop_hive_model.dart';
import '../utils/hive_boxes.dart';

class WorkshopController extends GetxController {
  Box<WorkshopHiveModel> get _box => Hive.box<WorkshopHiveModel>(HiveBoxes.workshops);

  final RxList<WorkshopHiveModel> workshops = <WorkshopHiveModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkshops();
  }

  void loadWorkshops() {
    workshops.value = _box.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> toggleRegistration(WorkshopHiveModel workshop) async {
    if (workshop.isFull && !workshop.isRegistered) {
      Get.snackbar('Workshop Full',
          'This workshop has reached maximum capacity.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: const Color(0xFFF0F4FF),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
    workshop.isRegistered = !workshop.isRegistered;
    workshop.registeredCount += workshop.isRegistered ? 1 : -1;
    await workshop.save();
    loadWorkshops();
    Get.snackbar(
      workshop.isRegistered ? 'Registered!' : 'Registration Cancelled',
      workshop.isRegistered
          ? 'You are registered for "${workshop.title}"'
          : 'You have been removed from "${workshop.title}"',
      backgroundColor: workshop.isRegistered
          ? const Color(0xFF00C9B1)
          : const Color(0xFF4F8EF7),
      colorText: const Color(0xFF060E1E),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  int get registeredCount => workshops.where((w) => w.isRegistered).length;
}
