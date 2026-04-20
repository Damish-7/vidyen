// lib/screens/workshop/workshop_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/workshop_controller.dart';
import '../../models/hive_models/workshop_hive_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class WorkshopScreen extends StatelessWidget {
  const WorkshopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkshopController>();
    final r = context.r;

    return Obx(() {
      final workshops = controller.workshops;
      return Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: AppColors.primary,
          child: Row(children: [
            const Icon(Icons.handshake_outlined, color: AppColors.highlight, size: 18),
            const SizedBox(width: 8),
            Text('Workshops — 15 March 2025',
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                    color: AppColors.textSecondary)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.highlight.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${controller.registeredCount} Booked',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.highlight, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(r.isDesktop ? 24 : 16),
            itemCount: workshops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, i) => _WorkshopCard(
                workshop: workshops[i], controller: controller, r: r),
          ),
        ),
      ]);
    });
  }
}

class _WorkshopCard extends StatelessWidget {
  final WorkshopHiveModel workshop;
  final WorkshopController controller;
  final Responsive r;
  const _WorkshopCard({required this.workshop, required this.controller, required this.r});

  @override
  Widget build(BuildContext context) {
    final isFull = workshop.isFull && !workshop.isRegistered;
    final fillPct = workshop.registeredCount / workshop.maxParticipants;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: workshop.isRegistered
                ? AppColors.highlight.withOpacity(0.4)
                : AppColors.textMuted.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Amber top strip
        Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: workshop.isRegistered
                    ? [AppColors.highlight, const Color(0xFFFFB830)]
                    : [AppColors.textMuted.withOpacity(0.3), AppColors.textMuted.withOpacity(0.1)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Meta row
            Row(children: [
              const Icon(Icons.schedule_rounded, color: AppColors.highlight, size: 14),
              const SizedBox(width: 5),
              Text('${workshop.time} · ${workshop.duration}',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.highlight)),
              const SizedBox(width: 14),
              const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(workshop.venue,
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis)),
            ]),

            const SizedBox(height: 10),

            Text(workshop.title,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(15),
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),

            const SizedBox(height: 6),

            Text(workshop.facilitator,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                    color: AppColors.highlight, fontWeight: FontWeight.w600)),
            Text(workshop.designation,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                    color: AppColors.textSecondary)),

            const SizedBox(height: 10),

            Text(workshop.description,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                    color: AppColors.textSecondary, height: 1.5)),

            const SizedBox(height: 12),

            // Topics
            Wrap(spacing: 6, runSpacing: 6,
                children: workshop.topics.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.highlight.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.highlight.withOpacity(0.2)),
                  ),
                  child: Text(t, style: TextStyle(fontFamily: 'Sora',
                      fontSize: r.sp(10), color: AppColors.highlight)),
                )).toList()),

            const SizedBox(height: 14),

            // Capacity bar
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Seats',
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: AppColors.textMuted)),
                Text('${workshop.registeredCount}/${workshop.maxParticipants}',
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
                      fillPct >= 1.0 ? AppColors.error : AppColors.highlight),
                  minHeight: 6,
                ),
              ),
            ]),

            const SizedBox(height: 14),

            GestureDetector(
              onTap: isFull ? null : () => controller.toggleRegistration(workshop),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: isFull
                      ? null
                      : (workshop.isRegistered
                          ? const LinearGradient(colors: [Color(0xFF1E3A5F), Color(0xFF1E3A5F)])
                          : const LinearGradient(colors: [AppColors.highlight, Color(0xFFFFB830)])),
                  color: isFull ? AppColors.textMuted.withOpacity(0.15) : null,
                  borderRadius: BorderRadius.circular(12),
                  border: workshop.isRegistered && !isFull
                      ? Border.all(color: AppColors.highlight.withOpacity(0.5))
                      : null,
                ),
                child: Center(
                  child: Text(
                    isFull ? 'Workshop Full' : (workshop.isRegistered ? 'Cancel Registration' : 'Book My Seat'),
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                        fontWeight: FontWeight.w600,
                        color: isFull
                            ? AppColors.textMuted
                            : (workshop.isRegistered ? AppColors.highlight : AppColors.background)),
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