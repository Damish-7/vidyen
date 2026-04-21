// lib/controllers/abstracts_controller.dart
import 'package:get/get.dart';
import '../models/abstract_model.dart';
import '../services/api_service.dart';

class AbstractsController extends GetxController {
  final ApiService _api = ApiService();

  final RxList<AbstractModel> abstracts = <AbstractModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter   = 'All'.obs;
  final RxString selectedCategory = 'All'.obs;

  final RxInt totalCount    = 0.obs;
  final RxInt acceptedCount = 0.obs;
  final RxInt pendingCount  = 0.obs;
  final RxInt rejectedCount = 0.obs;

  final List<String> filters    = ['All', 'Accepted', 'Pending', 'Rejected'];
  final List<String> categories = ['All', 'Oncology', 'Endocrinology',
      'Neurology', 'Digital Health', 'Haematology'];

  @override
  void onInit() {
    super.onInit();
    fetchAbstracts();
  }

  Future<void> fetchAbstracts() async {
    isLoading.value = true;
    error.value = '';

    final params = <String>[];
    if (selectedFilter.value != 'All')
      params.add('status=${selectedFilter.value}');
    if (selectedCategory.value != 'All')
      params.add('category=${selectedCategory.value}');
    final query = params.isEmpty ? '' : '?${params.join('&')}';

    final result = await _api.get('/abstracts$query');
    isLoading.value = false;

    if (result['success'] == true) {
      final data = result['data'];
      abstracts.value = (data['abstracts'] as List)
          .map((j) => AbstractModel.fromJson(j))
          .toList();
      final stats   = data['stats'];
      totalCount.value    = stats['total']    ?? 0;
      acceptedCount.value = stats['accepted'] ?? 0;
      pendingCount.value  = stats['pending']  ?? 0;
      rejectedCount.value = stats['rejected'] ?? 0;
    } else {
      error.value = result['message'] ?? 'Failed to load abstracts.';
    }
  }

  void setFilter(String f) {
    selectedFilter.value = f;
    fetchAbstracts();
  }

  void setCategory(String c) {
    selectedCategory.value = c;
    fetchAbstracts();
  }
}