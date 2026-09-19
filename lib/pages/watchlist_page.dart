import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../state/shell_controller.dart';
import '../state/watchlist_controller.dart';
import '../theme/app_text_styles.dart';
import '../widgets/movie_list_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/watchlist_button.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final watchlist = WatchlistScope.of(context, listen: false);
    // Hộp thoại trả về true/false qua `Navigator.pop(context, value)`.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_sweep_outlined),
        title: const Text('Xóa toàn bộ danh sách?'),
        content: Text(
          'Thao tác này sẽ xóa ${watchlist.count} phim khỏi danh sách xem sau.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) watchlist.clear();
  }

  @override
  Widget build(BuildContext context) {
    final movies = WatchlistScope.of(context).movies;
    if (movies.isEmpty) return const _EmptyWatchlist();

    final colors = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: '${movies.length} phim đã lưu',
                  trailing: TextButton.icon(
                    onPressed: () => _confirmClear(context),
                    icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                    label: const Text('Xóa tất cả'),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Vuốt sang trái để xóa một phim khỏi danh sách.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList.separated(
                itemCount: movies.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Dismissible(
                    key: ValueKey(movie.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        color: colors.errorContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: colors.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) => removeFromWatchlist(context, movie),
                    child: MovieListTile(
                      movie: movie,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.movie,
                        arguments: movie,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_add_outlined,
                size: 44,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Danh sách đang trống',
              style: AppTextStyles.heading.copyWith(
                fontSize: 20,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn "Thêm vào danh sách xem" ở trang chi tiết phim\n'
              'hoặc biểu tượng bookmark để lưu phim bạn thích.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  ShellScope.of(context, listen: false).select(AppTab.home),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Khám phá phim'),
            ),
          ],
        ),
      ),
    );
  }
}
