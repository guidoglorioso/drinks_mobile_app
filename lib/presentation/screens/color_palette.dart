import 'package:drinks_mobile_app/domain/app_theme.dart';
import 'package:drinks_mobile_app/presentation/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(appThemeProvider).isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Paleta de colores"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(appThemeProvider.notifier).setThemeBrightness(!isDark);
            },
            icon: isDark ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
          ),
        ],
      ),
      body: BodyThemeScreen(),
    );
  }
}

class BodyThemeScreen extends StatelessWidget {
  const BodyThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) => ItemThemeScreen(
          name: ("Color N°  " + index.toString()),
          color: index,
        ),
      ),
    );
  }
}

class ItemThemeScreen extends ConsumerWidget {
  final int color;
  final String name;
  const ItemThemeScreen({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors[color], // El color que elijas
          radius: 12, // Opcional: ajusta el tamaño
        ),
        title: Text(name),
        onTap: () => ref.read(appThemeProvider.notifier).setThemeColor(color),
      ),
    );
  }
}
