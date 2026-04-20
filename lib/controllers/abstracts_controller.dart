// lib/controllers/abstracts_controller.dart
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/hive_models/abstract_hive_model.dart';
import '../utils/hive_boxes.dart';

class AbstractsController extends GetxController {
  Box<AbstractHiveModel> get _box => Hive.box<AbstractHiveModel>(HiveBoxes.abstracts);

  final RxList<AbstractHiveModel> abstracts = <AbstractHiveModel>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;

  final List<String> filters = ['All', 'Accepted', 'Pending', 'Rejected'];
  final List<String> categories = ['All', 'Oncology', 'Endocrinology',
      'Neurology', 'Digital Health', 'Haematology'];

  @override
  void onInit() {
    super.onInit();
    loadAbstracts();
  }

  void loadAbstracts() {
    isLoading.value = true;
    abstracts.value = _box.values.toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    isLoading.value = false;
  }

  List<AbstractHiveModel> get filtered {
    return abstracts.where((a) {
      final statusMatch = selectedFilter.value == 'All' ||
          a.status.toLowerCase() == selectedFilter.value.toLowerCase();
      final categoryMatch = selectedCategory.value == 'All' ||
          a.category == selectedCategory.value;
      return statusMatch && categoryMatch;
    }).toList();
  }

  void setFilter(String f) => selectedFilter.value = f;
  void setCategory(String c) => selectedCategory.value = c;

  int get totalCount => abstracts.length;
  int get acceptedCount => abstracts.where((a) => a.status == 'accepted').length;
  int get pendingCount  => abstracts.where((a) => a.status == 'pending').length;
  int get rejectedCount => abstracts.where((a) => a.status == 'rejected').length;
}