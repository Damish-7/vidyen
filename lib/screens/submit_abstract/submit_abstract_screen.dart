// lib/screens/submit_abstract/submit_abstract_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/submit_abstract_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/vidyen_text_field.dart';

class SubmitAbstractScreen extends StatelessWidget {
  const SubmitAbstractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put so controller is created fresh each time screen opens
    final controller = Get.put(SubmitAbstractController());
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
        title: const Text('Submit Abstract',
            style: TextStyle(fontFamily: 'Sora', fontSize: 18,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                AppColors.secondary.withOpacity(0.3),
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
                  color: AppColors.secondary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.secondary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your abstract will be reviewed by the committee. '
                      'You can track its status in the Abstracts tab. '
                      'Min. 100 characters required.',
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

                  // ── Section: Abstract Details ──────────────────────────
                  _Label(label: 'Abstract Details',
                      color: AppColors.secondary, r: r),
                  const SizedBox(height: 16),

                  VidyenTextField(
                    controller: controller.titleController,
                    label: 'Title *',
                    hint: 'Full title of your research',
                    prefixIcon: Icons.title_rounded,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 14),

                  VidyenTextField(
                    controller: controller.authorsController,
                    label: 'Authors *',
                    hint: 'e.g. Smith J., Jones A., Kumar R.',
                    prefixIcon: Icons.people_outline_rounded,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 14),

                  VidyenTextField(
                    controller: controller.institutionController,
                    label: 'Institution / Organisation *',
                    hint: 'Your affiliated institution',
                    prefixIcon: Icons.account_balance_outlined,
                    onChanged: (_) => controller.error.value = '',
                  ),
                  const SizedBox(height: 24),

                  // ── Section: Classification ───────────────────────────
                  _Label(label: 'Classification',
                      color: AppColors.accent, r: r),
                  const SizedBox(height: 16),

                  // Category dropdown — Obx only reads selectedCategory
                  _FieldLabel(text: 'Category *', r: r),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF1E3A5F)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: controller.selectedCategory.value,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 14,
                              color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          items: controller.categories
                              .map((c) => DropdownMenuItem(
                                  value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              controller.selectedCategory.value = v;
                            }
                          },
                        ),
                      )),
                  const SizedBox(height: 14),

                  // Presentation type toggle
                  _FieldLabel(text: 'Presentation Type *', r: r),
                  const SizedBox(height: 10),
                  Obx(() => Row(children: [
                        _TypeBtn(
                          label: '🎤  Oral',
                          selected: controller.selectedPresentationType.value == 'oral',
                          onTap: () => controller.selectedPresentationType.value = 'oral',
                          r: r,
                        ),
                        const SizedBox(width: 10),
                        _TypeBtn(
                          label: '🖼️  Poster',
                          selected: controller.selectedPresentationType.value == 'poster',
                          onTap: () => controller.selectedPresentationType.value = 'poster',
                          r: r,
                        ),
                      ])),
                  const SizedBox(height: 24),

                  // ── Section: Abstract Text ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Label(label: 'Abstract Text',
                          color: AppColors.highlight, r: r),
                      // Char count — reads only charCount observable
                      Obx(() {
                        final n     = controller.charCount.value;
                        final ok    = n >= 100;
                        return Text('$n chars (min 100)',
                            style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: r.sp(11),
                                fontWeight: FontWeight.w600,
                                color: ok
                                    ? AppColors.success
                                    : AppColors.error));
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Plain TextField — no Obx needed, just a normal text field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1E3A5F)),
                    ),
                    child: TextField(
                      controller: controller.abstractTextController,
                      maxLines: 9,
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: r.sp(13),
                          color: AppColors.textPrimary,
                          height: 1.6),
                      decoration: const InputDecoration(
                        hintText:
                            'Write your abstract here...\n\n'
                            'Include: Background, Methods, Results, Conclusion.',
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

                  // Error banner — reads only error observable
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

                  // Submit button
                  Obx(() => GradientButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submit,
                        isLoading: controller.isLoading.value,
                        label: 'Submit Abstract',
                        icon: Icons.send_rounded,
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

// ── Small helpers ─────────────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String label;
  final Color color;
  final Responsive r;
  const _Label({required this.label, required this.color, required this.r});

  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
          fontWeight: FontWeight.w600, color: color, letterSpacing: 1.5));
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Responsive r;
  const _FieldLabel({required this.text, required this.r});

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(12),
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary, letterSpacing: 0.3));
}

class _TypeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Responsive r;
  const _TypeBtn({required this.label, required this.selected,
      required this.onTap, required this.r});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.primaryGradient : null,
              color: selected ? null : AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: selected
                      ? AppColors.secondary
                      : const Color(0xFF1E3A5F)),
            ),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: r.sp(13),
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selected
                          ? AppColors.background
                          : AppColors.textSecondary)),
            ),
          ),
        ),
      );
}