import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/events/work_order_list_event_type.dart';
import 'package:work_order_manager_ui/ui/work_order_inserter_ui.dart';
import 'package:work_order_manager_ui/ui/work_order_list_ui.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  final StreamController<WorkOrderListEventType> workOrderListEventController =
      StreamController<WorkOrderListEventType>.broadcast();

  @override
  void dispose() {
    workOrderListEventController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: WorkOrderListUi(
          parentEvent: workOrderListEventController.stream,
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('LISTA DE ORDENS DE SERVIÇO'));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          navigateToWorkOrderInserter();
        },
        child: const Icon(Icons.add));
  }

  Future navigateToWorkOrderInserter() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderInserterUi()))).then(
        (value) => workOrderListEventController.sink
            .add(WorkOrderListEventType.refetchList));
  }
}
