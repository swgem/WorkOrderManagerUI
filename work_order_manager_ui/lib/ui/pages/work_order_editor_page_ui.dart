import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/stream/work_order_editor_event.dart';
import 'package:work_order_manager_ui/ui/components/work_order_editor_ui.dart';

class WorkOrderEditorPageUi extends StatefulWidget {
  final WorkOrder? workOrder;

  const WorkOrderEditorPageUi({super.key, this.workOrder});

  @override
  State<WorkOrderEditorPageUi> createState() => _WorkOrderEditorPageUiState();
}

class _WorkOrderEditorPageUiState extends State<WorkOrderEditorPageUi> {
  late final StreamController<WorkOrderEditorEvent> eventController;

  @override
  void initState() {
    super.initState();

    eventController = StreamController<WorkOrderEditorEvent>.broadcast();
  }

  @override
  void dispose() {
    super.dispose();

    eventController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildForm(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Nova ordem de serviço'));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () =>
            eventController.sink.add(WorkOrderEditorEvent.saveWorkOrder),
        tooltip: "Salvar ordem de serviço",
        child: const Icon(Icons.save));
  }

  Widget _buildForm() {
    return WorkOrderEditorUi(
        parentEvent: eventController.stream, workOrder: widget.workOrder);
  }
}
