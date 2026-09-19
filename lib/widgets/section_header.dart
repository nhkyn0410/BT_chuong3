import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading.copyWith(
              fontSize: 16,
              height: 22 / 16,
              letterSpacing: 0.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Nhãn nhỏ dạng viên thuốc, ví dụ "6 PHIM".
class CountPill extends StatelessWidget {
  const CountPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
