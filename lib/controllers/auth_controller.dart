// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // ── Observables ────────────────────────────────────────────────────────────
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
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

  // ── Lifecycle ──────────────────────────────────────────────────────────────
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

    if (result['success']) {
      currentUser.value = result['user'] as UserModel;
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

    if (result['success']) {
      Get.back();
      Get.snackbar(
        'Success',
        'Account created! Please log in.',
        backgroundColor: const Color(0xFF00C9B1),
        colorText: const Color(0xFF060E1E),
        snackPosition: SnackPosition.BOTTOM,
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

  Future<void> loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    currentUser.value = user;
  }

  void toggleLoginPasswordVisibility() =>
      loginPasswordVisible.value = !loginPasswordVisible.value;

  void toggleRegPasswordVisibility() =>
      regPasswordVisible.value = !regPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;

  void clearError() => errorMessage.value = '';
}