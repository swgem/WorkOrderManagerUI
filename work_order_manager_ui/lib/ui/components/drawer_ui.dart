import 'package:flutter/material.dart';

class DrawerUi extends StatelessWidget {
  const DrawerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: Text(
            "Menu",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const ListTile(
          leading: Icon(Icons.home),
          title: Text("Início"),
        ),
        const ListTile(
          leading: Icon(Icons.list),
          title: Text("Ordens de serviço"),
        ),
        const ListTile(
          leading: Icon(Icons.settings),
          title: Text("Preferências"),
        )
      ],
    ));
  }
}
