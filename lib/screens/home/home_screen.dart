// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Welcome banner
          Obx(() {
            final user = authController.currentUser.value;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A2540), Color(0xFF0D3060)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? 'Attendee',
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (user?.institution != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user!.institution!,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: 28),

          const Text(
            'Quick Access',
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Quick access grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
            children: const [
              _QuickCard(
                icon: Icons.article_outlined,
                label: 'Abstracts',
                color: AppColors.secondary,
                tabIndex: 1,
              ),
              _QuickCard(
                icon: Icons.event_outlined,
                label: 'Pre-Conference',
                color: AppColors.accent,
                tabIndex: 2,
              ),
              _QuickCard(
                icon: Icons.handshake_outlined,
                label: 'Workshops',
                color: AppColors.highlight,
                tabIndex: 3,
              ),
              _QuickCard(
                icon: Icons.workspace_premium_outlined,
                label: 'Certificates',
                color: Color(0xFFBB86FC),
                tabIndex: 4,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Placeholder notice
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.secondary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Full dashboard content coming soon. Use bottom tabs to explore sections.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int tabIndex;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to tab — DashboardController is accessible
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Sora',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}