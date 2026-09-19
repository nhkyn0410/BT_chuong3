import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../models/movie.dart';
import '../models/movie_category.dart';
import '../routes/app_routes.dart';
import '../widgets/movie_list_tile.dart';

enum MovieSort {
  rating('Điểm đánh giá cao nhất', Icons.star_rounded),
  newest('Mới phát hành', Icons.new_releases_outlined),
  title('Tên phim (A – Z)', Icons.sort_by_alpha_rounded);

  const MovieSort(this.label, this.icon);

  final String label;
  final IconData icon;

  int compare(Movie a, Movie b) => switch (this) {
    MovieSort.rating => b.rating.compareTo(a.rating),
    MovieSort.newest => b.year.compareTo(a.year),
    MovieSort.title => a.title.compareTo(b.title),
  };
}

/// Danh sách phim của một danh mục, nhận [category] qua `arguments` của
/// route có tên [AppRoutes.category].
class CategoryMoviesPage extends StatefulWidget {
  const CategoryMoviesPage({super.key, required this.category});

  final MovieCategory category;

  @override
  State<CategoryMoviesPage> createState() => _CategoryMoviesPageState();
}

class _CategoryMoviesPageState extends State<CategoryMoviesPage> {
  MovieSort _sort = MovieSort.rating;

  Future<void> _chooseSort() async {
    // Bottom sheet trả lựa chọn về qua `Navigator.pop(context, value)`.
    final selected = await showModalBottomSheet<MovieSort>(
      context: context,
      showDragHandle: true,
      builder: (context) => _SortSheet(current: _sort),
    );
    if (selected != null) setState(() => _sort = selected);
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final categoryMovies = moviesIn(category)..sort(_sort.compare);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(category.label),
            actions: [
              IconButton(
                tooltip: 'Sắp xếp',
                onPressed: _chooseSort,
                icon: const Icon(Icons.sort_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            sliver: SliverToBoxAdapter(
              child: _CategoryIntro(
                category: category,
                movieCount: categoryMovies.length,
                sort: _sort,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList.separated(
              itemCount: categoryMovies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = categoryMovies[index];
                return MovieListTile(
                  movie: movie,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.movie,
                    arguments: movie,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIntro extends StatelessWidget {
  const _CategoryIntro({
    required this.category,
    required this.movieCount,
    required this.sort,
  });

  final MovieCategory category;
  final int movieCount;
  final MovieSort sort;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: Color.alphaBlend(
        category.color.withValues(alpha: 0.14),
        colors.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category.icon, color: category.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$movieCount phim',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(sort.icon, size: 16, color: colors.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Sắp xếp: ${sort.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.primary,
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
    );
  }
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.current});

  final MovieSort current;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              'Sắp xếp theo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final option in MovieSort.values)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(option.icon),
              title: Text(option.label),
              selected: option == current,
              selectedColor: colors.primary,
              trailing: option == current
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(context, option),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
