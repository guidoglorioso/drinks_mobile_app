import 'package:drinks_mobile_app/core/router/app_router.dart';
import 'package:drinks_mobile_app/presentation/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      theme: themeData.getThemeData(themeData.isDark, themeData.color),
    );
  }
}
