import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';

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
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Início"),
          onTap: () => _onTap(context, Routes.home),
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text("Ordens de serviço"),
          onTap: () => _onTap(context, Routes.workOrders),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Preferências"),
          onTap: () => _onTap(context, Routes.settings),
        )
      ],
    ));
  }

  void _onTap(BuildContext context, String route) {
    if (ModalRoute.of(context)!.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.maybePop(context);
    }
  }
}
