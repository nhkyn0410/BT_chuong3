import 'package:flutter/material.dart';

/// Danh mục (thể loại) phim. Mỗi phim thuộc một hoặc nhiều danh mục.
enum MovieCategory {
  sciFi(
    label: 'Khoa học viễn tưởng',
    icon: Icons.rocket_launch_outlined,
    color: Color(0xFF5B8DEF),
    description:
        'Du hành không gian, công nghệ tương lai và những thế giới chưa '
        'từng tồn tại.',
  ),
  action(
    label: 'Hành động',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFFE5533D),
    description: 'Rượt đuổi nghẹt thở, cháy nổ và những màn đối đầu mãn nhãn.',
  ),
  adventure(
    label: 'Phiêu lưu',
    icon: Icons.explore_outlined,
    color: Color(0xFF2FA37C),
    description:
        'Hành trình khám phá vùng đất mới cùng những thử thách bất ngờ.',
  ),
  mystery(
    label: 'Bí ẩn',
    icon: Icons.psychology_alt_outlined,
    color: Color(0xFF8E6CDF),
    description:
        'Câu đố, bí mật và những cú lừa khiến bạn phải suy ngẫm đến phút '
        'cuối.',
  ),
  drama(
    label: 'Chính kịch',
    icon: Icons.theater_comedy_outlined,
    color: Color(0xFFD9822B),
    description:
        'Câu chuyện giàu cảm xúc về con người và những lựa chọn khó khăn.',
  ),
  crime(
    label: 'Tội phạm',
    icon: Icons.local_police_outlined,
    color: Color(0xFF7A8A9E),
    description:
        'Thế giới ngầm, những phi vụ táo bạo và cuộc chiến vì công lý.',
  ),
  biography(
    label: 'Tiểu sử',
    icon: Icons.history_edu_outlined,
    color: Color(0xFFB38B59),
    description: 'Tái hiện cuộc đời những nhân vật có thật đã làm nên lịch sử.',
  ),
  animation(
    label: 'Hoạt hình',
    icon: Icons.palette_outlined,
    color: Color(0xFFE0569B),
    description: 'Thế giới đầy màu sắc và sáng tạo dành cho mọi lứa tuổi.',
  );

  const MovieCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String description;
}
