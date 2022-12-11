import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/shared/app_settings.dart';
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

  late Future<bool> _getAsyncInitialValuesFuture;

  final Map<AdaptiveThemeMode, String> _themeOptions = {
    AdaptiveThemeMode.system: "Sistema",
    AdaptiveThemeMode.dark: "Modo escuro",
    AdaptiveThemeMode.light: "Modo claro"
  };
  late String _currentTheme;

  final Map<PhoneToolsOption, String> _phoneToolsOptions = {
    PhoneToolsOption.none: "Nenhum botão",
    PhoneToolsOption.onlyWhatsapp: "Somente botão de WhatsApp",
    PhoneToolsOption.onlyCall: "Somente botão de ligação",
    PhoneToolsOption.both: "Ambos botões"
  };
  late String _currentPhoneToolsOption;

  @override
  void initState() {
    super.initState();

    _getAsyncInitialValuesFuture = _getAsyncInitialValues();
  }

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
    return FutureBuilder(
      future: _getAsyncInitialValuesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildPage();
        } else {
          return Container(
            color: const Color.fromARGB(102, 158, 158, 158),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildPage() {
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
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
              child: Text("Ferramentas para telefone:", style: _keyTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 0.0),
              child: DropdownButton(
                value: _currentPhoneToolsOption,
                isExpanded: true,
                items: _phoneToolsOptions.values
                    .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value, style: _valueTextStyle)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _currentPhoneToolsOption = value!;
                  });
                  AppSettings.setPhoneToolsOptions(_phoneToolsOptions.keys
                      .firstWhere((k) => _phoneToolsOptions[k] == value));
                },
              ),
            )
          ]),
        ],
      ),
    );
  }

  Future<bool> _getAsyncInitialValues() async {
    _currentPhoneToolsOption = _phoneToolsOptions[
        await AppSettings.getPhoneToolsOptions()
            .timeout(const Duration(seconds: 10))]!;
    return true;
  }
}
