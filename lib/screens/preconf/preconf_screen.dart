// lib/screens/preconf/preconf_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/preconf_controller.dart';
import '../../models/hive_models/preconf_hive_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class PreConfScreen extends StatelessWidget {
  const PreConfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreConfController>();
    final r = context.r;

    return Obx(() {
      final sessions = controller.sessions;

      return Column(children: [
        // Header bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: AppColors.primary,
          child: Row(children: [
            const Icon(Icons.event_outlined, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text('Pre-Conference Sessions — 14 March 2025',
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                    color: AppColors.textSecondary)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${controller.registeredCount} Registered',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.accent, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(r.isDesktop ? 24 : 16),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, i) => _SessionCard(
                session: sessions[i], controller: controller, r: r),
          ),
        ),
      ]);
    });
  }
}

class _SessionCard extends StatelessWidget {
  final PreConfHiveModel session;
  final PreConfController controller;
  final Responsive r;
  const _SessionCard({required this.session, required this.controller, required this.r});

  @override
  Widget build(BuildContext context) {
    final isFull = session.isFull && !session.isRegistered;
    final fillPct = session.registeredCount / session.maxParticipants;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: session.isRegistered
                ? AppColors.accent.withOpacity(0.4)
                : AppColors.textMuted.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Top strip
        Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: session.isRegistered
                    ? [AppColors.accent, AppColors.secondary]
                    : [AppColors.textMuted.withOpacity(0.3), AppColors.textMuted.withOpacity(0.1)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Time + venue
            Row(children: [
              const Icon(Icons.schedule_rounded, color: AppColors.accent, size: 14),
              const SizedBox(width: 5),
              Text(session.time,
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.accent)),
              const SizedBox(width: 14),
              const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(session.venue,
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis)),
            ]),

            const SizedBox(height: 10),

            Text(session.title,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(15),
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),

            const SizedBox(height: 6),

            Text(session.speaker,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                    color: AppColors.secondary, fontWeight: FontWeight.w600)),
            Text(session.designation,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                    color: AppColors.textSecondary)),

            const SizedBox(height: 10),

            Text(session.description,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                    color: AppColors.textSecondary, height: 1.5)),

            const SizedBox(height: 14),

            // Capacity bar
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Capacity',
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: AppColors.textMuted)),
                Text('${session.registeredCount}/${session.maxParticipants}',
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: isFull ? AppColors.error : AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fillPct.clamp(0.0, 1.0),
                  backgroundColor: AppColors.textMuted.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(
                      fillPct >= 1.0 ? AppColors.error : AppColors.accent),
                  minHeight: 6,
                ),
              ),
            ]),

            const SizedBox(height: 14),

            // Register button
            GestureDetector(
              onTap: isFull ? null : () => controller.toggleRegistration(session),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: isFull
                      ? null
                      : (session.isRegistered
                          ? const LinearGradient(colors: [Color(0xFF1E3A5F), Color(0xFF1E3A5F)])
                          : AppColors.primaryGradient),
                  color: isFull ? AppColors.textMuted.withOpacity(0.15) : null,
                  borderRadius: BorderRadius.circular(12),
                  border: session.isRegistered && !isFull
                      ? Border.all(color: AppColors.accent.withOpacity(0.5))
                      : null,
                ),
                child: Center(
                  child: Text(
                    isFull ? 'Session Full' : (session.isRegistered ? 'Cancel Registration' : 'Register Now'),
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                        fontWeight: FontWeight.w600,
                        color: isFull ? AppColors.textMuted : AppColors.background),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}