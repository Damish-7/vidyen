// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../home/home_screen.dart';
import '../abstracts/abstracts_screen.dart';
import '../preconf/preconf_screen.dart';
import '../workshop/workshop_screen.dart';
import '../certificates/certificates_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    AbstractsScreen(),
    PreConfScreen(),
    WorkshopScreen(),
    CertificatesScreen(),
  ];

  static const List<String> _titles = [
    'Home',
    'Abstracts',
    'Pre-Conference',
    'Workshop',
    'Certificates',
  ];

  @override
  Widget build(BuildContext context) {
    final dashController = Get.find<DashboardController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      final index = dashController.currentIndex.value;

      return Scaffold(
        backgroundColor: AppColors.background,

        // ── AppBar ──────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,

          // Left: subtle tab label
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Center(
              child: Text(
                _titles[index],
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Center: VIDYEN brand
          title: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: const Text(
              'VIDYEN',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 5,
              ),
            ),
          ),
          centerTitle: true,

          // Right: Profile + Logout
          actions: [
            // Profile icon
            GestureDetector(
              onTap: () => _showProfileSheet(context, authController),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  final user = authController.currentUser.value;
                  return Center(
                    child: Text(
                      user?.initials ?? 'U',
                      style: const TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Logout icon
            GestureDetector(
              onTap: () => _confirmLogout(context, authController),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.25),
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
              ),
            ),
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.secondary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Body ────────────────────────────────────────────────────────────
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _pages[index],
        ),

        // ── Bottom Navigation Bar ────────────────────────────────────────────
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            border: Border(
              top: BorderSide(
                color: AppColors.secondary.withOpacity(0.15),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    iconOutlined: Icons.home_outlined,
                    label: 'Home',
                    index: 0,
                    currentIndex: index,
                    onTap: dashController.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.article_rounded,
                    iconOutlined: Icons.article_outlined,
                    label: 'Abstracts',
                    index: 1,
                    currentIndex: index,
                    onTap: dashController.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.event_rounded,
                    iconOutlined: Icons.event_outlined,
                    label: 'Pre-Conf',
                    index: 2,
                    currentIndex: index,
                    onTap: dashController.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.handshake_rounded,
                    iconOutlined: Icons.handshake_outlined,
                    label: 'Workshop',
                    index: 3,
                    currentIndex: index,
                    onTap: dashController.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.workspace_premium_rounded,
                    iconOutlined: Icons.workspace_premium_outlined,
                    label: 'Certificates',
                    index: 4,
                    currentIndex: index,
                    onTap: dashController.changeTab,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showProfileSheet(BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final user = authController.currentUser.value;
        return Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    user?.initials ?? 'U',
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                user?.name ?? '',
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Sora',
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
              const SizedBox(height: 28),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Sora',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Sora'),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
                fontFamily: 'Sora',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom nav item ─────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconOutlined;
  final String label;
  final int index;
  final int currentIndex;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.iconOutlined,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.secondary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? icon : iconOutlined,
                color: isActive ? AppColors.secondary : AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color:
                    isActive ? AppColors.secondary : AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}