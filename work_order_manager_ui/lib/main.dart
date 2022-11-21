import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/ui/pages/home_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/login_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';
import 'package:work_order_manager_ui/ui/pages/settings_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_orders_page_ui.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WorkOrderListBloc>(
            create: (context) => WorkOrderListBloc()),
        BlocProvider<WorkOrderEditorBloc>(
            create: (context) => WorkOrderEditorBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
            colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
            scaffoldBackgroundColor: const Color.fromARGB(255, 226, 226, 226),
            inputDecorationTheme: const InputDecorationTheme(
                filled: true, fillColor: Color.fromARGB(255, 255, 255, 255)),
            expansionTileTheme: const ExpansionTileThemeData(
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent),
            dividerColor: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        dark: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
            expansionTileTheme: const ExpansionTileThemeData(
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent),
            dividerColor: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              title: 'SEVENCAR ORGANIZADOR',
              theme: theme,
              darkTheme: darkTheme,
              routes: {
                Routes.login: (context) => const LoginPageUi(),
                Routes.home: (context) => const HomePageUi(),
                Routes.workOrders: (context) => const WorkOrdersPageUi(),
                Routes.settings: (context) => const SettingsPageUi()
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('pt', 'BR'),
                Locale('de')
              ],
              initialRoute: Routes.login,
            ));
  }
}
