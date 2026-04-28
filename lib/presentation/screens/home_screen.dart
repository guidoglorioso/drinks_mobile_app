import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/domain/repository_drinks.dart';

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

  void actualizarLista( List<Drink> newDrinks) {
    setState(() {
      drinks = newDrinks;
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    //final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('FuckinDrinks!!')),
      body: _DrinkList(drinks: drinks),
      
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
