import 'package:flutter/material.dart';

import 'models/movie.dart';
import 'pages/home_page.dart';
import 'pages/success_page.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomePage(),
      routes: {
        AppRoutes.success: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments is! Movie) {
            throw FlutterError(
              'The ${AppRoutes.success} route requires a Movie argument.',
            );
          }
          return SuccessPage(movie: arguments);
        },
      },
    );
  }
}
