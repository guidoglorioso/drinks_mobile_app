import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final authStateProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);

  final String? idUser = prefs.getString('idUser');
  if (idUser == null || idUser.isEmpty) {
    return null; // No hay usuario guardado
  }

  return {
    'idUser': idUser,
    'userName': prefs.getString('userName') ?? '',
    'email': prefs.getString('email') ?? '',
    'pictureUrl': prefs.getString('pictureUrl') ?? '',
  };
});
