import 'package:flutter/material.dart';

final List<MaterialColor> colors = [
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.green,
  Colors.pink,
  Colors.orange,
  Colors.purple,
  Colors.grey,
];

class AppTheme {
  int color;
  bool isDark;

  AppTheme({
    this.color = 1, 
    this.isDark = false,
    });

  ThemeData getThemeData(bool isDark,int color){
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colors[color],
      );
  }
  
  AppTheme copyWith({
    int? color,
    bool? isDark,
  }){
    return AppTheme(
      color: color ?? this.color,
      isDark: isDark ?? this.isDark, 
      );
  }
}