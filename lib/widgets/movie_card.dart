import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../state/watchlist_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'hero_placeholder.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
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
                  child: _Poster(movie: movie),
                ),
                Expanded(child: _Metadata(movie: movie)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surfaceContainer;
    final saved = WatchlistScope.of(context).contains(movie);

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: movie.heroTag,
          placeholderBuilder: keepHeroVisible,
          child: ColoredBox(
            color: AppColors.surfaceMuted,
            child: Image.asset(movie.posterAsset, fit: BoxFit.cover),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                cardColor.withValues(alpha: 0.2),
                cardColor,
              ],
              stops: const [0, 0.55, 1],
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
                style: AppTextStyles.overline.copyWith(
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 0.48,
                  color: AppColors.textWarm,
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
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (saved)
          const Positioned(
            right: 8,
            bottom: 8,
            child: _GlassBadge(
              children: [
                Icon(
                  Icons.bookmark_added_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4),
                Text(
                  'ĐÃ LƯU',
                  style: TextStyle(
                    color: AppColors.textWarm,
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Nhãn nền tối nằm trên ảnh poster, giữ nguyên màu ở cả chế độ Sáng/Tối.
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
  const _Metadata({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface,
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
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              height: 16 / 12,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.touch_app_outlined, size: 11, color: colors.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  movie.homeHint.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.overline.copyWith(
                    color: colors.primary,
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
