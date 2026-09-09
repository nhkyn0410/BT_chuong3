import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/cast_member_card.dart';
import '../widgets/cinema_header.dart';
import '../widgets/genre_pill.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  void _openSuccess(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.success, arguments: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CinemaHeader(
              title: 'Film Details',
              showBackButton: true,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _Hero(movie: movie),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  16,
                                  20,
                                  164,
                                ),
                                child: _MovieInformation(movie: movie),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 390),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _WatchlistAction(
                            onPressed: () => _openSuccess(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth * 320 / 390).clamp(280.0, 360.0);
        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: AppColors.deepest,
                child: Image.asset(movie.heroAsset, fit: BoxFit.cover),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x99111318),
                      AppColors.background,
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xCC111318),
                      Colors.transparent,
                      Color(0x66111318),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _RatingBadge(rating: movie.rating),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withValues(alpha: 0.84),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'TRAILER',
                            style: TextStyle(
                              color: AppColors.textWarm,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepest.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 18 / 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.28,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '/ 10',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieInformation extends StatelessWidget {
  const _MovieInformation({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TitleBlock(movie: movie),
        const SizedBox(height: 24),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.genres.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) =>
                GenrePill(label: movie.genres[index], highlighted: index == 0),
          ),
        ),
        const SizedBox(height: 24),
        _Storyline(storyline: movie.storyline),
        if (movie.cast.isNotEmpty) ...[
          const SizedBox(height: 20),
          _CastSection(movie: movie),
        ],
        const SizedBox(height: 24),
        const _ScreeningSchedule(),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'SYNCING CELLULOID',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Icon(
              Icons.remove_red_eye_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              movie.viewCount,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          movie.title.toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'BebasNeue',
            color: AppColors.textPrimary,
            fontSize: 48,
            height: 1,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _MetaText('${movie.year}', color: AppColors.textPrimary),
            const _MetaDot(),
            _MetaText(movie.duration),
            const _MetaDot(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                movie.certification,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const _MetaDot(),
            _MetaText(movie.presentationFormat, color: AppColors.textCool),
          ],
        ),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text, {this.color = AppColors.textSecondary});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Storyline extends StatelessWidget {
  const _Storyline({required this.storyline});

  final String storyline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surfaceSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(child: _SectionTitle('Storyline')),
              Icon(
                Icons.menu_book_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            storyline,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 22.75 / 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CastSection extends StatelessWidget {
  const _CastSection({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Expanded(child: _SectionTitle('Key Cast & Director')),
            Text(
              'FULL CREDITS',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 4),
            itemBuilder: (context, index) =>
                CastMemberCard(member: movie.cast[index]),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'BebasNeue',
        color: AppColors.textPrimary,
        fontSize: 20,
        height: 22 / 20,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ScreeningSchedule extends StatelessWidget {
  const _ScreeningSchedule();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screening Schedule',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '3 cinemas in your area',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'View Times',
              style: TextStyle(
                color: AppColors.textCool,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistAction extends StatelessWidget {
  const _WatchlistAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.bookmark_add_outlined, size: 17),
                  label: const Text('Add to Watchlist'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      height: 18 / 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.28,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const SizedBox.square(
                    dimension: 48,
                    child: Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
