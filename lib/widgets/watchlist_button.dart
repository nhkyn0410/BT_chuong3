import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../state/watchlist_controller.dart';

/// Nút bookmark bật/tắt phim trong danh sách "Xem sau".
class WatchlistButton extends StatelessWidget {
  const WatchlistButton({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final saved = WatchlistScope.of(context).contains(movie);
    return IconButton(
      tooltip: saved
          ? 'Bỏ khỏi danh sách xem sau'
          : 'Thêm vào danh sách xem sau',
      isSelected: saved,
      icon: const Icon(Icons.bookmark_add_outlined),
      selectedIcon: Icon(
        Icons.bookmark_added_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => toggleWatchlist(context, movie),
    );
  }
}

void toggleWatchlist(BuildContext context, Movie movie) {
  final watchlist = WatchlistScope.of(context, listen: false);
  if (watchlist.contains(movie)) {
    removeFromWatchlist(context, movie);
    return;
  }
  watchlist.add(movie);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text('Đã thêm "${movie.title}" vào danh sách xem sau')),
    );
}

/// Xóa phim khỏi danh sách và cho phép hoàn tác qua SnackBar.
void removeFromWatchlist(BuildContext context, Movie movie) {
  final watchlist = WatchlistScope.of(context, listen: false);
  final index = watchlist.remove(movie);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Đã bỏ "${movie.title}" khỏi danh sách xem sau'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () => watchlist.insert(index, movie),
        ),
      ),
    );
}
