// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _api = ApiService();

  final RxInt acceptedAbstracts = 0.obs;
  final RxInt preconfRegistered = 0.obs;
  final RxInt workshopsBooked   = 0.obs;
  final RxInt certificates      = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading.value = true;
    error.value = '';
    final result = await _api.get('/home/stats');
    isLoading.value = false;
    if (result['success'] == true) {
      final d = result['data'];
      acceptedAbstracts.value = d['accepted_abstracts'] ?? 0;
      preconfRegistered.value  = d['preconf_registered']  ?? 0;
      workshopsBooked.value    = d['workshops_booked']    ?? 0;
      certificates.value       = d['certificates']        ?? 0;
    } else {
      error.value = result['message'] ?? 'Failed to load stats.';
    }
  }
}