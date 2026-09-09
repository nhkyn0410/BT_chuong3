import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.showExploreBadge = false,
  });

  final Movie movie;
  final VoidCallback? onTap;
  final bool showExploreBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final posterHeight = constraints.maxHeight * 0.74;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: posterHeight,
                  child: _Poster(
                    movie: movie,
                    showExploreBadge: showExploreBadge,
                  ),
                ),
                Expanded(
                  child: _Metadata(movie: movie, enabled: onTap != null),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.movie, required this.showExploreBadge});

  final Movie movie;
  final bool showExploreBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: AppColors.surfaceMuted,
          child: Image.asset(movie.posterAsset, fit: BoxFit.cover),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0x331E1F25),
                AppColors.surface,
              ],
              stops: [0, 0.55, 1],
            ),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: _GlassBadge(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 3),
              Text(
                movie.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textWarm,
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.48,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: _GlassBadge(
            children: [
              Text(
                '${movie.year}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        if (showExploreBadge)
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'EXPLORE',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 11,
                    color: AppColors.onPrimary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.deepest.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.movie, required this.enabled});

  final Movie movie;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 22 / 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            movie.genreLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 16 / 12,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                enabled
                    ? Icons.touch_app_outlined
                    : Icons.local_movies_outlined,
                size: 11,
                color: enabled
                    ? AppColors.primaryStrong
                    : AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  movie.homeHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: enabled
                        ? AppColors.primaryStrong
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
