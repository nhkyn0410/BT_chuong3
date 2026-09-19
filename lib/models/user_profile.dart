/// Thông tin sinh viên hiển thị ở trang Hồ sơ.
class UserProfile {
  const UserProfile({
    this.fullName = '',
    this.studentId = '',
    this.className = '',
    this.email = '',
  });

  static const empty = UserProfile();

  final String fullName;
  final String studentId;
  final String className;
  final String email;

  bool get hasName => fullName.isNotEmpty;

  /// Tên gọi theo cách xưng hô của người Việt (từ cuối trong họ tên).
  String get givenName => fullName.split(' ').last;

  /// Chữ cái đầu của họ và tên, ví dụ "Nguyễn Văn An" -> "NA".
  String get initials {
    final words = fullName.split(' ').where((word) => word.isNotEmpty);
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
