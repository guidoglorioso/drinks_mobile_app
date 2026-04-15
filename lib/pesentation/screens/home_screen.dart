import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/domain/repository_drinks.dart';


class HomeScreen extends StatelessWidget {

  final String userEmail;

  const HomeScreen({super.key, required this.userEmail}); 

  @override
  Widget build(BuildContext context) {
    //final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('FuckinDrinks!!'),),
      body: _DrinksList(drinks: RepositoryDrinks().drinks),
    );
  }
}

class _DrinksList extends StatelessWidget {
  final List<Drink> drinks;
  const _DrinksList({
    super.key,
    required this.drinks,
  });
  
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

  const _ItemDrink({
    super.key,
    required this.drink
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 120,
        child: ListTile(
          title: Text(drink.name),
          subtitle: Text(drink.method),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              drink.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => context.push('/detail', extra: drink),
        ),
      ),
    );
  }
}