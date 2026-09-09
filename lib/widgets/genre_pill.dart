import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GenrePill extends StatelessWidget {
  const GenrePill({super.key, required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlighted ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.48,
        ),
      ),
    );
  }
}
