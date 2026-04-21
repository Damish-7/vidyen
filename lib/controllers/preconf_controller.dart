// lib/controllers/preconf_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/preconf_model.dart';
import '../services/api_service.dart';

class PreConfController extends GetxController {
  final ApiService _api = ApiService();

  final RxList<PreConfModel> sessions = <PreConfModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    isLoading.value = true;
    error.value = '';
    final result = await _api.get('/preconf');
    isLoading.value = false;
    if (result['success'] == true) {
      sessions.value = (result['data'] as List)
          .map((j) => PreConfModel.fromJson(j))
          .toList();
    } else {
      error.value = result['message'] ?? 'Failed to load sessions.';
    }
  }

  Future<void> toggleRegistration(PreConfModel session) async {
    if (session.isFull) {
      Get.snackbar('Session Full', 'This session has reached maximum capacity.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
      return;
    }

    final result = session.isRegistered
        ? await _api.delete('/preconf/${session.id}/register')
        : await _api.post('/preconf/${session.id}/register', {});

    if (result['success'] == true) {
      Get.snackbar(
        session.isRegistered ? 'Cancelled' : 'Registered!',
        result['message'] ?? '',
        backgroundColor: session.isRegistered
            ? const Color(0xFF4F8EF7)
            : const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16), borderRadius: 12,
      );
      await fetchSessions();
    } else {
      Get.snackbar('Error', result['message'] ?? 'Something went wrong.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
    }
  }

  int get registeredCount => sessions.where((s) => s.isRegistered).length;
}