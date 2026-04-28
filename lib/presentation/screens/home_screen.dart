import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/domain/repository_drinks.dart';

// widget principal
class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  late List<Drink> drinks;

  @override
  void initState() {
    super.initState();
    drinks = RepositoryDrinks.drinks; // valor inicial
  }

  void searchDrinks( String busqueda) {
    setState(() {
      drinks = RepositoryDrinks().searchByName(busqueda); 
      }
    );
  }

  void updateDrinks( List<Drink> drinksList){
    setState(() {
      drinks = drinksList; 
    });
  }

  @override
  Widget build(BuildContext context) {
    //final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('FuckinDrinks!!')),
      body: _DrinkList(drinks: drinks,onUpdate: (drinksList) => updateDrinks(drinksList) ),
      floatingActionButton: SearchBarManager(onUpdate: (drinksList) => updateDrinks(drinksList) ,),
      );
  }
}

class SearchBarManager extends StatefulWidget {
    
  final Function(List<Drink>) onUpdate;

  const SearchBarManager({super.key,required this.onUpdate});

  @override
  State<SearchBarManager> createState() => _SearchBarManager();

}

class _SearchBarManager extends State<SearchBarManager>{
  OverlayEntry? _overlayEntry;
  final FocusNode _searchFocusNode = FocusNode();

  void showSearchBar(){
    
    if(_overlayEntry == null){
      _overlayEntry = createSearchBar(context);
      Overlay.of(context).insert(_overlayEntry!);

      // foco en el cuadro de busqueda
      _searchFocusNode.requestFocus();
    }

  }

  void hideSearchBar(){

    if(_overlayEntry != null){
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    
  }

  void submitedSearchBar(String busqueda){
    hideSearchBar();
    List<Drink> buff = RepositoryDrinks().searchByName(busqueda);
    widget.onUpdate(buff);

  }

  @override
  Widget build(BuildContext context) {
      return FloatingActionButton(
        onPressed: showSearchBar,
        child: Icon(Icons.search),
        );
  }

  OverlayEntry createSearchBar(BuildContext context){
    return OverlayEntry(
      builder: (context) => Stack(

        // Primer widget
        children: [
          GestureDetector(
            onTap:  () => hideSearchBar(), 
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
              child: Container(
                color: Colors.transparent.withOpacity(0.1),
              ),
            ),
          ),
        
        // Segundo widget
        Positioned(
          bottom: MediaQuery.of(context).size.height / 2,
          left: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.transparent,
            child: SearchBar(
              focusNode: _searchFocusNode,
              hintText: "Busqueda", 
              onSubmitted: (value) => submitedSearchBar(value),
            ),
          ),
        ),
        ], 
      ),
    );
  }

}


class _DrinkList extends StatelessWidget {
  final List<Drink> drinks;
  final Function(List <Drink>) onUpdate;

  const _DrinkList({super.key, required this.drinks,required this.onUpdate});

  void pressOnCard(String id){  
    RepositoryDrinks().deleteDrink(id);
    onUpdate(RepositoryDrinks.drinks);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) => _ItemDrink(drink: drinks[index],longPressAction: pressOnCard,),
    );
  }
}

class _ItemDrink extends StatelessWidget {
  final Drink drink;
  final Function(String) longPressAction;

  const _ItemDrink({super.key, required this.drink,required this.longPressAction});

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        minTileHeight: 80,
        title: Text(drink.name, style: textStyle.titleLarge),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: drink.imageUrl.isEmpty
              ? Container(width: 40, height: 60, color: Colors.white)
              : Image.network(
                  drink.imageUrl,
                  height: 60,
                  width: 40,
                  fit: BoxFit.cover,
                ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => context.push('/detail', extra: drink),
        onLongPress: (){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title : Text('Delete Item'),
              content: Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                FilledButton(
                  onPressed: (){
                    Navigator.pop(context);
                    longPressAction(drink.id);
                  },
                  child: Text('Delete'),
                ),
              ] 
            ),
          );
        },
      ),
    );
  }
}

