import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/components/work_order_editor_ui.dart';

class WorkOrderEditorDialogUi extends StatefulWidget {
  final WorkOrder? workOrder;

  const WorkOrderEditorDialogUi({super.key, required this.workOrder});

  @override
  State<WorkOrderEditorDialogUi> createState() =>
      _WorkOrderEditorDialogUiState();
}

class _WorkOrderEditorDialogUiState extends State<WorkOrderEditorDialogUi> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: BlocListener<WorkOrderEditorBloc, WorkOrderEditorState>(
      bloc: BlocProvider.of(context),
      listener: (context, state) {
        if (state is WorkOrderEditorSavedState) {
          BlocProvider.of<WorkOrderListBloc>(context)
              .add(WorkOrderListFetchEvent());
          Navigator.pop(context);
        } else if (state is WorkOrderEditorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            duration: const Duration(seconds: 5),
          ));
        }
      },
      child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 840),
          child: LoaderOverlay(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(_getTitleText(),
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Flexible(child: WorkOrderEditorUi(workOrder: widget.workOrder)),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              BlocProvider.of<WorkOrderEditorBloc>(context)
                                  .add(WorkOrderEditorSaveEvent()),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Salvar",
                                  style: TextStyle(fontSize: 20)))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).hintColor),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Descartar",
                                  style: TextStyle(fontSize: 20)))),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }

  String _getTitleText() {
    return (widget.workOrder == null)
        ? "Nova ordem de serviço"
        : "Ordem #${widget.workOrder!.dayId.toString().padLeft(2, '0')} de ${widget.workOrder!.orderOpeningDatetime.split(" ")[0]}";
    ;
  }
}
