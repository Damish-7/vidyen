// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/hive_models/user_hive_model.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // ── Observables ────────────────────────────────────────────────────────────
  final Rx<UserHiveModel?> currentUser = Rx<UserHiveModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Login form
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final RxBool loginPasswordVisible = false.obs;

  // Register form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final RxBool regPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  @override
  void onClose() {
    identifierController.dispose();
    loginPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    regPasswordController.dispose();
    confirmPasswordController.dispose();
    designationController.dispose();
    institutionController.dispose();
    super.onClose();
  }

  // ── Methods ────────────────────────────────────────────────────────────────
  Future<void> login() async {
    if (identifierController.text.trim().isEmpty ||
        loginPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _authService.login(
      identifier: identifierController.text.trim(),
      password: loginPasswordController.text,
    );

    isLoading.value = false;

    if (result['success'] == true) {
      currentUser.value = result['user'] as UserHiveModel;
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      errorMessage.value = result['message'];
    }
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        regPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all required fields';
      return;
    }
    if (regPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }
    if (regPasswordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final result = await _authService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      username: usernameController.text.trim(),
      password: regPasswordController.text,
      designation: designationController.text.trim(),
      institution: institutionController.text.trim(),
    );

    isLoading.value = false;

    if (result['success'] == true) {
      _clearRegisterForm();
      Get.back();
      Get.snackbar(
        'Account Created!',
        'You can now sign in with your credentials.',
        backgroundColor: const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      errorMessage.value = result['message'];
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser.value = null;
    identifierController.clear();
    loginPasswordController.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  void loadCurrentUser() {
    final user = _authService.getCurrentUser();
    currentUser.value = user;
  }

  void _clearRegisterForm() {
    nameController.clear();
    emailController.clear();
    usernameController.clear();
    regPasswordController.clear();
    confirmPasswordController.clear();
    designationController.clear();
    institutionController.clear();
  }

  void toggleLoginPasswordVisibility() =>
      loginPasswordVisible.value = !loginPasswordVisible.value;
  void toggleRegPasswordVisibility() =>
      regPasswordVisible.value = !regPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;
  void clearError() => errorMessage.value = '';
}
