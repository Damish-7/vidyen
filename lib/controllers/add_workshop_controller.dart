// lib/controllers/add_workshop_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class AddWorkshopController extends GetxController {
  final ApiService _api = ApiService();

  final titleController       = TextEditingController();
  final facilitatorController = TextEditingController();
  final designationController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController       = TextEditingController();
  final maxParticipantsController = TextEditingController(text: '30');
  // Topics — users add them one by one
  final topicInputController  = TextEditingController();

  final Rx<DateTime> selectedDate  = DateTime.now().obs;
  final RxString selectedTimeStart = '08:00 AM'.obs;
  final RxString selectedDuration  = '2 hours'.obs;

  final RxList<String> topics  = <String>[].obs;
  final RxBool   isLoading     = false.obs;
  final RxString error         = ''.obs;

  final List<String> timeOptions = [
    '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM',
    '05:00 PM',
  ];

  final List<String> durationOptions = [
    '1 hour', '1.5 hours', '2 hours', '2.5 hours', '3 hours',
    '3.5 hours', '4 hours', '5 hours', '6 hours', 'Full day',
  ];

  // ── Date ──────────────────────────────────────────────────────────────────
  String get formattedDate {
    final d = selectedDate.value;
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
                'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  String get apiDate {
    final d = selectedDate.value;
    return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFD166),
            surface: Color(0xFF132240),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  // ── Topics ────────────────────────────────────────────────────────────────
  void addTopic() {
    final t = topicInputController.text.trim();
    if (t.isEmpty) return;
    if (topics.contains(t)) {
      error.value = 'Topic already added.';
      return;
    }
    topics.add(t);
    topicInputController.clear();
    error.value = '';
  }

  void removeTopic(String t) => topics.remove(t);

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> submit() async {
    final title       = titleController.text.trim();
    final facilitator = facilitatorController.text.trim();
    final venue       = venueController.text.trim();
    final maxStr      = maxParticipantsController.text.trim();

    if (title.isEmpty || facilitator.isEmpty || venue.isEmpty) {
      error.value = 'Title, facilitator and venue are required.';
      return;
    }

    final maxP = int.tryParse(maxStr) ?? 30;
    if (maxP < 1 || maxP > 500) {
      error.value = 'Max participants must be between 1 and 500.';
      return;
    }

    isLoading.value = true;
    error.value = '';

    final result = await _api.post('/workshops', {
      'title':            title,
      'facilitator':      facilitator,
      'designation':      designationController.text.trim(),
      'description':      descriptionController.text.trim(),
      'workshop_date':    apiDate,
      'workshop_time':    selectedTimeStart.value,
      'duration':         selectedDuration.value,
      'venue':            venue,
      'max_participants': maxP,
      'topics':           topics.toList(),
    });

    isLoading.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'Workshop Created!',
        'The workshop has been added successfully.',
        backgroundColor: const Color(0xFFFFD166),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } else {
      error.value = result['message'] ?? 'Failed to create workshop.';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    facilitatorController.dispose();
    designationController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    maxParticipantsController.dispose();
    topicInputController.dispose();
    super.onClose();
  }
}