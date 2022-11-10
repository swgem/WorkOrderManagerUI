import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_list_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';

class HomePageUi extends StatefulWidget {
  static const String routeName = '/homePage';
  const HomePageUi({super.key});

  @override
  State<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi> {
  final List<String> _workOrderStatus = ["waiting", "ongoing"];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorkOrderListBloc>(context)
        .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        drawer: const DrawerUi(),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Text('Início'),
      const Spacer(),
      IconButton(
          onPressed: () => BlocProvider.of<WorkOrderListBloc>(context)
              .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus)),
          icon: const Icon(Icons.refresh))
    ]));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          _navigateToWorkOrderInserter();
        },
        tooltip: "Adicionar ordem de serviço",
        child: const Icon(Icons.add));
  }

  Widget _buildBody() {
    return BlocListener(
        bloc: BlocProvider.of<WorkOrderListBloc>(context),
        listener: (context, state) {
          if (state is WorkOrderListErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message.toString()),
                duration: const Duration(seconds: 5)));
          }
        },
        child: WorkOrderListUi(
          workOrderStatus: _workOrderStatus,
        ));
  }

  Future _navigateToWorkOrderInserter() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderEditorPageUi()))).then(
        (value) => BlocProvider.of<WorkOrderListBloc>(context)
            .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus)));
  }
}