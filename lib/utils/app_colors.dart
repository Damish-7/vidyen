// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary     = Color(0xFF0A1628);
  static const Color secondary   = Color(0xFF00C9B1);
  static const Color accent      = Color(0xFF4F8EF7);
  static const Color highlight   = Color(0xFFFFD166);
  static const Color background  = Color(0xFF060E1E);
  static const Color surface     = Color(0xFF0F1F38);
  static const Color cardBg      = Color(0xFF132240);
  static const Color inputBg     = Color(0xFF0D1A30);
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8FA8C8);
  static const Color textMuted   = Color(0xFF4A6480);
  static const Color success     = Color(0xFF00E096);
  static const Color error       = Color(0xFFFF4D6D);
  static const Color warning     = Color(0xFFFFD166);

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