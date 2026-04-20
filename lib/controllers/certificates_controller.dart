// lib/controllers/certificates_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../controllers/auth_controller.dart';
import '../models/hive_models/certificate_hive_model.dart';
import '../utils/hive_boxes.dart';

class CertificatesController extends GetxController {
  Box<CertificateHiveModel> get _box =>
      Hive.box<CertificateHiveModel>(HiveBoxes.certificates);

  final RxList<CertificateHiveModel> certificates = <CertificateHiveModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCertificates();
  }

  void loadCertificates() {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser.value?.id;
    certificates.value = _box.values
        .where((c) => c.userId == userId)
        .toList()
      ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
  }

  Future<void> markDownloaded(CertificateHiveModel cert) async {
    cert.isDownloaded = true;
    await cert.save();
    loadCertificates();
    Get.snackbar('Downloaded', 'Certificate saved successfully.',
        backgroundColor: const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  int get totalCount => certificates.length;
  int get downloadedCount => certificates.where((c) => c.isDownloaded).length;
}
