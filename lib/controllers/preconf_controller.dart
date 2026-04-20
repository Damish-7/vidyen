// lib/controllers/preconf_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/hive_models/preconf_hive_model.dart';
import '../utils/hive_boxes.dart';

class PreConfController extends GetxController {
  Box<PreConfHiveModel> get _box => Hive.box<PreConfHiveModel>(HiveBoxes.preconf);

  final RxList<PreConfHiveModel> sessions = <PreConfHiveModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  void loadSessions() {
    sessions.value = _box.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> toggleRegistration(PreConfHiveModel session) async {
    if (session.isFull && !session.isRegistered) {
      Get.snackbar('Session Full',
          'This session has reached maximum capacity.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: const Color(0xFFF0F4FF),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
    session.isRegistered = !session.isRegistered;
    session.registeredCount += session.isRegistered ? 1 : -1;
    await session.save();
    loadSessions();
    Get.snackbar(
      session.isRegistered ? 'Registered!' : 'Registration Cancelled',
      session.isRegistered
          ? 'You are registered for "${session.title}"'
          : 'You have been removed from "${session.title}"',
      backgroundColor: session.isRegistered
          ? const Color(0xFF00C9B1)
          : const Color(0xFF4F8EF7),
      colorText: const Color(0xFF060E1E),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  int get registeredCount => sessions.where((s) => s.isRegistered).length;
}
