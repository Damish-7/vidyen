// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Login form
  final identifierController   = TextEditingController();
  final loginPasswordController = TextEditingController();
  final RxBool loginPasswordVisible = false.obs;

  // Register form
  final nameController            = TextEditingController();
  final emailController           = TextEditingController();
  final usernameController        = TextEditingController();
  final regPasswordController     = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final designationController     = TextEditingController();
  final institutionController     = TextEditingController();
  final RxBool regPasswordVisible     = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedUser();
  }

  Future<void> _loadCachedUser() async {
    currentUser.value = await _authService.getCachedUser();
  }

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
      password:   loginPasswordController.text,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      currentUser.value = result['user'] as UserModel;
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      errorMessage.value = result['message'] ?? 'Login failed.';
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
      name:        nameController.text.trim(),
      email:       emailController.text.trim(),
      username:    usernameController.text.trim(),
      password:    regPasswordController.text,
      designation: designationController.text.trim(),
      institution: institutionController.text.trim(),
    );
    isLoading.value = false;

    if (result['success'] == true) {
      _clearRegisterForm();
      Get.back();
      Get.snackbar('Account Created!',
          'You can now sign in with your credentials.',
          backgroundColor: const Color(0xFF00C9B1),
          colorText: const Color(0xFF060E1E),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
    } else {
      errorMessage.value = result['message'] ?? 'Registration failed.';
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser.value = null;
    identifierController.clear();
    loginPasswordController.clear();
    Get.offAllNamed(AppRoutes.login);
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
}