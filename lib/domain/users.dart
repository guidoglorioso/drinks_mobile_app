
  final List bdUsers = [{
      'email': "guido",
      'password': "Guido123"
      }];

class Users {

  final List users;

  Users({required this.users});

  void insertUser(String email, String password) {
    
    if(!_verifyPass(password)){
      throw Exception('Invalid password');
    }
    if(_verifyEmail(email)){
      throw Exception('Email already exists');
    }

    users.add({
      'email': email,
      'password': password
    });

  }

  bool checkUser(String email, String password) {
    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        return true;
      }
    }
    return false;
  }

  bool _verifyPass(String password) {
    if((password.length > 6) && 
        password.contains(RegExp(r'[A-Z]')) && 
        password.contains(RegExp(r'[0-9]')) && 
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_-]')) && 
        password.contains(RegExp(r'[a-z]'))) {
      return true;
    }
    return false;
  }

  bool _verifyEmail(String email) {
    for (var user in users) {
      if (user['email'] == email) {
        return true;
      }
    }
    return false;
  }

  Users copyWith({
    List ? users
  }){
    return Users(
      users: users ?? this.users,
      );
  }

}
