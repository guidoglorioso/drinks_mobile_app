import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:login_app/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:login_app/presentation/providers/color_theme_provider.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}


class MainApp extends ConsumerWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeData = ref.watch(appThemeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: themeData.getThemeData(themeData.isDark,themeData.color),

    );
  }
}


