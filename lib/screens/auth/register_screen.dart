// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/vidyen_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1E3A5F),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

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
                              'Personal Info',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            VidyenTextField(
                              controller: controller.nameController,
                              label: 'Full Name *',
                              hint: 'Dr. Jane Smith',
                              prefixIcon: Icons.badge_outlined,
                              onChanged: (_) => controller.clearError(),
                            ),
                            const SizedBox(height: 14),

                            VidyenTextField(
                              controller: controller.emailController,
                              label: 'Email Address *',
                              hint: 'jane@university.edu',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => controller.clearError(),
                            ),
                            const SizedBox(height: 14),

                            VidyenTextField(
                              controller: controller.usernameController,
                              label: 'Username *',
                              hint: 'janesmith',
                              prefixIcon: Icons.alternate_email_rounded,
                              onChanged: (_) => controller.clearError(),
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Professional Info',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            VidyenTextField(
                              controller: controller.designationController,
                              label: 'Designation',
                              hint: 'Assistant Professor',
                              prefixIcon: Icons.work_outline_rounded,
                              onChanged: (_) => controller.clearError(),
                            ),
                            const SizedBox(height: 14),

                            VidyenTextField(
                              controller: controller.institutionController,
                              label: 'Institution / Organisation',
                              hint: 'University of ...',
                              prefixIcon: Icons.account_balance_outlined,
                              onChanged: (_) => controller.clearError(),
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Security',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.highlight,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Obx(() => VidyenTextField(
                                  controller: controller.regPasswordController,
                                  label: 'Password *',
                                  hint: 'Min. 6 characters',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isPassword: true,
                                  passwordVisible:
                                      controller.regPasswordVisible.value,
                                  onTogglePassword:
                                      controller.toggleRegPasswordVisibility,
                                  onChanged: (_) => controller.clearError(),
                                )),
                            const SizedBox(height: 14),

                            Obx(() => VidyenTextField(
                                  controller:
                                      controller.confirmPasswordController,
                                  label: 'Confirm Password *',
                                  hint: 'Re-enter password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isPassword: true,
                                  passwordVisible:
                                      controller.confirmPasswordVisible.value,
                                  onTogglePassword:
                                      controller.toggleConfirmPasswordVisibility,
                                  onChanged: (_) => controller.clearError(),
                                )),

                            const SizedBox(height: 24),

                            // Error
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
                                    const Icon(Icons.error_outline_rounded,
                                        color: AppColors.error, size: 16),
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

                            Obx(() => GradientButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.register,
                                  isLoading: controller.isLoading.value,
                                  label: 'Create Account',
                                )),

                            const SizedBox(height: 16),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: const Text(
                                      'Sign In',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}