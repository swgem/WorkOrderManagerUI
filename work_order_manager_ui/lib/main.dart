import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/home_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEVENCAR ORGANIZADOR',
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
          scaffoldBackgroundColor: const Color.fromARGB(255, 226, 226, 226),
          inputDecorationTheme: const InputDecorationTheme(
              filled: true, fillColor: Color.fromARGB(255, 255, 255, 255)),
          expansionTileTheme: const ExpansionTileThemeData(
              collapsedBackgroundColor: Colors.white,
              backgroundColor: Colors.white),
          dividerColor: Colors.transparent),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
          expansionTileTheme: ExpansionTileThemeData(
              collapsedBackgroundColor: Theme.of(context).highlightColor,
              backgroundColor: Theme.of(context).highlightColor),
          dividerColor: Colors.transparent),
      home: const HomeUi(),
    );
  }
}
