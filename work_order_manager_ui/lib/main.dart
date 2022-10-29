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
      title: 'Flutter Demo',
      theme: ThemeData(
          colorSchemeSeed: Color.fromARGB(255, 11, 163, 87),
          scaffoldBackgroundColor: Color.fromARGB(255, 226, 226, 226)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Color.fromARGB(255, 11, 163, 87)),
      themeMode: ThemeMode.system,
      home: const WorkOrderUi(),
    );
  }
}
