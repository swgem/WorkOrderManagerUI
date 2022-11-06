import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/ui/home_ui.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<WorkOrderListBloc>(
        create: (context) =>
            WorkOrderListBloc()..add(WorkOrderListFetchEvent()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent),
          dividerColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color.fromARGB(255, 11, 163, 87),
          expansionTileTheme: const ExpansionTileThemeData(
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent),
          dividerColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      home: const HomeUi(),
    );
  }
}
