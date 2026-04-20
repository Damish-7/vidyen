// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/vidyen_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final r = context.r;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: r.screenPadding, vertical: 16),
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
                          border:
                              Border.all(color: const Color(0xFF1E3A5F)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: r.sp(20),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.screenPadding, vertical: 8),
                    child: Column(
                      children: [
                        SizedBox(
                          width: r.cardWidth,
                          child: _RegisterCard(controller: controller, r: r),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
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

class _RegisterCard extends StatelessWidget {
  final AuthController controller;
  final Responsive r;
  const _RegisterCard({required this.controller, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E3A5F)),
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
          _SectionLabel(label: 'Personal Info', color: AppColors.secondary, r: r),
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

          _SectionLabel(label: 'Professional Info', color: AppColors.accent, r: r),
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

          _SectionLabel(label: 'Security', color: AppColors.highlight, r: r),
          const SizedBox(height: 16),

          Obx(() => VidyenTextField(
                controller: controller.regPasswordController,
                label: 'Password *',
                hint: 'Min. 6 characters',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                passwordVisible: controller.regPasswordVisible.value,
                onTogglePassword: controller.toggleRegPasswordVisibility,
                onChanged: (_) => controller.clearError(),
              )),
          const SizedBox(height: 14),

          Obx(() => VidyenTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password *',
                hint: 'Re-enter password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                passwordVisible: controller.confirmPasswordVisible.value,
                onTogglePassword: controller.toggleConfirmPasswordVisibility,
                onChanged: (_) => controller.clearError(),
              )),

          const SizedBox(height: 24),

          Obx(() {
            if (controller.errorMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: r.sp(12),
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
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.sp(13),
                    fontFamily: 'Sora',
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: r.sp(13),
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
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  final Responsive r;
  const _SectionLabel(
      {required this.label, required this.color, required this.r});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Sora',
        fontSize: r.sp(12),
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.5,
      ),
    );
  }
}
