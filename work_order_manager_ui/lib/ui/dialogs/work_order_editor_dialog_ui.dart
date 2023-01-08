import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';
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
        }
      },
      child: Container(
          constraints: const BoxConstraints(maxWidth: 650, maxHeight: 800),
          child: LoaderOverlay(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: _buildTitle(),
                ),
                Expanded(child: WorkOrderEditorUi(workOrder: widget.workOrder)),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              BlocProvider.of<WorkOrderEditorBloc>(context)
                                  .add(WorkOrderEditorRequestSaveEvent()),
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

  Widget _buildTitle() {
    if (widget.workOrder == null) {
      return Text(_getTitleText(),
          style: Theme.of(context).textTheme.titleLarge);
    } else {
      Color statusColor =
          WorkOrderStatusExtension.fromString(widget.workOrder!.status)!
              .color(context);
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: statusColor),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
                child: Text(_getTitleText(),
                    style: Theme.of(context).textTheme.titleLarge)),
          ],
        ),
      );
    }
  }

  String _getTitleText() {
    return (widget.workOrder == null)
        ? "Nova ordem de serviço"
        : "Editando ordem #${widget.workOrder!.dayId.toString().padLeft(2, '0')} de ${widget.workOrder!.orderOpeningDatetime.split(" ")[0]}";
  }
}
