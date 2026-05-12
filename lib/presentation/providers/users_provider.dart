import 'package:flutter_riverpod/legacy.dart';
import 'package:login_app/domain/repository_drinks.dart';
import 'package:login_app/domain/users.dart';


final appUserProvider = StateNotifierProvider<AppUserNotifier,Users>((ref,){
  return AppUserNotifier();
}
);

class AppUserNotifier extends StateNotifier<Users>{
  
  AppUserNotifier() : super(Users(users: bdUsers)); // valor por defecto en la aplicacion.

  void addUser(String name, String password){

    state.insertUser(name,password);
    List buff= state.users;
    state = state.copyWith(users: buff);
  }
  
  void removeUser(){

  }

  void getAllUsers(){
    state = state.copyWith(users: bdDrinks);
  }



}