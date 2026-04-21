// lib/controllers/workshop_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/workshop_model.dart';
import '../services/api_service.dart';

class WorkshopController extends GetxController {
  final ApiService _api = ApiService();

  final RxList<WorkshopModel> workshops = <WorkshopModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkshops();
  }

  Future<void> fetchWorkshops() async {
    isLoading.value = true;
    error.value = '';
    final result = await _api.get('/workshops');
    isLoading.value = false;
    if (result['success'] == true) {
      workshops.value = (result['data'] as List)
          .map((j) => WorkshopModel.fromJson(j))
          .toList();
    } else {
      error.value = result['message'] ?? 'Failed to load workshops.';
    }
  }

  Future<void> toggleRegistration(WorkshopModel workshop) async {
    if (workshop.isFull) {
      Get.snackbar('Workshop Full', 'This workshop has reached maximum capacity.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
      return;
    }

    final result = workshop.isRegistered
        ? await _api.delete('/workshops/${workshop.id}/register')
        : await _api.post('/workshops/${workshop.id}/register', {});

    if (result['success'] == true) {
      Get.snackbar(
        workshop.isRegistered ? 'Cancelled' : 'Booked!',
        result['message'] ?? '',
        backgroundColor: workshop.isRegistered
            ? const Color(0xFF4F8EF7)
            : const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16), borderRadius: 12,
      );
      await fetchWorkshops();
    } else {
      Get.snackbar('Error', result['message'] ?? 'Something went wrong.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
    }
  }

  int get registeredCount => workshops.where((w) => w.isRegistered).length;
}