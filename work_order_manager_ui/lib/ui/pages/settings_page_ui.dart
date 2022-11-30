import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/pages/responsive_page_ui.dart';

class SettingsPageUi extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPageUi({super.key});

  @override
  State<SettingsPageUi> createState() => _SettingsPageUiState();
}

class _SettingsPageUiState extends State<SettingsPageUi> {
  late TextStyle _keyTextStyle;
  late TextStyle _valueTextStyle;

  final Map<AdaptiveThemeMode, String> _themeOptions = {
    AdaptiveThemeMode.system: "Sistema",
    AdaptiveThemeMode.dark: "Modo escuro",
    AdaptiveThemeMode.light: "Modo claro"
  };
  late String _currentTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _keyTextStyle = Theme.of(context).textTheme.bodyLarge!;
    _valueTextStyle = Theme.of(context).textTheme.bodyMedium!;
    _currentTheme = _themeOptions[AdaptiveTheme.of(context).mode]!;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageUi(
      mobileAppBar: _buildAppBar(),
      tabletAppBar: _buildAppBar(),
      desktopAppBar: _buildAppBar(),
      mobileBody: _buildBody(),
      tabletBody: _buildBody(),
      desktopBody: _buildBody(),
      mobileFloatingActionButton: null,
      tabletFloatingActionButton: null,
      desktopFloatingActionButton: null,
      mobileDrawer: const DrawerUi(),
      tabletDrawer: const DrawerUi(),
      desktopDrawer: const DrawerUi(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Preferências'));
  }

  Widget _buildBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1)
        },
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
              child: Text("Tema do aplicativo:", style: _keyTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 0.0),
              child: DropdownButton(
                value: _currentTheme,
                isExpanded: true,
                items: _themeOptions.values
                    .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value, style: _valueTextStyle)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _currentTheme = value!;
                  });
                  AdaptiveTheme.of(context).setThemeMode(_themeOptions.keys
                      .firstWhere((k) => _themeOptions[k] == value));
                },
              ),
            )
          ]),
        ],
      ),
    );
  }
}
