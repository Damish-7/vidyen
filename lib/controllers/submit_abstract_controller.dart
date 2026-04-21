// lib/controllers/submit_abstract_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class SubmitAbstractController extends GetxController {
  final ApiService _api = ApiService();

  final titleController       = TextEditingController();
  final authorsController     = TextEditingController();
  final institutionController = TextEditingController();
  final abstractTextController = TextEditingController();

  final RxString selectedCategory        = 'Oncology'.obs;
  final RxString selectedPresentationType = 'oral'.obs;
  final RxBool isLoading   = false.obs;
  final RxString error     = ''.obs;
  final RxString successMsg = ''.obs;

  final List<String> categories = [
    'Oncology', 'Endocrinology', 'Neurology',
    'Digital Health', 'Haematology', 'Cardiology',
    'Orthopaedics', 'Paediatrics', 'Psychiatry', 'Other',
  ];

  Future<void> submit() async {
    final title    = titleController.text.trim();
    final authors  = authorsController.text.trim();
    final inst     = institutionController.text.trim();
    final abstract = abstractTextController.text.trim();

    if (title.isEmpty || authors.isEmpty || inst.isEmpty || abstract.isEmpty) {
      error.value = 'Please fill in all required fields.';
      return;
    }
    if (abstract.length < 100) {
      error.value = 'Abstract text must be at least 100 characters.';
      return;
    }

    isLoading.value = true;
    error.value = '';
    successMsg.value = '';

    final result = await _api.post('/abstracts', {
      'title':             title,
      'authors':           authors,
      'institution':       inst,
      'category':          selectedCategory.value,
      'abstract_text':     abstract,
      'presentation_type': selectedPresentationType.value,
    });

    isLoading.value = false;

    if (result['success'] == true) {
      // Clear form
      titleController.clear();
      authorsController.clear();
      institutionController.clear();
      abstractTextController.clear();
      selectedCategory.value = 'Oncology';
      selectedPresentationType.value = 'oral';

      Get.back(result: true); // signal AbstractsScreen to refresh
      Get.snackbar(
        'Abstract Submitted!',
        'Your abstract is under review. You can track it in the Abstracts tab.',
        backgroundColor: const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } else {
      error.value = result['message'] ?? 'Submission failed. Please try again.';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    authorsController.dispose();
    institutionController.dispose();
    abstractTextController.dispose();
    super.onClose();
  }
}