import 'package:flutter/material.dart';

import '../models/user_profile.dart';

/// Ảnh đại diện hiển thị chữ cái đầu của họ tên (hoặc icon khi chưa có tên).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, this.radius = 20});

  final UserProfile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = profile.initials;
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      child: initials.isEmpty
          ? Icon(Icons.person_rounded, size: radius)
          : Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.72,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
