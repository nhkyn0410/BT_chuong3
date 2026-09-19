import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../models/movie_category.dart';
import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../state/settings_controller.dart';
import '../state/shell_controller.dart';
import '../state/watchlist_controller.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/section_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _editProfile(BuildContext context) async {
    final settings = SettingsScope.of(context, listen: false);
    final updated = await Navigator.pushNamed<UserProfile>(
      context,
      AppRoutes.editProfile,
      arguments: settings.profile,
    );
    if (updated == null || !context.mounted) return;

    settings.updateProfile(updated);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Đã lưu hồ sơ của ${updated.fullName}')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    final profile = settings.profile;
    final watchlistCount = WatchlistScope.of(context).count;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _ProfileCard(profile: profile, onEdit: () => _editProfile(context)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.bookmark_rounded,
                    value: '$watchlistCount',
                    label: 'Phim xem sau',
                    onTap: () => ShellScope.of(
                      context,
                      listen: false,
                    ).select(AppTab.watchlist),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    icon: Icons.category_rounded,
                    value: '${MovieCategory.values.length}',
                    label: 'Thể loại',
                    onTap: () => ShellScope.of(
                      context,
                      listen: false,
                    ).select(AppTab.categories),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    icon: Icons.movie_rounded,
                    value: '${movies.length}',
                    label: 'Bộ phim',
                    onTap: () => ShellScope.of(
                      context,
                      listen: false,
                    ).select(AppTab.home),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Giao diện'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Chế độ hiển thị',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Sáng'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Tối'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('Hệ thống'),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (selection) =>
                          settings.setThemeMode(selection.first),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Thông tin'),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Giới thiệu ứng dụng'),
                subtitle: const Text('Movie Explorer – Chương 4'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showMovieExplorerAbout(context, profile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onEdit});

  final UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ProfileAvatar(profile: profile, radius: 34),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.hasName ? profile.fullName : 'Chưa có họ tên',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 20,
                          height: 26 / 20,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.hasName
                            ? 'Sinh viên'
                            : 'Nhấn "Cập nhật hồ sơ" để nhập thông tin',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Họ và tên',
              value: profile.fullName,
            ),
            _InfoRow(
              icon: Icons.numbers_rounded,
              label: 'MSSV',
              value: profile.studentId,
            ),
            _InfoRow(
              icon: Icons.school_outlined,
              label: 'Lớp',
              value: profile.className,
            ),
            _InfoRow(
              icon: Icons.alternate_email_rounded,
              label: 'Email',
              value: profile.email,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onEdit,
              icon: Icon(
                profile.hasName ? Icons.edit_outlined : Icons.person_add_alt,
              ),
              label: Text(
                profile.hasName ? 'Chỉnh sửa hồ sơ' : 'Cập nhật hồ sơ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onSurfaceVariant),
          const SizedBox(width: 12),
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Chưa cập nhật' : value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: value.isEmpty ? colors.outline : colors.onSurface,
                fontSize: 14,
                fontWeight: value.isEmpty ? FontWeight.w400 : FontWeight.w600,
                fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: colors.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 22,
                  color: colors.onSurface,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
