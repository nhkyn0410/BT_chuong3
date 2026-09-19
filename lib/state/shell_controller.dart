import 'package:flutter/material.dart';

/// Các tab của Bottom Navigation (và các mục tương ứng trong Drawer).
enum AppTab {
  home('Trang chủ', Icons.home_outlined, Icons.home_rounded),
  categories('Danh mục', Icons.category_outlined, Icons.category_rounded),
  watchlist('Xem sau', Icons.bookmark_border_rounded, Icons.bookmark_rounded),
  profile('Hồ sơ', Icons.person_outline_rounded, Icons.person_rounded);

  const AppTab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Tab đang chọn. Được đặt phía trên MaterialApp để cả các màn hình được
/// push lên sau (ví dụ trang Thành công) cũng có thể chuyển tab.
class ShellController extends ValueNotifier<AppTab> {
  ShellController() : super(AppTab.home);

  void select(AppTab tab) => value = tab;
}

class ShellScope extends InheritedNotifier<ShellController> {
  const ShellScope({
    super.key,
    required ShellController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Dùng `listen: false` trong các hàm xử lý sự kiện (onPressed, onTap...).
  static ShellController of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<ShellScope>()
        : context.getInheritedWidgetOfExactType<ShellScope>();
    assert(scope != null, 'Không tìm thấy ShellScope phía trên context.');
    return scope!.notifier!;
  }
}
