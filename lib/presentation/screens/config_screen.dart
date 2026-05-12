import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}


class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Configuration'),
        actions:[
          IconButton(
            onPressed: () => context.push('/config2'), 
            icon: Icon(Icons.arrow_circle_right))
        ] ,
      ),
      body: ListView.builder(
        itemCount: configMenu.length,
        itemBuilder: (context, index) => Item(itemRecived: configMenu[index]),
      ),
    );
  }
}

class Item extends StatelessWidget {
  
  final MenuItem itemRecived;
  
  const Item({
    super.key,
    required this.itemRecived,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemRecived.title),
      subtitle: Text(itemRecived.subtitle),
      leading: Icon(itemRecived.icon),
      onTap: () => showAboutDialog(
        context: context,
        children: [
          Text(('Prueba  ') + itemRecived.subtitle ),
        ]
        ),
    );
  }
}


class MenuItem{
  String title;
  String subtitle;
  IconData icon;
  String path;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.path
  }); 
}

final List <MenuItem> configMenu = [
  MenuItem (
    title: 'Config1',
    subtitle: 'Subtitle1',
    icon: Icons.search,
    path: '',
  ),
  MenuItem (
    title: 'Config2',
    subtitle: 'Subtitle2',
    icon: Icons.access_alarms,
    path: '',
  ),
  MenuItem (
    title: 'Config3',
    subtitle: 'Subtitle3',
    icon: Icons.accessible_forward_outlined,
    path: '',
  ),
  MenuItem (
    title: 'Config4',
    subtitle: 'Subtitle4',
    icon: Icons.account_balance_wallet_outlined,
    path: '',
  ),

];