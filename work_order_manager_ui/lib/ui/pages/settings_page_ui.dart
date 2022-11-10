import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/pages/responsive_page_ui.dart';

class SettingsPageUi extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingsPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePageUi(
      appBar: _buildAppBar(),
      mobileBody: _buildBody(),
      tabletBody: _buildBody(),
      desktopBody: _buildBody(),
      mobileFloatingActionButton: _buildFloatingActionButton(),
      tabletFloatingActionButton: _buildFloatingActionButton(),
      desktopFloatingActionButton: _buildFloatingActionButton(),
      mobileDrawer: const DrawerUi(),
      tabletDrawer: const DrawerUi(),
      desktopDrawer: const DrawerUi(),
    );
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {}, tooltip: "Salvar", child: const Icon(Icons.save));
  }
}
