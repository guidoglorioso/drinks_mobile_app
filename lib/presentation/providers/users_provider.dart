import 'package:drinks_mobile_app/domain/repository_users.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appUserProvider =
    StateNotifierProvider<AppUserNotifier, Map<String, dynamic>?>((ref) {
      return AppUserNotifier();
    });

class AppUserNotifier extends StateNotifier<Map<String, dynamic>?> {
  AppUserNotifier() : super(null);

  SharedPreferences? _prefs;
  final _usersRepository = Users();

  Future<void> loginUser(String email, String psw) async {
    try {
      final user = await _usersRepository.checkUser(email, psw);
      state = user;
      await _saveUserData();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logoutUser() async {
    state = null;
    await _removeUserData();
  }

  Future<void> registerUser(String email, String psw) async {
    try {
      await _usersRepository.insertUser(email, psw);
    } catch (e) {
      throw Exception(e);
    }
  }

  String getUserUrlPicture() => state?['pictureUrl'] ?? '';
  String getUsername() => state?['userName'] ?? '';
  String getEmail() => state?['email'] ?? '';

  Future<bool> editUsername(String newUsername) async {
    if (state == null) return false;

    // ojo aca que no se valida cambios en la base de datos en forma externa.
    bool success = await _usersRepository.db.editUser(
      state!['idUser'],
      newUsername,
      state!['email'],
      state!['psw'],
      state!['pictureUrl'],
    );

    if (success) {
      state = {...state!, 'userName': newUsername};
      await _saveUserData();
    }
    return success;
  }

  Future<bool> editUrlPicture(String newUrl) async {
    if (state == null) return false;

    //Idem editUsername
    bool success = await _usersRepository.db.editUser(
      state!['idUser'],
      state!['userName'],
      state!['email'],
      state!['psw'],
      newUrl,
    );

    if (success) {
      state = {...state!, 'newUrl': newUrl};
      await _saveUserData();
    }
    return success;
  }

  Future<bool> _saveUserData() async {
    if (_prefs == null) return false;
    _prefs = await SharedPreferences.getInstance();

    await _prefs!.setInt('idUser', state!['idUser']);
    await _prefs!.setString('userName', state!['userName']);
    await _prefs!.setString('email', state!['email']);
    await _prefs!.setString('psw', state!['psw']);
    await _prefs!.setString('pictureUrl', state!['pictureUrl']);

    await _prefs!.setBool('isLoggedIn', true);

    return true;
  }

  Future<bool> _removeUserData() async {
    if (_prefs == null) return false;

    await _prefs!.remove('idUser');
    await _prefs!.remove('userName');
    await _prefs!.remove('email');
    await _prefs!.remove('psw');
    await _prefs!.remove('pictureUrl');
    await _prefs!.setBool('isLoggedIn', false);

    return true;
  }

  Future<bool> loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _loadUserData();
    }
    return isLoggedIn;
  }

  bool _loadUserData() {
    if (_prefs == null) return false;

    state = {
      'idUser': _prefs!.getInt('idUser'),
      'userName': _prefs!.getString('userName'),
      'email': _prefs!.getString('email'),
      'psw': _prefs!.getString('psw'),
      'pictureUrl': _prefs!.getString('pictureUrl'),
    };

    return true;
  }
}
