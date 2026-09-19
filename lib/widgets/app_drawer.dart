import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../models/movie_category.dart';
import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../state/settings_controller.dart';
import '../state/shell_controller.dart';
import '../theme/app_text_styles.dart';
import 'profile_avatar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _selectTab(BuildContext context, AppTab tab) {
    Navigator.pop(context); // Đóng Drawer.
    ShellScope.of(context, listen: false).select(tab);
  }

  void _openCategory(BuildContext context, MovieCategory category) {
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.category, arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ShellScope.of(context).value;
    final profile = SettingsScope.of(context).profile;
    final colors = Theme.of(context).colorScheme;

    return NavigationDrawer(
      selectedIndex: currentTab.index,
      onDestinationSelected: (index) =>
          _selectTab(context, AppTab.values[index]),
      children: [
        _DrawerHeader(
          profile: profile,
          onTap: () => _selectTab(context, AppTab.profile),
        ),
        for (final tab in AppTab.values)
          NavigationDrawerDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.selectedIcon),
            label: Text(tab.label),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Text(
            'THỂ LOẠI',
            style: AppTextStyles.overline.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        for (final category in MovieCategory.values)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            visualDensity: VisualDensity.compact,
            leading: Icon(category.icon, color: category.color),
            title: Text(category.label),
            trailing: Text(
              '${moviesIn(category).length}',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            onTap: () => _openCategory(context, category),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Divider(),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.info_outline_rounded),
          title: const Text('Giới thiệu ứng dụng'),
          onTap: () {
            Navigator.pop(context);
            showMovieExplorerAbout(context, profile);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.profile, required this.onTap});

  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Material(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ProfileAvatar(profile: profile, radius: 26),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.hasName ? profile.fullName : 'Khách',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 17,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.studentId.isNotEmpty
                            ? 'MSSV: ${profile.studentId}'
                            : 'Chạm để cập nhật hồ sơ',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showMovieExplorerAbout(BuildContext context, UserProfile profile) {
  showAboutDialog(
    context: context,
    applicationName: 'Movie Explorer',
    applicationVersion: 'Phiên bản 2.0 – Chương 4',
    applicationIcon: Icon(
      Icons.movie_filter_rounded,
      size: 40,
      color: Theme.of(context).colorScheme.primary,
    ),
    children: [
      const Text(
        'Ứng dụng khám phá phim minh họa điều hướng và truyền dữ liệu giữa '
        'các màn hình, Bottom Navigation, Drawer, Material Design 3 và hiển '
        'thị danh mục.',
      ),
      if (profile.hasName) ...[
        const SizedBox(height: 12),
        Text(
          'Sinh viên thực hiện: ${profile.fullName}'
          '${profile.studentId.isNotEmpty ? ' – MSSV ${profile.studentId}' : ''}',
        ),
      ],
    ],
  );
}
