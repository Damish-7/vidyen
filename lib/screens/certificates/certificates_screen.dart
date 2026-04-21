// lib/screens/certificates/certificates_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/certificates_controller.dart';
import '../../models/certificate_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CertificatesController>();
    final r = context.r;

    return Column(children: [
      Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: AppColors.primary,
            child: Row(children: [
              const Icon(Icons.workspace_premium_outlined,
                  color: Color(0xFFBB86FC), size: 18),
              const SizedBox(width: 8),
              Text('My Certificates',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
                      color: AppColors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFBB86FC).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                    '${controller.downloadedCount}/${controller.totalCount} Downloaded',
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: const Color(0xFFBB86FC),
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          )),

      Expanded(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(
                color: AppColors.secondary));
          }
          if (controller.error.value.isNotEmpty) {
            return _ErrorView(message: controller.error.value,
                onRetry: controller.fetchCertificates, r: r);
          }
          if (controller.certificates.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.workspace_premium_outlined,
                  color: AppColors.textMuted, size: 60),
              const SizedBox(height: 16),
              Text('No certificates yet',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('Certificates will appear\nafter the conference concludes.',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(13),
                      color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ]));
          }
          return RefreshIndicator(
            onRefresh: controller.fetchCertificates,
            color: AppColors.secondary,
            backgroundColor: AppColors.surface,
            child: ListView.separated(
              padding: EdgeInsets.all(r.isDesktop ? 24 : 16),
              itemCount: controller.certificates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _CertCard(
                  cert: controller.certificates[i],
                  controller: controller, r: r),
            ),
          );
        }),
      ),
    ]);
  }
}

class _CertCard extends StatelessWidget {
  final CertificateModel cert;
  final CertificatesController controller;
  final Responsive r;
  const _CertCard({required this.cert, required this.controller, required this.r});

  Color get _typeColor {
    switch (cert.type) {
      case 'participation': return const Color(0xFFBB86FC);
      case 'presenter':     return AppColors.secondary;
      case 'workshop':      return AppColors.highlight;
      case 'preconf':       return AppColors.accent;
      default:              return AppColors.textSecondary;
    }
  }

  IconData get _typeIcon {
    switch (cert.type) {
      case 'participation': return Icons.groups_outlined;
      case 'presenter':     return Icons.mic_outlined;
      case 'workshop':      return Icons.handshake_outlined;
      case 'preconf':       return Icons.event_outlined;
      default:              return Icons.workspace_premium_outlined;
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _typeColor.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: _typeColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(cert.title,
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Text(cert.eventName,
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: AppColors.textSecondary),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              if (cert.isDownloaded)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 12),
                    const SizedBox(width: 4),
                    Text('Saved',
                        style: TextStyle(fontFamily: 'Sora',
                            fontSize: r.sp(10), color: AppColors.success)),
                  ]),
                ),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _typeColor.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.qr_code_rounded,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(cert.certificateCode,
                    style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                        color: AppColors.textSecondary, letterSpacing: 0.5)),
              ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppColors.textMuted, size: 13),
              const SizedBox(width: 5),
              Text('Issued ${_formatDate(cert.issuedAt)}',
                  style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(11),
                      color: AppColors.textMuted)),
            ]),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: cert.isDownloaded
                  ? null
                  : () => controller.markDownloaded(cert),
              child: Container(
                width: double.infinity, height: 44,
                decoration: BoxDecoration(
                  gradient: cert.isDownloaded
                      ? null
                      : LinearGradient(colors: [
                          _typeColor,
                          _typeColor.withOpacity(0.7)
                        ]),
                  color: cert.isDownloaded
                      ? AppColors.textMuted.withOpacity(0.1)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(
                      cert.isDownloaded
                          ? Icons.check_rounded
                          : Icons.download_rounded,
                      color: cert.isDownloaded
                          ? AppColors.textMuted
                          : AppColors.background,
                      size: 18),
                  const SizedBox(width: 8),
                  Text(cert.isDownloaded
                          ? 'Already Downloaded'
                          : 'Download Certificate',
                      style: TextStyle(fontFamily: 'Sora',
                          fontSize: r.sp(13), fontWeight: FontWeight.w600,
                          color: cert.isDownloaded
                              ? AppColors.textMuted
                              : AppColors.background)),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Responsive r;
  const _ErrorView({required this.message, required this.onRetry, required this.r});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded, color: AppColors.textMuted, size: 48),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: AppColors.textMuted,
              fontSize: r.sp(13), fontFamily: 'Sora'),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('Retry', style: TextStyle(fontFamily: 'Sora',
                  color: AppColors.background, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      );
}