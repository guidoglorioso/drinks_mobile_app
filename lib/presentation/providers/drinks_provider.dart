import 'package:flutter_riverpod/legacy.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/domain/repository_drinks.dart';


final appDrinksProvider = StateNotifierProvider<AppDrinksNotifier,RepositoryDrinks>((ref,){
  return AppDrinksNotifier();
}
);

class AppDrinksNotifier extends StateNotifier<RepositoryDrinks>{
  
  AppDrinksNotifier() : super(RepositoryDrinks(drinks: bdDrinks)); // valor por defecto en la aplicacion.

  void removeDrinkNotifier(String idStr){
   
    state.deleteDrink(idStr);
    
    List<Drink> buff= state.getList(); 

    state = state.copyWith(drinks: buff);
  }

  void filterByName(String name){
    final buff = state.searchByName(name);
    state = state.copyWith(drinks: buff);
  }

  void getAllDrinks(){
    state = state.copyWith(drinks: bdDrinks);
  }



}