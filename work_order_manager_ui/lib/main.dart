import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/work_order_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sevencar Organizador',
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              filled: true, fillColor: Color.fromARGB(255, 255, 255, 255)),
          colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
          scaffoldBackgroundColor: const Color.fromARGB(255, 226, 226, 226)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87)),
      themeMode: ThemeMode.system,
      home: const WorkOrderUi(),
    );
  }
}
