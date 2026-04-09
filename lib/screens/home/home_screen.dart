// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final r = context.r;

    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 20),
      child: Center(
        child: ConstrainedBox(
          // Cap content width on large screens
          constraints: BoxConstraints(maxWidth: r.isDesktop ? 800 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Welcome banner
              Obx(() {
                final user = authController.currentUser.value;
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(r.isDesktop ? 28 : 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0A2540), Color(0xFF0D3060)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.sp(13),
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'Attendee',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(22),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (user?.institution != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          user!.institution!,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: r.sp(12),
                            fontFamily: 'Sora',
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              const SizedBox(height: 28),

              Text(
                'Quick Access',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: r.sp(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Responsive grid: 2 columns on mobile, 4 on tablet/desktop
              GridView.count(
                crossAxisCount: r.isMobile ? 2 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: r.isMobile ? 1.1 : 1.0,
                children: const [
                  _QuickCard(
                    icon: Icons.article_outlined,
                    label: 'Abstracts',
                    color: AppColors.secondary,
                  ),
                  _QuickCard(
                    icon: Icons.event_outlined,
                    label: 'Pre-Conference',
                    color: AppColors.accent,
                  ),
                  _QuickCard(
                    icon: Icons.handshake_outlined,
                    label: 'Workshops',
                    color: AppColors.highlight,
                  ),
                  _QuickCard(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Certificates',
                    color: Color(0xFFBB86FC),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.secondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Full dashboard content coming soon. Use navigation to explore sections.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.sp(12),
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
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
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
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: r.sp(12),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}