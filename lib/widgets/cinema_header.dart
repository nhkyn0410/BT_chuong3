import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CinemaHeader extends StatelessWidget {
  const CinemaHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: AppColors.background.withValues(alpha: 0.94),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _HeaderCircle(
                  size: showBackButton ? 44 : 40,
                  icon: showBackButton
                      ? Icons.arrow_back_rounded
                      : Icons.movie_filter_outlined,
                  iconColor: showBackButton
                      ? AppColors.textPrimary
                      : AppColors.primary,
                  onTap: showBackButton ? onBack : null,
                  tooltip: showBackButton ? 'Back' : null,
                ),
                SizedBox(width: showBackButton ? 12 : 8),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 26,
                      height: 28 / 26,
                      letterSpacing: showBackButton ? 0.65 : 1.3,
                      color: showBackButton
                          ? AppColors.textPrimary
                          : AppColors.textWarm,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _HeaderCircle(
                  size: 44,
                  icon: showBackButton
                      ? Icons.bookmark_border_rounded
                      : Icons.search_rounded,
                  iconColor: AppColors.textSecondary,
                  onTap: () {},
                  tooltip: showBackButton ? 'Bookmark' : 'Search',
                ),
                const SizedBox(width: 8),
                const _HeaderCircle(
                  size: 32,
                  icon: Icons.person_outline_rounded,
                  backgroundColor: AppColors.textWarm,
                  iconColor: AppColors.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  const _HeaderCircle({
    required this.size,
    required this.icon,
    required this.iconColor,
    this.backgroundColor = AppColors.surface,
    this.onTap,
    this.tooltip,
  });

  final double size;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final circle = Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: size,
          child: Icon(icon, size: size * 0.42, color: iconColor),
        ),
      ),
    );

    return tooltip == null ? circle : Tooltip(message: tooltip!, child: circle);
  }
}
