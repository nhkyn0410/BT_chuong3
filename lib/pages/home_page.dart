import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../models/movie.dart';
import '../models/movie_category.dart';
import '../models/user_profile.dart';
import '../state/settings_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// `null` nghĩa là đang chọn "Tất cả".
  MovieCategory? _category;

  void _openMovie(Movie movie) {
    // Truyền dữ liệu qua constructor của màn hình đích.
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = SettingsScope.of(context).profile;
    final category = _category;
    final visibleMovies = category == null ? movies : moviesIn(category);
    final featuredMovies = [...movies]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = constraints.maxWidth.clamp(0.0, 760.0);
        final columns = maxContentWidth >= 600 ? 3 : 2;

        return Center(
          child: SizedBox(
            width: maxContentWidth,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  sliver: SliverToBoxAdapter(
                    child: _Greeting(profile: profile),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(title: 'Nổi bật tuần này'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FeaturedCarousel(
                    movies: featuredMovies.take(4).toList(),
                    onOpen: _openMovie,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Phim phổ biến',
                      trailing: CountPill('${visibleMovies.length} PHIM'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _CategoryFilter(
                    selected: category,
                    onSelected: (value) => setState(() => _category = value),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 167 / 338.5,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final movie = visibleMovies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => _openMovie(movie),
                      );
                    }, childCount: visibleMovies.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.hasName ? 'Xin chào, ${profile.givenName}!' : 'Xin chào!',
          style: AppTextStyles.heading.copyWith(
            fontSize: 24,
            height: 30 / 24,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hôm nay bạn muốn xem phim gì?',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }
}

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({required this.movies, required this.onOpen});

  final List<Movie> movies;
  final ValueChanged<Movie> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        height: 196,
        child: CarouselView(
          itemExtent: 300,
          shrinkExtent: 180,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          onTap: (index) => onOpen(movies[index]),
          children: [for (final movie in movies) _FeaturedItem(movie: movie)],
        ),
      ),
    );
  }
}

class _FeaturedItem extends StatelessWidget {
  const _FeaturedItem({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    // Chữ nằm trên ảnh nên dùng màu cố định cho cả hai chế độ Sáng/Tối.
    return Stack(
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
              colors: [Colors.transparent, Color(0xE60C0E13)],
              stops: [0.3, 1],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                movie.genres.first.label.toUpperCase(),
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                movie.title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.display.copyWith(
                  fontSize: 30,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  // Thẻ co hẹp khi cuộn Carousel nên cần cắt chữ bằng "...".
                  Flexible(
                    child: Text(
                      '${movie.rating.toStringAsFixed(1)}  •  ${movie.year}  •  '
                      '${movie.duration}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onSelected});

  final MovieCategory? selected;
  final ValueChanged<MovieCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          ChoiceChip(
            label: const Text('Tất cả'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final category in MovieCategory.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              avatar: Icon(category.icon, size: 16, color: category.color),
              label: Text(category.label),
              selected: selected == category,
              onSelected: (_) => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}
