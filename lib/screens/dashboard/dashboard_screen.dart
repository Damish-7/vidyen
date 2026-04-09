// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
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
    final r = context.r;

    return Obx(() {
      final index = dashController.currentIndex.value;

      // Tablet/Desktop: show rail navigation instead of bottom bar
      if (r.isTablet || r.isDesktop) {
        return _WideLayout(
          index: index,
          titles: _titles,
          pages: _pages,
          dashController: dashController,
          authController: authController,
          r: r,
        );
      }

      // Mobile: standard bottom nav
      return _MobileLayout(
        index: index,
        titles: _titles,
        pages: _pages,
        dashController: dashController,
        authController: authController,
        r: r,
      );
    });
  }
}

// ── Mobile layout (bottom nav) ───────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final int index;
  final List<String> titles;
  final List<Widget> pages;
  final DashboardController dashController;
  final AuthController authController;
  final Responsive r;

  const _MobileLayout({
    required this.index,
    required this.titles,
    required this.pages,
    required this.dashController,
    required this.authController,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, authController, index, titles, r),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: pages[index],
      ),
      bottomNavigationBar: _BottomNav(
        index: index,
        onTap: dashController.changeTab,
      ),
    );
  }
}

// ── Tablet/Desktop layout (side rail) ───────────────────────────────────────
class _WideLayout extends StatelessWidget {
  final int index;
  final List<String> titles;
  final List<Widget> pages;
  final DashboardController dashController;
  final AuthController authController;
  final Responsive r;

  const _WideLayout({
    required this.index,
    required this.titles,
    required this.pages,
    required this.dashController,
    required this.authController,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, authController, index, titles, r),
      body: Row(
        children: [
          // Side navigation rail
          Container(
            width: r.isDesktop ? 200 : 72,
            color: AppColors.primary,
            child: Column(
              children: [
                const SizedBox(height: 12),
                ..._navItems.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  final isActive = i == index;
                  final showLabel = r.isDesktop;

                  return GestureDetector(
                    onTap: () => dashController.changeTab(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      padding: EdgeInsets.symmetric(
                        horizontal: showLabel ? 16 : 0,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isActive
                            ? Border.all(
                                color: AppColors.secondary.withOpacity(0.2))
                            : null,
                      ),
                      child: showLabel
                          ? Row(
                              children: [
                                Icon(
                                  isActive
                                      ? item.activeIcon
                                      : item.icon,
                                  color: isActive
                                      ? AppColors.secondary
                                      : AppColors.textMuted,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: 13,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isActive
                                        ? AppColors.secondary
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                color: isActive
                                    ? AppColors.secondary
                                    : AppColors.textMuted,
                                size: 22,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            color: AppColors.secondary.withOpacity(0.1),
          ),

          // Main content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: pages[index],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared AppBar builder ────────────────────────────────────────────────────
PreferredSizeWidget _buildAppBar(
  BuildContext context,
  AuthController authController,
  int index,
  List<String> titles,
  Responsive r,
) {
  return AppBar(
    backgroundColor: AppColors.primary,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Center(
        child: Text(
          titles[index],
          style: TextStyle(
            fontFamily: 'Sora',
            fontSize: r.sp(11),
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
    title: ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.primaryGradient.createShader(bounds),
      child: Text(
        'VIDYEN',
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: r.sp(22),
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 5,
        ),
      ),
    ),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () => _showProfileSheet(context, authController, r),
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
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: r.sp(13),
                  fontWeight: FontWeight.w700,
                  color: AppColors.background,
                ),
              ),
            );
          }),
        ),
      ),
      GestureDetector(
        onTap: () => _confirmLogout(context, authController),
        child: Container(
          margin: const EdgeInsets.only(right: 14),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.error.withOpacity(0.25)),
          ),
          child: const Icon(Icons.logout_rounded,
              color: AppColors.error, size: 18),
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
  );
}

void _showProfileSheet(
    BuildContext context, AuthController authController, Responsive r) {
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
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
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
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: r.sp(28),
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? '',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: r.sp(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.sp(13),
                fontFamily: 'Sora',
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
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            color: AppColors.textSecondary, fontFamily: 'Sora'),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel',
              style: TextStyle(
                  color: AppColors.textSecondary, fontFamily: 'Sora')),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            authController.logout();
          },
          child: const Text('Logout',
              style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sora')),
        ),
      ],
    ),
  );
}

// ── Bottom nav (mobile) ──────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int index;
  final void Function(int) onTap;
  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border(
          top: BorderSide(
              color: AppColors.secondary.withOpacity(0.15), width: 1),
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
            children: _navItems.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = i == index;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.secondary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive
                              ? AppColors.secondary
                              : AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.secondary
                              : AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ── Nav item data ────────────────────────────────────────────────────────────
class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItemData(
      {required this.icon,
      required this.activeIcon,
      required this.label});
}

const List<_NavItemData> _navItems = [
  _NavItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home'),
  _NavItemData(
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
      label: 'Abstracts'),
  _NavItemData(
      icon: Icons.event_outlined,
      activeIcon: Icons.event_rounded,
      label: 'Pre-Conf'),
  _NavItemData(
      icon: Icons.handshake_outlined,
      activeIcon: Icons.handshake_rounded,
      label: 'Workshop'),
  _NavItemData(
      icon: Icons.workspace_premium_outlined,
      activeIcon: Icons.workspace_premium_rounded,
      label: 'Certificates'),
];