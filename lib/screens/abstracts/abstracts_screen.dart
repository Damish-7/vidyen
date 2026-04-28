// lib/screens/abstracts/abstracts_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/abstracts_controller.dart';
import '../../models/abstract_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../submit_abstract/submit_abstract_screen.dart';

class AbstractsScreen extends StatelessWidget {
  const AbstractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbstractsController>();
    final r = context.r;

    return Stack(children: [
      Column(children: [

       // ── Summary bar ──────────────────────────────────────────────────
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.primary,
              child: Row(children: [
                _Chip(label: 'Total',    value: controller.totalCount.value,    color: AppColors.textSecondary),
                const SizedBox(width: 10),
                _Chip(label: 'Accepted', value: controller.acceptedCount.value, color: AppColors.success),
                const SizedBox(width: 10),
                _Chip(label: 'Pending',  value: controller.pendingCount.value,  color: AppColors.warning),
                const SizedBox(width: 10),
                _Chip(label: 'Rejected', value: controller.rejectedCount.value, color: AppColors.error),
              ]),
            )),

        // ── Filter chips ────────────────────────────────────────────────
        Obx(() {
          final selected = controller.selectedFilter.value;
          return SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: controller.filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f      = controller.filters[i];
                final active = selected == f;
                return GestureDetector(
                  onTap: () => controller.setFilter(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: active ? AppColors.secondary : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active
                          ? AppColors.secondary
                          : AppColors.textMuted.withOpacity(0.3)),
                    ),
                    child: Text(f,
                        style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? AppColors.background : AppColors.textSecondary)),
                  ),
                );
              },
            ),
          );
        }),

        // ── List ─────────────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            final loading = controller.isLoading.value;
            final error   = controller.error.value;
            final list    = controller.abstracts.toList();

            if (loading) {
              return const Center(child: CircularProgressIndicator(
                  color: AppColors.secondary));
            }
            if (error.isNotEmpty) {
              return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.wifi_off_rounded,
                    color: AppColors.textMuted, size: 48),
                const SizedBox(height: 12),
                Text(error, style: TextStyle(color: AppColors.textMuted,
                    fontSize: r.sp(13), fontFamily: 'Sora'),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: controller.fetchAbstracts,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text('Retry', style: TextStyle(fontFamily: 'Sora',
                        color: AppColors.background, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]));
            }
            if (list.isEmpty) {
              return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.article_outlined,
                    color: AppColors.textMuted, size: 48),
                const SizedBox(height: 12),
                Text('No abstracts found', style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: r.sp(14), fontFamily: 'Sora')),
                const SizedBox(height: 20),
                _SubmitButton(controller: controller, r: r),
              ]));
            }
            return RefreshIndicator(
              onRefresh: controller.fetchAbstracts,
              color: AppColors.secondary,
              backgroundColor: AppColors.surface,
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                    r.isDesktop ? 24 : 16,
                    r.isDesktop ? 24 : 16,
                    r.isDesktop ? 24 : 16,
                    90), // extra bottom for FAB
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _AbstractCard(abstract: list[i], r: r),
              ),
            );
          }),
        ),
      ]),

      // ── FAB — Submit Abstract ─────────────────────────────────────────
      Positioned(
        bottom: 16, right: 16,
        child: GestureDetector(
          onTap: () async {
            final submitted = await Get.to<bool>(
                () => const SubmitAbstractScreen());
            if (submitted == true) {
              controller.fetchAbstracts();
            }
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                  blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.add_rounded, color: AppColors.background, size: 22),
              const SizedBox(width: 8),
              Text('Submit Abstract',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                      fontWeight: FontWeight.w700,
                      color: AppColors.background)),
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Submit button (shown in empty state) ─────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final AbstractsController controller;
  final Responsive r;
  const _SubmitButton({required this.controller, required this.r});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final submitted = await Get.to<bool>(() => const SubmitAbstractScreen());
        if (submitted == true) controller.fetchAbstracts();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.add_rounded, color: AppColors.background, size: 20),
          const SizedBox(width: 8),
          Text('Submit Your First Abstract',
              style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                  fontWeight: FontWeight.w700, color: AppColors.background)),
        ]),
      ),
    );
  }
}

// ── Summary chip ──────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Chip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 5),
        Text('$value $label',
            style: const TextStyle(fontFamily: 'Sora', fontSize: 11,
                color: AppColors.textSecondary)),
      ]);
}

// ── Abstract card ─────────────────────────────────────────────────────────────
class _AbstractCard extends StatelessWidget {
  final AbstractModel abstract;
  final Responsive r;
  const _AbstractCard({required this.abstract, required this.r});

  Color get _statusColor {
    switch (abstract.status) {
      case 'accepted': return AppColors.success;
      case 'rejected': return AppColors.error;
      default:         return AppColors.warning;
    }
  }

  IconData get _statusIcon {
    switch (abstract.status) {
      case 'accepted': return Icons.check_circle_rounded;
      case 'rejected': return Icons.cancel_rounded;
      default:         return Icons.hourglass_empty_rounded;
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 6, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(_statusIcon, color: _statusColor, size: 12),
              const SizedBox(width: 4),
              Text(abstract.status[0].toUpperCase() + abstract.status.substring(1),
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: _statusColor, fontWeight: FontWeight.w600)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
                abstract.presentationType == 'oral' ? '🎤 Oral' : '🖼️ Poster',
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                    color: AppColors.accent)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(abstract.category,
                style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(10),
                    color: AppColors.secondary)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(abstract.title,
            style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(14),
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text(abstract.authors,
            style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                color: AppColors.accent)),
        Text(abstract.institution,
            style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        Text(abstract.abstractText,
            maxLines: 3, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.schedule_rounded, color: AppColors.textMuted, size: 13),
          const SizedBox(width: 4),
          Text('Submitted ${_formatDate(abstract.submittedAt)}',
              style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                  color: AppColors.textMuted)),
        ]),
      ]),
    );
  }
}