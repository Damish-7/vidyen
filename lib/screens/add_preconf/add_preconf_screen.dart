// lib/screens/add_preconf/add_preconf_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/add_preconf_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/vidyen_text_field.dart';

class AddPreConfScreen extends StatelessWidget {
  const AddPreConfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPreConfController());
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E3A5F)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 16),
          ),
        ),
        title: const Text('Add Pre-Conf Session',
            style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                AppColors.accent.withOpacity(0.4),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: r.screenPadding, vertical: 24),
          child: SizedBox(
            width: r.cardWidth,
            child: Column(children: [

              // Info banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.accent.withOpacity(0.25)),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Fill in the details below to add a new pre-conference session. '
                      'It will be visible to all participants immediately.',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(12),
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 24),

              // Form card
              Container(
                padding: EdgeInsets.all(r.cardPadding),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1E3A5F)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                  // ── Session Details ───────────────────────────────────
                  _SectionLabel('Session Details', AppColors.accent, r),
                  const SizedBox(height: 16),

                  VidyenTextField(
                    controller: controller.titleController,
                    label: 'Session Title *',
                    hint: 'e.g. Research Methodology Masterclass',
                    prefixIcon: Icons.event_note_rounded,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 14),

                  VidyenTextField(
                    controller: controller.venueController,
                    label: 'Venue *',
                    hint: 'e.g. Conference Hall A, Ground Floor',
                    prefixIcon: Icons.location_on_outlined,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 14),

                  // Max participants
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Max Participants *', r),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.maxParticipantsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 14,
                            color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '50',
                          hintStyle: const TextStyle(
                              color: AppColors.textMuted, fontSize: 14),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 16, right: 12),
                            child: Icon(Icons.people_outline_rounded,
                                color: AppColors.textMuted, size: 20),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          filled: true,
                          fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFF1E3A5F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFF1E3A5F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.accent, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                        ),
                        onChanged: (_) => controller.error.value = '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Speaker Info ──────────────────────────────────────
                  _SectionLabel('Speaker Information', AppColors.secondary, r),
                  const SizedBox(height: 16),

                  VidyenTextField(
                    controller: controller.speakerController,
                    label: 'Speaker Name *',
                    hint: 'e.g. Prof. Anitha Krishnamurthy',
                    prefixIcon: Icons.person_outline_rounded,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 14),

                  VidyenTextField(
                    controller: controller.designationController,
                    label: 'Designation / Affiliation',
                    hint: 'e.g. Head of Biostatistics, AIIMS Delhi',
                    prefixIcon: Icons.work_outline_rounded,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 24),

                  // ── Date & Time ───────────────────────────────────────
                  _SectionLabel('Date & Time', AppColors.highlight, r),
                  const SizedBox(height: 16),

                  // Date picker
                  _FieldLabel('Session Date *', r),
                  const SizedBox(height: 8),
                  Obx(() => GestureDetector(
                        onTap: () => controller.pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFF1E3A5F)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: AppColors.textMuted, size: 20),
                            const SizedBox(width: 12),
                            Text(controller.formattedDate,
                                style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: r.sp(14),
                                    color: AppColors.textPrimary)),
                            const Spacer(),
                            const Icon(Icons.chevron_right_rounded,
                                color: AppColors.textMuted, size: 20),
                          ]),
                        ),
                      )),
                  const SizedBox(height: 14),

                  // Time range pickers
                  Row(children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _FieldLabel('Start Time *', r),
                        const SizedBox(height: 8),
                        Obx(() => _TimeDropdown(
                              value: controller.selectedTimeStart.value,
                              options: controller.timeOptions,
                              accentColor: AppColors.highlight,
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedTimeStart.value = v;
                                }
                              },
                            )),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _FieldLabel('End Time *', r),
                        const SizedBox(height: 8),
                        Obx(() => _TimeDropdown(
                              value: controller.selectedTimeEnd.value,
                              options: controller.timeOptions,
                              accentColor: AppColors.highlight,
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedTimeEnd.value = v;
                                }
                              },
                            )),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Description ───────────────────────────────────────
                  _SectionLabel('Description', AppColors.textSecondary, r),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFF1E3A5F)),
                    ),
                    child: TextField(
                      controller: controller.descriptionController,
                      maxLines: 5,
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(13),
                          color: AppColors.textPrimary,
                          height: 1.6),
                      decoration: const InputDecoration(
                        hintText:
                            'Describe the session content, goals, '
                            'and who should attend...',
                        hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontFamily: 'Sora',
                            fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      onChanged: (_) => controller.error.value = '',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error banner
                  Obx(() {
                    if (controller.error.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.error_outline_rounded,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(controller.error.value,
                              style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: r.sp(12),
                                  fontFamily: 'Sora')),
                        ),
                      ]),
                    );
                  }),

                  // Submit
                  Obx(() => GradientButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submit,
                        isLoading: controller.isLoading.value,
                        label: 'Create Session',
                        icon: Icons.add_circle_outline_rounded,
                      )),
                ]),
              ),

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  final Responsive r;
  const _SectionLabel(this.label, this.color, this.r);

  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          fontFamily: 'Sora',
          fontSize: r.sp(12),
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1.5));
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Responsive r;
  const _FieldLabel(this.text, this.r);

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontFamily: 'Sora',
          fontSize: r.sp(12),
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.3));
}

class _TimeDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final Color accentColor;
  final void Function(String?) onChanged;
  const _TimeDropdown({
    required this.value,
    required this.options,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3A5F)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(value) ? value : options.first,
          dropdownColor: AppColors.surface,
          icon: const Icon(Icons.expand_more_rounded,
              color: AppColors.textMuted, size: 18),
          style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 13,
              color: AppColors.textPrimary),
          isExpanded: true,
          items: options
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}