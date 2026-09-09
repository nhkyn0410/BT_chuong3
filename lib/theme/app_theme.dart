import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    const baseTextTheme = TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'HankenGrotesk',
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'HankenGrotesk',
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: 'HankenGrotesk',
        color: AppColors.textMuted,
      ),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'HankenGrotesk',
      textTheme: baseTextTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      splashFactory: InkRipple.splashFactory,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
