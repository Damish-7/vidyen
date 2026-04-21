// lib/controllers/certificates_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/certificate_model.dart';
import '../services/api_service.dart';

class CertificatesController extends GetxController {
  final ApiService _api = ApiService();

  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCertificates();
  }

  Future<void> fetchCertificates() async {
    isLoading.value = true;
    error.value = '';
    final result = await _api.get('/certificates');
    isLoading.value = false;
    if (result['success'] == true) {
      certificates.value = (result['data'] as List)
          .map((j) => CertificateModel.fromJson(j))
          .toList();
    } else {
      error.value = result['message'] ?? 'Failed to load certificates.';
    }
  }

  Future<void> markDownloaded(CertificateModel cert) async {
    final result = await _api.put('/certificates/${cert.id}/download', {});
    if (result['success'] == true) {
      Get.snackbar('Downloaded', 'Certificate saved successfully.',
          backgroundColor: const Color(0xFF00C9B1),
          colorText: const Color(0xFF060E1E),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
      await fetchCertificates();
    } else {
      Get.snackbar('Error', result['message'] ?? 'Something went wrong.',
          backgroundColor: const Color(0xFFFF4D6D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16), borderRadius: 12);
    }
  }

  int get totalCount      => certificates.length;
  int get downloadedCount => certificates.where((c) => c.isDownloaded).length;
}