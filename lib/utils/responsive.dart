// lib/utils/responsive.dart
import 'package:flutter/material.dart';

/// Screen size breakpoints
/// Mobile  : width < 600
/// Tablet  : 600 <= width < 900
/// Desktop : width >= 900

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 900;
  bool get isDesktop => width >= 900;

  // ── Fixed login/register card width ──────────────────────────────────────
  // Mobile  : full width minus horizontal padding
  // Tablet  : fixed 460px centered
  // Desktop : fixed 480px centered
  double get cardWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 460;
    return 480;
  }

  // ── Horizontal screen padding ─────────────────────────────────────────────
  double get screenPadding {
    if (isMobile) return 24;
    if (isTablet) return 60;
    return 80;
  }

  // ── Font scaling (relative to 360dp baseline mobile) ─────────────────────
  double sp(double size) {
    final base = 360.0;
    final scale = (width / base).clamp(0.85, 1.3);
    return size * scale;
  }

  // ── Adaptive sizing ───────────────────────────────────────────────────────
  double get logoSize {
    if (isMobile) return 72;
    if (isTablet) return 80;
    return 88;
  }

  double get appNameSize {
    if (isMobile) return 30;
    if (isTablet) return 34;
    return 38;
  }

  double get cardPadding {
    if (isMobile) return 24;
    return 32;
  }

  double get topSpacing {
    if (isMobile) return height * 0.06;
    if (isTablet) return height * 0.08;
    return height * 0.1;
  }
}

/// Convenience extension so you can do: context.responsive.isMobile
extension ResponsiveExt on BuildContext {
  Responsive get r => Responsive(this);
}