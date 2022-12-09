import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/components/work_order_editor_ui.dart';

class WorkOrderEditorPageUi extends StatefulWidget {
  final WorkOrder? workOrder;

  const WorkOrderEditorPageUi({super.key, this.workOrder});

  @override
  State<WorkOrderEditorPageUi> createState() => _WorkOrderEditorPageUiState();
}

class _WorkOrderEditorPageUiState extends State<WorkOrderEditorPageUi> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkOrderEditorBloc, WorkOrderEditorState>(
        bloc: BlocProvider.of(context),
        listener: (context, state) {
          if (state is WorkOrderEditorSavedState) {
            Navigator.pop(context);
            BlocProvider.of<WorkOrderEditorBloc>(context)
                .add(WorkOrderEditorClearEvent());
          } else if (state is WorkOrderEditorErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 5),
            ));
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: _buildFloatingActionButton(),
          body: LoaderOverlay(child: _buildForm()),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    String title = (widget.workOrder == null)
        ? "Nova ordem de serviço"
        : "Ordem #${widget.workOrder!.dayId.toString().padLeft(2, '0')} de ${widget.workOrder!.orderOpeningDatetime.split(" ")[0]}";

    return AppBar(
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Text(title)));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () => BlocProvider.of<WorkOrderEditorBloc>(context)
            .add(WorkOrderEditorSaveEvent()),
        tooltip: "Salvar ordem de serviço",
        child: const Icon(Icons.save));
  }

  Widget _buildForm() {
    return const WorkOrderEditorUi();
  }
}
