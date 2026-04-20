// lib/screens/abstracts/abstracts_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/abstracts_controller.dart';
import '../../models/hive_models/abstract_hive_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class AbstractsScreen extends StatelessWidget {
  const AbstractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbstractsController>();
    final r = context.r;

    return Column(
      children: [
        // ── Summary bar — reads observables via controller getters ────────────
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.primary,
              child: Row(children: [
                _SummaryChip(label: 'Total',    value: '${controller.totalCount}',    color: AppColors.textSecondary),
                const SizedBox(width: 10),
                _SummaryChip(label: 'Accepted', value: '${controller.acceptedCount}', color: AppColors.success),
                const SizedBox(width: 10),
                _SummaryChip(label: 'Pending',  value: '${controller.pendingCount}',  color: AppColors.warning),
                const SizedBox(width: 10),
                _SummaryChip(label: 'Rejected', value: '${controller.rejectedCount}', color: AppColors.error),
              ]),
            )),

        // ── Filter chips ──────────────────────────────────────────────────────
        Obx(() => SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: controller.filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final f = controller.filters[i];
                  final isActive = controller.selectedFilter.value == f;
                  return GestureDetector(
                    onTap: () => controller.setFilter(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.secondary : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isActive
                                ? AppColors.secondary
                                : AppColors.textMuted.withOpacity(0.3)),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: r.sp(12),
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive ? AppColors.background : AppColors.textSecondary)),
                    ),
                  );
                },
              ),
            )),

        // ── List — single Obx reads filtered list ─────────────────────────────
        Expanded(
          child: Obx(() {
            final list = controller.filtered;
            if (list.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.article_outlined, color: AppColors.textMuted, size: 48),
                  const SizedBox(height: 12),
                  Text('No abstracts found',
                      style: TextStyle(color: AppColors.textMuted,
                          fontSize: r.sp(14), fontFamily: 'Sora')),
                ]),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(r.isDesktop ? 24 : 16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _AbstractCard(abstract: list[i], r: r),
            );
          }),
        ),
      ],
    );
  }
}

// ── Summary chip ─────────────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      const SizedBox(width: 5),
      Text('$value $label',
          style: const TextStyle(fontFamily: 'Sora', fontSize: 11,
              color: AppColors.textSecondary)),
    ]);
  }
}

// ── Abstract card — no Obx needed, pure display ───────────────────────────────
class _AbstractCard extends StatelessWidget {
  final AbstractHiveModel abstract;
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
        // Status + type + category row
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
            child: Text(abstract.presentationType == 'oral' ? '🎤 Oral' : '🖼️ Poster',
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
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
}