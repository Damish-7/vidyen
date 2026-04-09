// lib/screens/abstracts/abstracts_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AbstractsScreen extends StatelessWidget {
  const AbstractsScreen({super.key});

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
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.article_outlined,
                color: AppColors.secondary, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Abstracts',
            style: TextStyle(
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