import 'package:flutter/material.dart';
import 'package:login_app/domain/drink.dart';

class DetailScreen extends StatelessWidget {
  final Drink drink;

  const DetailScreen({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    var styleTheme = Theme.of(context).textTheme;

    return Container(
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            SizedBox(
              height: 60,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(drink.name, style: styleTheme.displayMedium),
              ),
            ),
            const SizedBox(height: 30),

            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: drink.imageUrl.isEmpty
                  ? Container(width: 300, height: 500, color: Colors.white)
                  : Image.network(drink.imageUrl, height: 500),
            ),
            SizedBox(height: 30),

            _InformationDrink(drink: drink),
          ],
        ),
      ),
    );
  }
}

class _InformationDrink extends StatelessWidget {
  final Drink drink;
  const _InformationDrink({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    // Lista horizontal con altura fija para evitar problemas de medida
    final items = [
      _ItemInformationDrink(
        title: 'Ingredients',
        description: drink.ingredients,
      ),
      _ItemInformationDrink(title: 'Method', description: drink.method),
      _ItemInformationDrink(title: 'Garnish', description: drink.garnish),
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(width: 330, child: items[index]),
            ),
          );
        },
      ),
    );
  }
}

class _ItemInformationDrink extends StatelessWidget {
  const _ItemInformationDrink({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;

  final String description;

  @override
  Widget build(BuildContext context) {
    var styleTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: styleTheme.headlineSmall),
              const SizedBox(height: 8.0),
              Text(description, style: styleTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
