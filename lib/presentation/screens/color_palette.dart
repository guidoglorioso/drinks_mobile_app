import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/domain/users.dart';
import 'package:login_app/presentation/providers/color_theme_provider.dart';
import 'package:login_app/domain/app_theme.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(appThemeProvider).isDark;
    return Scaffold(
      appBar : AppBar(
        title: Text("Paleta de colores"),
        actions: [
          IconButton(
            onPressed: (){
              ref.read(appThemeProvider.notifier).setThemeBrightness(!isDark);
            } 
          , 
          icon: isDark ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
          ), 
        ],
      ),
      body: _bodyThemeScreen(),
    );
  }
}

class _bodyThemeScreen extends StatelessWidget {
  const _bodyThemeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) => ItemThemeScreen(color: colors[index],name: ("Color N°  " + index.toString()),index : index ),
      ) 
    );
  }
}

class ItemThemeScreen extends ConsumerWidget {

  final MaterialColor color;
  final String name;
  final int index;
  const ItemThemeScreen({
    super.key,
    required this.color,
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context,ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color, // El color que elijas
          radius: 12, // Opcional: ajusta el tamaño
        ),
        title: Text(name),
        onTap: () => ref.read(appThemeProvider).copyWith(color: index),
      ),
    );
  }
}