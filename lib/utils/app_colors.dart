// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — deep navy & electric teal
  static const Color primary = Color(0xFF0A1628);       // Deep Navy
  static const Color secondary = Color(0xFF00C9B1);     // Electric Teal
  static const Color accent = Color(0xFF4F8EF7);        // Sky Blue Accent
  static const Color highlight = Color(0xFFFFD166);     // Warm Amber

  // Backgrounds
  static const Color background = Color(0xFF060E1E);
  static const Color surface = Color(0xFF0F1F38);
  static const Color cardBg = Color(0xFF132240);
  static const Color inputBg = Color(0xFF0D1A30);

  // Text
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8FA8C8);
  static const Color textMuted = Color(0xFF4A6480);

  // Status
  static const Color success = Color(0xFF00E096);
  static const Color error = Color(0xFFFF4D6D);
  static const Color warning = Color(0xFFFFD166);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF060E1E), Color(0xFF0A1F3D), Color(0xFF0E2952)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C9B1), Color(0xFF4F8EF7)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF132240), Color(0xFF0F1A30)],
  );
}