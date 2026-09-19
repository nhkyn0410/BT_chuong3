import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  /// BebasNeue không có đủ dấu tiếng Việt (thiếu Ơ, Ư và các dấu thanh), nên
  /// chỉ dùng cho chữ không dấu như tên phim gốc và logo.
  static const display = TextStyle(
    fontFamily: 'BebasNeue',
    height: 1,
    letterSpacing: 1,
  );

  /// Tiêu đề tiếng Việt dùng HankenGrotesk đậm vì font này có đủ bộ dấu.
  static const heading = TextStyle(
    fontFamily: 'HankenGrotesk',
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
  );

  static const overline = TextStyle(
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}
