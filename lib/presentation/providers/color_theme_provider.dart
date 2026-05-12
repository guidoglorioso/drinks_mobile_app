import 'package:flutter_riverpod/legacy.dart';
import 'package:login_app/domain/app_theme.dart';


final appThemeProvider = StateNotifierProvider<AppThemeNotifier,AppTheme>((ref,){
  return AppThemeNotifier();
}
);

class AppThemeNotifier extends StateNotifier<AppTheme>{
  
  AppThemeNotifier() : super(AppTheme()); // valor por defecto en la aplicacion.

  void setThemeColor(int color){
    state = state.copyWith(color: color);
  }

  void setThemeBrightness(bool isDark){
    state = state.copyWith(isDark: isDark);
  }


}