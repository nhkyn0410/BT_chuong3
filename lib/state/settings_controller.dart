import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Lưu chế độ Sáng/Tối và hồ sơ sinh viên. Khi có [SharedPreferences], dữ
/// liệu được ghi xuống máy nên vẫn còn sau khi tắt ứng dụng.
class SettingsController extends ChangeNotifier {
  SettingsController({this._preferences}) {
    _themeMode =
        ThemeMode.values.asNameMap()[_preferences?.getString(_themeKey)] ??
        ThemeMode.dark;
    _profile = UserProfile(
      fullName: _preferences?.getString(_fullNameKey) ?? '',
      studentId: _preferences?.getString(_studentIdKey) ?? '',
      className: _preferences?.getString(_classNameKey) ?? '',
      email: _preferences?.getString(_emailKey) ?? '',
    );
  }

  static const _themeKey = 'settings.theme_mode';
  static const _fullNameKey = 'profile.full_name';
  static const _studentIdKey = 'profile.student_id';
  static const _classNameKey = 'profile.class_name';
  static const _emailKey = 'profile.email';

  final SharedPreferences? _preferences;
  late ThemeMode _themeMode;
  late UserProfile _profile;

  ThemeMode get themeMode => _themeMode;
  UserProfile get profile => _profile;

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    _save(_themeKey, mode.name);
  }

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
    _save(_fullNameKey, profile.fullName);
    _save(_studentIdKey, profile.studentId);
    _save(_classNameKey, profile.className);
    _save(_emailKey, profile.email);
  }

  void _save(String key, String value) {
    final preferences = _preferences;
    if (preferences != null) unawaited(preferences.setString(key, value));
  }
}

class SettingsScope extends InheritedNotifier<SettingsController> {
  const SettingsScope({
    super.key,
    required SettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Dùng `listen: false` trong các hàm xử lý sự kiện (onPressed, onTap...).
  static SettingsController of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<SettingsScope>()
        : context.getInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'Không tìm thấy SettingsScope phía trên context.');
    return scope!.notifier!;
  }
}
