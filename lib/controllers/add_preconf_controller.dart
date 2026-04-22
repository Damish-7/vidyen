// lib/controllers/add_preconf_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class AddPreConfController extends GetxController {
  final ApiService _api = ApiService();

  final titleController       = TextEditingController();
  final speakerController     = TextEditingController();
  final designationController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController       = TextEditingController();
  final maxParticipantsController = TextEditingController(text: '50');

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString selectedTimeStart = '09:00 AM'.obs;
  final RxString selectedTimeEnd   = '01:00 PM'.obs;

  final RxBool   isLoading = false.obs;
  final RxString error     = ''.obs;

  // Time options
  final List<String> timeOptions = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
    '06:00 PM',
  ];

  String get formattedDate {
    final d = selectedDate.value;
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String get apiDate {
    final d = selectedDate.value;
    return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }

  String get timeRange => '${selectedTimeStart.value} – ${selectedTimeEnd.value}';

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00C9B1),
            surface: Color(0xFF132240),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> submit() async {
    final title    = titleController.text.trim();
    final speaker  = speakerController.text.trim();
    final venue    = venueController.text.trim();
    final maxStr   = maxParticipantsController.text.trim();

    if (title.isEmpty || speaker.isEmpty || venue.isEmpty) {
      error.value = 'Title, speaker and venue are required.';
      return;
    }

    final maxP = int.tryParse(maxStr) ?? 50;
    if (maxP < 1 || maxP > 500) {
      error.value = 'Max participants must be between 1 and 500.';
      return;
    }

    isLoading.value = true;
    error.value = '';

    final result = await _api.post('/preconf', {
      'title':            title,
      'speaker':          speaker,
      'designation':      designationController.text.trim(),
      'description':      descriptionController.text.trim(),
      'session_date':     apiDate,
      'session_time':     timeRange,
      'venue':            venue,
      'max_participants': maxP,
    });

    isLoading.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'Session Created!',
        'The pre-conference session has been added.',
        backgroundColor: const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } else {
      error.value = result['message'] ?? 'Failed to create session.';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    speakerController.dispose();
    designationController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    maxParticipantsController.dispose();
    super.onClose();
  }
}