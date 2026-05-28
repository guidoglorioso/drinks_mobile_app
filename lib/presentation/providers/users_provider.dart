import 'package:drinks_mobile_app/domain/repository_users.dart';
import 'package:flutter_riverpod/legacy.dart';

final appUserProvider = StateNotifierProvider<AppUserNotifier, Users>((ref) {
  return AppUserNotifier();
});

class AppUserNotifier extends StateNotifier<Users> {
  AppUserNotifier() : super(Users());

  Map<String, dynamic>? userData;

  Future<void> loginUser(String email, String psw) async {
    try {
      final user = await state.checkUser(email, psw);
      userData = user;
    } catch (e) {
      throw Exception(e);
    }
  }

  bool logoutUser() {
    userData = null;
    return true;
  }

  Future<void> registerUser(String email, String psw) async {
    try {
      await state.insertUser(email, psw);
    } catch (e) {
      throw Exception(e);
    }
  }

  String getUserUrlPicture() => userData?['pictureUrl'] ?? '';
  String getUsername() => userData?['userName'] ?? 'Invitado';
  String getEmail() => userData?['email'] ?? '';

  Future<bool> editUsername(String newUsername) async {
    if (userData == null) return false;
    // ojo aca que no se valida cambios en la base de datos en forma externa.
    bool success = await state.db.editUser(
      userData!['idUser'],
      newUsername,
      userData!['email'],
      userData!['psw'],
      userData!['pictureUrl'],
    );

    if (success) userData!['userName'] = newUsername;
    return success;
  }

  Future<bool> editUrlPicture(String newUrl) async {
    if (userData == null) return false;
    //Idem editUsername
    bool success = await state.db.editUser(
      userData!['idUser'],
      userData!['userName'],
      userData!['email'],
      userData!['psw'],
      newUrl,
    );

    if (success) userData!['pictureUrl'] = newUrl;
    return success;
  }
}
