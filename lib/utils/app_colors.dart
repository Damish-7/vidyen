// // lib/utils/app_colors.dart
// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary palette — deep navy & electric teal
//   static const Color primary = Color(0xFF0A1628);       // Deep Navy
//   static const Color secondary = Color(0xFF00C9B1);     // Electric Teal
//   static const Color accent = Color(0xFF4F8EF7);        // Sky Blue Accent
//   static const Color highlight = Color(0xFFFFD166);     // Warm Amber

//   // Backgrounds
//   static const Color background = Color.fromARGB(255, 232, 234, 238);
//   static const Color surface = Color.fromARGB(255, 141, 168, 212);
//   static const Color cardBg = Color.fromARGB(255, 54, 91, 165);
//   static const Color inputBg = Color.fromARGB(255, 65, 88, 134);

//   // Text
//   static const Color textPrimary = Color(0xFFF0F4FF);
//   static const Color textSecondary = Color(0xFF8FA8C8);
//   static const Color textMuted = Color(0xFF4A6480);

//   // Status
//   static const Color success = Color(0xFF00E096);
//   static const Color error = Color(0xFFFF4D6D);
//   static const Color warning = Color(0xFFFFD166);

//   // Gradients
//   static const LinearGradient splashGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF060E1E), Color(0xFF0A1F3D), Color(0xFF0E2952)],
//   );

//   static const LinearGradient primaryGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF00C9B1), Color(0xFF4F8EF7)],
//   );

//   static const LinearGradient cardGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF132240), Color(0xFF0F1A30)],
//   );
// }

// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary palette
//   static const Color primary = Color(0xFF0A1628);       // Navy Blue
//   static const Color secondary = Color(0xFF00C9B1);     // Teal
//   static const Color accent = Color(0xFF4F8EF7);
//   static const Color highlight = Color(0xFFFFD166);

//   // ✅ Backgrounds (UPDATED)
//   static const Color background = Colors.white;         // ✅ White background
//   static const Color surface = Color(0xFFF5F7FA);       // Light grey surface
//   static const Color cardBg = Color.fromARGB(255, 88, 111, 145);        // ✅ Navy Blue cards
//   static const Color inputBg = Color(0xFFF1F3F6);       // Light input field

//   // ✅ Text (UPDATED for white background)
//   static const Color textPrimary = Color(0xFF0A1628);   // Dark text
//   static const Color textSecondary = Color(0xFF5A6B85);
//   static const Color textMuted = Color(0xFF8A9BB5);

//   // Status
//   static const Color success = Color(0xFF00E096);
//   static const Color error = Color(0xFFFF4D6D);
//   static const Color warning = Color(0xFFFFD166);

//   // Gradients
//   static const LinearGradient splashGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Colors.white, Color(0xFFF5F7FA)], // ✅ Light splash
//   );

//   static const LinearGradient primaryGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF0A1628), Color(0xFF1B2A49)], // ✅ Navy gradient
//   );

//   static const LinearGradient cardGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color.fromARGB(255, 97, 136, 194), Color(0xFF1B2A49)], // ✅ Navy cards
//   );
// }

// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary palette
//   static const Color primary = Color(0xFF0A1628);       // Navy Blue
//   static const Color secondary = Color(0xFF00C9B1);
//   static const Color accent = Color(0xFF4F8EF7);
//   static const Color highlight = Color(0xFFFFD166);

//   // ✅ Backgrounds
//   static const Color background = Color.fromARGB(255, 232, 246, 251);         // Main background
//   static const Color surface = Color.fromARGB(255, 76, 146, 173);       // Light surface
//   static const Color cardBg = Color.fromARGB(255, 3, 14, 24);        // ✅ Slight white variation
//   static const Color inputBg = Color.fromARGB(255, 86, 106, 137);

//   // Text
//   static const Color textPrimary = Color(0xFF0A1628);
//   static const Color textSecondary = Color(0xFF5A6B85);
//   static const Color textMuted = Color(0xFF8A9BB5);

//   // Status
//   static const Color success = Color(0xFF00E096);
//   static const Color error = Color(0xFFFF4D6D);
//   static const Color warning = Color(0xFFFFD166);

//   // Gradients
//   static const LinearGradient splashGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color.fromARGB(255, 40, 81, 138), Color.fromARGB(255, 138, 165, 207)],
//   );

//   static const LinearGradient primaryGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF0A1628), Color(0xFF1B2A49)],
//   );

//   static const LinearGradient cardGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFFF9FBFD), Color(0xFFF1F5F9)], // soft variation
//   );
// }

import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — Navy & Indigo
  static const Color primary = Color(0xFF0F172A);       // Rich Navy
  static const Color secondary = Color(0xFF334155);     // Soft Navy
  static const Color accent = Color(0xFF6366F1);        // Indigo Accent
  static const Color highlight = Color(0xFFF59E0B);     // Warm Amber

  // Backgrounds
  static const Color background = Color(0xFFF9FAFB);    // Soft White
  static const Color surface = Color(0xFFFFFFFF);       // Pure White
  static const Color cardBg = Color(0xFFFFFFFF);        // White Cards
  static const Color inputBg = Color(0xFFF1F5F9);       // Light Input

  // Text
  static const Color textPrimary = Color(0xFF0F172A);   // Dark Text
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF334155),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 26, 30, 95),
      Color.fromARGB(255, 46, 41, 146),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 227, 235, 244),
      Color.fromARGB(255, 222, 234, 246),
    ],
  );
}