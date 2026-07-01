import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class EumApp extends StatelessWidget {
  const EumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '이음',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
