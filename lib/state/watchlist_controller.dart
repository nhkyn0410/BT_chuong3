import 'package:flutter/widgets.dart';

import '../models/movie.dart';

/// Danh sách phim "Xem sau", dùng chung cho mọi màn hình: thêm ở trang chi
/// tiết, hiển thị ở tab Xem sau và số lượng trên Badge của Bottom Navigation.
class WatchlistController extends ChangeNotifier {
  final List<Movie> _movies = [];

  List<Movie> get movies => List.unmodifiable(_movies);

  int get count => _movies.length;

  bool contains(Movie movie) => _movies.any((saved) => saved.id == movie.id);

  void add(Movie movie) {
    if (contains(movie)) return;
    _movies.add(movie);
    notifyListeners();
  }

  /// Xóa phim và trả về vị trí cũ để có thể hoàn tác bằng [insert].
  int remove(Movie movie) {
    final index = _movies.indexWhere((saved) => saved.id == movie.id);
    if (index == -1) return -1;
    _movies.removeAt(index);
    notifyListeners();
    return index;
  }

  void insert(int index, Movie movie) {
    if (contains(movie)) return;
    _movies.insert(index.clamp(0, _movies.length), movie);
    notifyListeners();
  }

  void clear() {
    _movies.clear();
    notifyListeners();
  }
}

class WatchlistScope extends InheritedNotifier<WatchlistController> {
  const WatchlistScope({
    super.key,
    required WatchlistController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Dùng `listen: false` trong các hàm xử lý sự kiện (onPressed, onTap...).
  static WatchlistController of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<WatchlistScope>()
        : context.getInheritedWidgetOfExactType<WatchlistScope>();
    assert(scope != null, 'Không tìm thấy WatchlistScope phía trên context.');
    return scope!.notifier!;
  }
}
