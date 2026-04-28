// lib/screens/preconf/preconf_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/preconf_controller.dart';
import '../../models/preconf_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../add_preconf/add_preconf_screen.dart';

class PreConfScreen extends StatelessWidget {
  const PreConfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreConfController>();
    final r = context.r;

    return Stack(children: [

      Column(children: [
        // ── Header bar ─────────────────────────────────────────────────
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.primary,
              child: Row(children: [
                const Icon(Icons.event_outlined,
                    color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text('Pre-Conference Sessions',
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: r.sp(12),
                        color: AppColors.textSecondary)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                      '${controller.registeredCount} Registered',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(11),
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
            )),

        // ── Content ────────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            final loading  = controller.isLoading.value;
            final error    = controller.error.value;
            final sessions = controller.sessions.toList();

            if (loading) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.secondary));
            }

            if (error.isNotEmpty) {
              return _ErrorView(
                  message: error,
                  onRetry: controller.fetchSessions,
                  r: r);
            }

            if (sessions.isEmpty) {
              return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  const Icon(Icons.event_outlined,
                      color: AppColors.textMuted, size: 52),
                  const SizedBox(height: 14),
                  Text('No sessions yet',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(16),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Tap + to add the first session.',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(13),
                          color: AppColors.textSecondary)),
                ]),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.fetchSessions,
              color: AppColors.secondary,
              backgroundColor: AppColors.surface,
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                    r.isDesktop ? 24 : 16,
                    r.isDesktop ? 24 : 16,
                    r.isDesktop ? 24 : 16,
                    90),
                itemCount: sessions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _SessionCard(
                    session: sessions[i],
                    controller: controller,
                    r: r),
              ),
            );
          }),
        ),
      ]),

      // ── FAB — Add Session ─────────────────────────────────────────────
      Positioned(
        bottom: 16,
        right: 16,
        child: GestureDetector(
          onTap: () async {
            final created =
                await Get.to<bool>(() => const AddPreConfScreen());
            if (created == true) controller.fetchSessions();
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 94, 210, 245), Color.fromARGB(255, 13, 28, 58)],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                    color: AppColors.accent.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6))
              ],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.add_rounded,
                  color: AppColors.background, size: 22),
              const SizedBox(width: 8),
              Text('Add Session',
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(13),
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 255, 255, 255))),
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Session card ──────────────────────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final PreConfModel session;
  final PreConfController controller;
  final Responsive r;
  const _SessionCard(
      {required this.session,
      required this.controller,
      required this.r});

  @override
  Widget build(BuildContext context) {
    final isFull  = session.isFull;
    final fillPct = session.maxParticipants > 0
        ? (session.registeredCount / session.maxParticipants)
            .clamp(0.0, 1.0)
        : 0.0;

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
        // Top color strip
        Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: session.isRegistered
                    ? [AppColors.accent, AppColors.secondary]
                    : [
                        AppColors.textMuted.withOpacity(0.3),
                        AppColors.textMuted.withOpacity(0.1)
                      ]),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Time + venue
            Row(children: [
              const Icon(Icons.schedule_rounded,
                  color: AppColors.accent, size: 14),
              const SizedBox(width: 5),
              Flexible(
                child: Text(session.sessionTime,
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: r.sp(11),
                        color: AppColors.accent)),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_outlined,
                  color: AppColors.textMuted, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(session.venue,
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: r.sp(11),
                        color: AppColors.textMuted),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
            const SizedBox(height: 10),

            // Title
            Text(session.title,
                style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: r.sp(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),

            // Speaker
            Text(session.speaker,
                style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: r.sp(13),
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600)),
            if (session.designation.isNotEmpty)
              Text(session.designation,
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(11),
                      color: AppColors.textSecondary)),

            // Description
            if (session.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(session.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(12),
                      color: AppColors.textSecondary,
                      height: 1.5)),
            ],

            const SizedBox(height: 14),

            // Capacity bar
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text('Capacity',
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(11),
                      color: AppColors.textMuted)),
              Text(
                  '${session.registeredCount}/${session.maxParticipants}',
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(11),
                      color: isFull
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fillPct,
                backgroundColor: AppColors.textMuted.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(
                    fillPct >= 1.0
                        ? AppColors.error
                        : AppColors.accent),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),

            // Register button
            GestureDetector(
              onTap: isFull
                  ? null
                  : () => controller.toggleRegistration(session),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: isFull
                      ? null
                      : (session.isRegistered
                          ? const LinearGradient(colors: [
                              Color(0xFF1E3A5F),
                              Color(0xFF1E3A5F)
                            ])
                          : AppColors.primaryGradient),
                  color: isFull
                      ? AppColors.textMuted.withOpacity(0.15)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: session.isRegistered && !isFull
                      ? Border.all(
                          color: AppColors.accent.withOpacity(0.5))
                      : null,
                ),
                child: Center(
                  child: Text(
                    isFull
                        ? 'Session Full'
                        : session.isRegistered
                            ? 'Cancel Registration'
                            : 'Register Now',
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: r.sp(13),
                        fontWeight: FontWeight.w600,
                        color: isFull
                            ? AppColors.textMuted
                            : AppColors.background),
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

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Responsive r;
  const _ErrorView(
      {required this.message, required this.onRetry, required this.r});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppColors.textMuted, size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: r.sp(13),
                  fontFamily: 'Sora'),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('Retry',
                  style: TextStyle(
                      fontFamily: 'Sora',
                      color: AppColors.background,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      );
}