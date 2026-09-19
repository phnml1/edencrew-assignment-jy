import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/watchlist/watchlist_screen.dart';
import 'theme/theme.dart';

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '이든크루 평가 과제',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AppSystemChrome(child: WatchlistScreen()),
    );
  }
}

class AppSystemChrome extends StatelessWidget {
  const AppSystemChrome({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.surfaceBase,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: colors.surfaceRaised,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: child,
    );
  }
}
