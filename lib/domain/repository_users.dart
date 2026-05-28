import 'package:drinks_mobile_app/domain/db_helper_users.dart';

class Users {
  final DbHelperUsers db;

  Users() : db = DbHelperUsers.instance;

  Future<void> insertUser(String email, String password) async {
    //final test = await db.getDb();

    if (!_verifyPass(password)) {
      throw Exception('Invalid password');
    }
    if (!await _verifyEmail(email)) {
      throw Exception('Email already exists');
    }
    String username = email.split('@')[0];
    String url = "";

    db.addUser(username, email, password, url);
  }

  Future<Map<String, dynamic>> checkUser(String email, String password) async {
    final user = await db.getUserBy('email', email);

    if (user == null) {
      throw Exception('Invalid Email');
    }
    if (user['email'] == email && user['psw'] == password) {
      return user;
    }

    throw Exception('Incorrect Password');
  }

  bool _verifyPass(String password) {
    if ((password.length > 6) &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_-]')) &&
        password.contains(RegExp(r'[a-z]'))) {
      return true;
    }
    return false;
  }

  Future<bool> _verifyEmail(String email) async {
    final check = await db.getUserBy('email', email);
    return (check == null);
  }
}
