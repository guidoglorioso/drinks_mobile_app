import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ConfigScreen2 extends StatefulWidget {
  const ConfigScreen2({super.key});

  @override
  State<ConfigScreen2> createState() => _ConfigScreenState2();
}


class _ConfigScreenState2 extends State<ConfigScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Configuration')),
      body: MenuItems(),
    );
  }
}
enum Usuario{
    avanzado,
    medio,
    aprendiz,
}

class MenuItems extends StatefulWidget {
  const MenuItems({super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  Usuario userTileChecked = Usuario.avanzado;
  bool isDeveloperMode = true;
  bool checkBoxMode = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        Card(

          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SwitchListTile(
            title: Text('Opcion 1'),
            value: isDeveloperMode, 
            onChanged: (value){
              setState((){
                 isDeveloperMode = value; 
              });
            }),
        ),
        SizedBox(height: 10,),

        Card(

          margin: EdgeInsets.symmetric(horizontal: 20),
      
          child: ExpansionTile(
            title: Text('Usuario'),
            subtitle: Text('Tipo de perfil'),
            children: [
              RadioListTile<Usuario>(
                title: Text('Avanzado'),
                value: Usuario.avanzado,
                groupValue: userTileChecked,
                onChanged: (value){
                  setState(() {
                    userTileChecked = value!;
                  });
                } 
              ),
              RadioListTile<Usuario>(
                title: Text('Medio'),
                value: Usuario.medio,
                groupValue: userTileChecked,
                onChanged: (value){
                  setState(() {
                    userTileChecked = value!;
                  });
                } 
              ),
              RadioListTile<Usuario>(
                title: Text('Aprendiz'),
                value: Usuario.aprendiz,
                groupValue: userTileChecked,
                onChanged: (value){
                  setState(() {
                    userTileChecked = value!;
                  });
                } 
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Card(

          margin: EdgeInsets.symmetric(horizontal: 20), 
          child: CheckboxListTile(
            title: Text("Habilitar modo alcoholico"),
            value: checkBoxMode, 
            onChanged: (value){
              setState(() {
                checkBoxMode = value!;
              });
            }
          ),
        ),
        SizedBox(height: 20),
        Divider(  
          thickness: 1.5,
          indent: 60,      // Espacio vacío al inicio (izquierda)
          endIndent: 60
          ),   // Espacio vacío al final (derecha) ),
        SizedBox(height: 20),
        Card(

          margin: EdgeInsets.symmetric(horizontal: 20), 
          child: ListTile(
            title: Text('Paleta de colores'),
            onTap: () => context.push('/color-palette'),
          ),
        ),
      ],
    );
  }
}


