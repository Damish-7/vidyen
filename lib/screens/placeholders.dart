// lib/screens/abstracts/abstracts_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AbstractsScreen extends StatelessWidget {
  const AbstractsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Abstracts', icon: Icons.article_outlined, color: AppColors.secondary);
}

// lib/screens/preconf/preconf_screen.dart
class PreConfScreen extends StatelessWidget {
  const PreConfScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Pre-Conference', icon: Icons.event_outlined, color: AppColors.accent);
}

// lib/screens/workshop/workshop_screen.dart
class WorkshopScreen extends StatelessWidget {
  const WorkshopScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Workshop', icon: Icons.handshake_outlined, color: AppColors.highlight);
}

// lib/screens/certificates/certificates_screen.dart
class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Certificates', icon: Icons.workspace_premium_outlined, color: Color(0xFFBB86FC));
}

// ── Shared placeholder widget ─────────────────────────────────────────────────
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _PlaceholderScreen({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Content coming soon',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Sora',
            ),
          ),
        ],
      ),
    );
  }
}
