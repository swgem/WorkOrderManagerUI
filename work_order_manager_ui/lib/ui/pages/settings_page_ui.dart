import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';

class SettingsPageUi extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingsPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(), drawer: const DrawerUi(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        title:
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: const [
      Text('Preferências'),
    ]));
  }

  Widget _buildBody() {
    return Container();
  }
}
