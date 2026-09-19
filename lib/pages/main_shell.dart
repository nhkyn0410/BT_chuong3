import 'package:flutter/material.dart';

import '../state/settings_controller.dart';
import '../state/shell_controller.dart';
import '../state/watchlist_controller.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../widgets/profile_avatar.dart';
import 'categories_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'watchlist_page.dart';

/// Khung chính của ứng dụng: AppBar + Drawer + Bottom Navigation.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = <AppTab, Widget>{
    AppTab.home: HomePage(),
    AppTab.categories: CategoriesPage(),
    AppTab.watchlist: WatchlistPage(),
    AppTab.profile: ProfilePage(),
  };

  @override
  Widget build(BuildContext context) {
    final shell = ShellScope.of(context);
    final currentTab = shell.value;
    final watchlistCount = WatchlistScope.of(context).count;
    final profile = SettingsScope.of(context).profile;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: currentTab == AppTab.home
            ? Text(
                'MOVIE EXPLORER',
                style: AppTextStyles.display.copyWith(
                  fontSize: 26,
                  letterSpacing: 1.3,
                  color: colors.primary,
                ),
              )
            : Text(currentTab.label),
        actions: [
          IconButton(
            tooltip: AppTab.profile.label,
            onPressed: () => shell.select(AppTab.profile),
            icon: ProfileAvatar(profile: profile, radius: 16),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      // IndexedStack giữ nguyên trạng thái (vị trí cuộn, bộ lọc) của từng tab.
      body: IndexedStack(
        index: currentTab.index,
        children: [
          for (final tab in AppTab.values)
            // Tắt Hero ở các tab đang ẩn để không trùng tag với tab đang hiện.
            HeroMode(enabled: tab == currentTab, child: _pages[tab]!),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab.index,
        onDestinationSelected: (index) => shell.select(AppTab.values[index]),
        destinations: [
          for (final tab in AppTab.values)
            NavigationDestination(
              icon: _TabIcon(tab: tab, count: watchlistCount),
              selectedIcon: _TabIcon(
                tab: tab,
                count: watchlistCount,
                selected: true,
              ),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.tab,
    required this.count,
    this.selected = false,
  });

  final AppTab tab;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(selected ? tab.selectedIcon : tab.icon);
    if (tab != AppTab.watchlist) return icon;
    return Badge.count(count: count, isLabelVisible: count > 0, child: icon);
  }
}
