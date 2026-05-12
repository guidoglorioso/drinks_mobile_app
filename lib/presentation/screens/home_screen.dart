import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/presentation/providers/drinks_provider.dart';

// widget principal
class HomeScreen extends ConsumerStatefulWidget {

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends ConsumerState<HomeScreen>{

  @override
  Widget build(BuildContext context) {

    //final textStyle = Theme.of(context).textTheme;
    final drinks = ref.watch(appDrinksProvider).drinks;
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('FuckinDrinks!!'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
            onPressed: () => context.push('/config'), 
            icon: Icon(Icons.settings),
            iconSize: 35,
            highlightColor: Colors.grey[300],
            ),
          ),
        ],
      
        ),

      body: _DrinkList(drinks: drinks ),
      floatingActionButton: SearchBarManager(),
      );
  }
}

class SearchBarManager extends ConsumerStatefulWidget {


  const SearchBarManager({super.key});

  @override
  ConsumerState<SearchBarManager> createState() => _SearchBarManager();

}

class _SearchBarManager extends ConsumerState<SearchBarManager>{
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
              onSubmitted: (value){
                hideSearchBar();
                value == '' ? 
                    ref.read(appDrinksProvider.notifier).getAllDrinks() : 
                    ref.read(appDrinksProvider.notifier).filterByName(value);
               
              },
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

  const _DrinkList({required this.drinks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) => _ItemDrink(drink: drinks[index]),
    );
  }
}

class _ItemDrink extends ConsumerWidget {
  final Drink drink;

  const _ItemDrink({required this.drink});

  @override
  Widget build(BuildContext context,ref) {
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
                    ref.read(appDrinksProvider.notifier).removeDrinkNotifier( drink.id );
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

