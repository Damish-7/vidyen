// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/vidyen_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Logo + title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.secondary, AppColors.accent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.35),
                              blurRadius: 28,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'V',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        child: const Text(
                          'VIDYEN',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Conference Portal',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontFamily: 'Sora',
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF1E3A5F),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to access the portal',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Identifier field
                      VidyenTextField(
                        controller: controller.identifierController,
                        label: 'Email or Username',
                        hint: 'Enter your email or username',
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => controller.clearError(),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      Obx(() => VidyenTextField(
                            controller: controller.loginPasswordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            passwordVisible: controller.loginPasswordVisible.value,
                            onTogglePassword: controller.toggleLoginPasswordVisibility,
                            onChanged: (_) => controller.clearError(),
                          )),

                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: implement forgot password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Error message
                      Obx(() {
                        if (controller.errorMessage.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.error,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Login button
                      Obx(() => GradientButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.login,
                            isLoading: controller.isLoading.value,
                            label: 'Sign In',
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Register link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontFamily: 'Sora',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}