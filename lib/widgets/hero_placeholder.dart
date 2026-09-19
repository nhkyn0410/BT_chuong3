import 'package:flutter/widgets.dart';

/// Mặc định Hero ẩn widget gốc khi bay sang trang khác và chỉ hiện lại khi bay
/// về đúng vị trí đó. Nếu quay về bằng `popUntil` kèm đổi tab (trang Thành
/// công), chuyến bay về không diễn ra và poster bị ẩn mãi. Giữ nguyên widget
/// gốc làm placeholder để poster luôn hiển thị.
Widget keepHeroVisible(BuildContext context, Size heroSize, Widget child) =>
    child;
