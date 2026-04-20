// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/hive_models/abstract_hive_model.dart';
import '../../models/hive_models/preconf_hive_model.dart';
import '../../models/hive_models/workshop_hive_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/hive_boxes.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final dashController = Get.find<DashboardController>();
    final r = context.r;

    // Live counts from Hive
    final abstractsBox = Hive.box<AbstractHiveModel>(HiveBoxes.abstracts);
    final preconfBox   = Hive.box<PreConfHiveModel>(HiveBoxes.preconf);
    final workshopsBox = Hive.box<WorkshopHiveModel>(HiveBoxes.workshops);

    final acceptedCount  = abstractsBox.values.where((a) => a.status == 'accepted').length;
    final preconfCount   = preconfBox.values.where((p) => p.isRegistered).length;
    final workshopCount  = workshopsBox.values.where((w) => w.isRegistered).length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.isDesktop ? 860 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Welcome Banner ─────────────────────────────────────────────
              Obx(() {
                final user = authController.currentUser.value;
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(r.isDesktop ? 28 : 22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0A2540), Color(0xFF0D3060)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back,',
                                style: TextStyle(color: AppColors.textSecondary,
                                    fontSize: r.sp(12), fontFamily: 'Sora')),
                            const SizedBox(height: 4),
                            Text(user?.name ?? 'Attendee',
                                style: TextStyle(fontFamily: 'Sora',
                                    fontSize: r.sp(20), fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            if (user?.designation != null) ...[
                              const SizedBox(height: 2),
                              Text(user!.designation!,
                                  style: TextStyle(color: AppColors.accent,
                                      fontSize: r.sp(12), fontFamily: 'Sora')),
                            ],
                            if (user?.institution != null) ...[
                              const SizedBox(height: 2),
                              Text(user!.institution!,
                                  style: TextStyle(color: AppColors.secondary,
                                      fontSize: r.sp(11), fontFamily: 'Sora')),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [AppColors.secondary, AppColors.accent]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            authController.currentUser.value?.initials ?? 'U',
                            style: TextStyle(fontFamily: 'Sora',
                                fontSize: r.sp(20), fontWeight: FontWeight.w700,
                                color: AppColors.background),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // ── Stats Row ──────────────────────────────────────────────────
              Row(
                children: [
                  _StatCard(label: 'Accepted\nAbstracts', value: '$acceptedCount',
                      color: AppColors.secondary, icon: Icons.check_circle_outline_rounded),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Pre-Conf\nRegistered', value: '$preconfCount',
                      color: AppColors.accent, icon: Icons.event_available_rounded),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Workshops\nBooked', value: '$workshopCount',
                      color: AppColors.highlight, icon: Icons.handshake_outlined),
                ],
              ),

              const SizedBox(height: 28),

              // ── Quick Access ───────────────────────────────────────────────
              Text('Quick Access',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(16),
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 14),

              GridView.count(
                crossAxisCount: r.isMobile ? 2 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: r.isMobile ? 1.05 : 1.0,
                children: [
                  _QuickCard(icon: Icons.article_outlined, label: 'Abstracts',
                      color: AppColors.secondary,
                      onTap: () => dashController.changeTab(1)),
                  _QuickCard(icon: Icons.event_outlined, label: 'Pre-Conference',
                      color: AppColors.accent,
                      onTap: () => dashController.changeTab(2)),
                  _QuickCard(icon: Icons.handshake_outlined, label: 'Workshops',
                      color: AppColors.highlight,
                      onTap: () => dashController.changeTab(3)),
                  _QuickCard(icon: Icons.workspace_premium_outlined, label: 'Certificates',
                      color: const Color(0xFFBB86FC),
                      onTap: () => dashController.changeTab(4)),
                ],
              ),

              const SizedBox(height: 28),

              // ── Conference Info Banner ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A2540), Color(0xFF091C35)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_month_outlined,
                          color: AppColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Text('Conference Schedule',
                          style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(14),
                              fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ]),
                    const SizedBox(height: 14),
                    _ScheduleRow(day: 'Day 1 — Mar 14', label: 'Pre-Conference Sessions',
                        color: AppColors.accent, r: r),
                    const SizedBox(height: 8),
                    _ScheduleRow(day: 'Day 2 — Mar 15', label: 'Workshops & Keynote',
                        color: AppColors.secondary, r: r),
                    const SizedBox(height: 8),
                    _ScheduleRow(day: 'Day 3 — Mar 16', label: 'Oral & Poster Presentations',
                        color: AppColors.highlight, r: r),
                    const SizedBox(height: 8),
                    _ScheduleRow(day: 'Day 4 — Mar 17', label: 'Closing & Certificates',
                        color: const Color(0xFFBB86FC), r: r),
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

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value,
      required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(24),
                    fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(10),
                    color: AppColors.textSecondary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ── Quick Card ────────────────────────────────────────────────────────────────
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickCard({required this.icon, required this.label,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(label,
              style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Schedule Row ──────────────────────────────────────────────────────────────
class _ScheduleRow extends StatelessWidget {
  final String day;
  final String label;
  final Color color;
  final Responsive r;
  const _ScheduleRow({required this.day, required this.label,
      required this.color, required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 3, height: 36, decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(day, style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
            color: color, fontWeight: FontWeight.w600)),
        Text(label, style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
            color: AppColors.textPrimary)),
      ]),
    ]);
  }
}
