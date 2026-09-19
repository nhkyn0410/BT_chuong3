import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes/app_routes.dart';
import 'state/settings_controller.dart';
import 'state/shell_controller.dart';
import 'state/watchlist_controller.dart';
import 'theme/app_theme.dart';

class MovieExplorerApp extends StatefulWidget {
  const MovieExplorerApp({super.key, this.settings});

  /// Bỏ trống thì cài đặt chỉ nằm trong bộ nhớ (dùng cho kiểm thử).
  final SettingsController? settings;

  @override
  State<MovieExplorerApp> createState() => _MovieExplorerAppState();
}

class _MovieExplorerAppState extends State<MovieExplorerApp> {
  late final _settings = widget.settings ?? SettingsController();
  final _watchlist = WatchlistController();
  final _shell = ShellController();

  @override
  void dispose() {
    if (widget.settings == null) _settings.dispose();
    _watchlist.dispose();
    _shell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Các Scope nằm trên MaterialApp để mọi route đều truy cập được.
    return SettingsScope(
      controller: _settings,
      child: WatchlistScope(
        controller: _watchlist,
        child: ShellScope(
          controller: _shell,
          child: ListenableBuilder(
            listenable: _settings,
            builder: (context, child) => MaterialApp(
              title: 'Movie Explorer',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: _settings.themeMode,
              locale: const Locale('vi'),
              supportedLocales: const [Locale('vi'), Locale('en')],
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              initialRoute: AppRoutes.home,
              onGenerateRoute: AppRoutes.onGenerateRoute,
            ),
          ),
        ),
      ),
    );
  }
}
