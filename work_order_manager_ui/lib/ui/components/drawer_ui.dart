import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/tools/authentication_manager.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';

class DrawerUi extends StatelessWidget {
  const DrawerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FocusTraversalGroup(
      child: ListView(
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              child: Column(children: [
                Expanded(
                  child: ClipOval(
                      child: Container(
                          color: Theme.of(context).highlightColor,
                          child: Image.asset('sevencar_mascot.png'))),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: "Deslogar",
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (context) =>
                                _buildLogoutAlertDialog(context))))
              ]),
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
      ),
    ));
  }

  Widget _buildLogoutAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Deslogar"),
      content: const Text("Tem certeza que deseja deslogar?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.login);
              AuthenticationManager.clearAuth();
            },
            child: const Text("Sim")),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("Não"))
      ],
    );
  }

  void _onTap(BuildContext context, String route) {
    if (ModalRoute.of(context)!.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.maybePop(context);
    }
  }
}
