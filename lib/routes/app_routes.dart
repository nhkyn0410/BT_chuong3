import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/movie_category.dart';
import '../models/user_profile.dart';
import '../pages/category_movies_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/main_shell.dart';
import '../pages/movie_detail_page.dart';
import '../pages/success_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const category = '/category';
  static const movie = '/movie';
  static const success = '/success';
  static const editProfile = '/profile/edit';

  /// Tạo route theo tên, đồng thời kiểm tra kiểu của `arguments` được truyền
  /// qua `Navigator.pushNamed(context, name, arguments: ...)`.
  static Route<Object?> onGenerateRoute(RouteSettings settings) {
    return switch ((settings.name, settings.arguments)) {
      (home, _) => _page<void>(settings, const MainShell()),
      (category, final MovieCategory selected) => _page<void>(
        settings,
        CategoryMoviesPage(category: selected),
      ),
      (movie, final Movie selected) => _page<void>(
        settings,
        MovieDetailPage(movie: selected),
      ),
      (success, final Movie selected) => _page<void>(
        settings,
        SuccessPage(movie: selected),
      ),
      // Kiểu của route phải khớp với kiểu kết quả mà `pushNamed<UserProfile>`
      // chờ nhận khi màn hình gọi `Navigator.pop(context, profile)`.
      (editProfile, final UserProfile profile) => _page<UserProfile>(
        settings,
        EditProfilePage(initialProfile: profile),
      ),
      _ => throw FlutterError(
        'Route "${settings.name}" không tồn tại hoặc nhận sai tham số: '
        '${settings.arguments}',
      ),
    };
  }

  static MaterialPageRoute<T> _page<T>(RouteSettings settings, Widget page) =>
      MaterialPageRoute<T>(settings: settings, builder: (context) => page);
}
