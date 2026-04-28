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
    drinks = RepositoryDrinks().drinks; // valor inicial
  }

  void searchDrinks( String busqueda) {
    setState(() {
      String busquedaLowerCase = busqueda.toLowerCase();
      List<Drink> drinksBuff = RepositoryDrinks().drinks;
      drinks = drinksBuff.where((ret) => ret.name.toLowerCase().contains(busquedaLowerCase)).toList();
    }
  );
  }


  @override
  Widget build(BuildContext context) {
    //final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('FuckinDrinks!!')),
      body: _DrinkList(drinks: drinks),
      floatingActionButton: SearchBarManager(onSearch: (busqueda) => searchDrinks(busqueda) ,),
      );
  }
}

class SearchBarManager extends StatefulWidget {
    
  final Function(String) onSearch;

  const SearchBarManager({super.key,required this.onSearch});

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
    widget.onSearch(busqueda);

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
  
  const _DrinkList({super.key, required this.drinks});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) => _ItemDrink(drink: drinks[index]),
    );
  }
}

class _ItemDrink extends StatelessWidget {
  final Drink drink;

  const _ItemDrink({super.key, required this.drink});

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
      ),
    );
  }
}

