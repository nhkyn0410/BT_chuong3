import 'package:flutter/material.dart';

class GenrePill extends StatelessWidget {
  const GenrePill({
    super.key,
    required this.label,
    this.highlighted = false,
    this.onTap,
  });

  final String label;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: highlighted
          ? colors.primary.withValues(alpha: 0.15)
          : colors.surfaceContainer,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: highlighted ? colors.primary : colors.onSurfaceVariant,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.48,
            ),
          ),
        ),
      ),
    );
  }
}
