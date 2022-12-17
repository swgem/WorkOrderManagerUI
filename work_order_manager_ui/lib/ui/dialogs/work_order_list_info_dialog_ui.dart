import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';

class WorkOrderListInfoDialogUi extends StatelessWidget {
  const WorkOrderListInfoDialogUi({super.key});

  @override
  Widget build(BuildContext context) {
    int waitingWorkOrderNumber = 0;
    int ongoingWorkOrderNumber = 0;
    int finishedWorkOrderNumber = 0;
    int cancelledWorkOrderNumber = 0;

    bool showWaitingWorkOrder;
    bool showOngoingWorkOrder;
    bool showFinishedWorkOrder;
    bool showCancelledWorkOrder;

    var currState = BlocProvider.of<WorkOrderListBloc>(context).state;
    var statusFilter =
        BlocProvider.of<WorkOrderListBloc>(context).workOrderStatusFilter;

    if (statusFilter == null) {
      showWaitingWorkOrder = true;
      showOngoingWorkOrder = true;
      showFinishedWorkOrder = true;
      showCancelledWorkOrder = true;
    } else {
      showWaitingWorkOrder = statusFilter.contains(WorkOrderStatus.waiting);
      showOngoingWorkOrder = statusFilter.contains(WorkOrderStatus.ongoing);
      showFinishedWorkOrder = statusFilter.contains(WorkOrderStatus.finished);
      showCancelledWorkOrder = statusFilter.contains(WorkOrderStatus.cancelled);
    }

    if (currState is WorkOrderListSucessState) {
      waitingWorkOrderNumber = currState.workOrders
          .where((element) => (element.status == WorkOrderStatus.waiting.name))
          .length;
      ongoingWorkOrderNumber = currState.workOrders
          .where((element) => (element.status == WorkOrderStatus.ongoing.name))
          .length;
      finishedWorkOrderNumber = currState.workOrders
          .where((element) => (element.status == WorkOrderStatus.finished.name))
          .length;
      cancelledWorkOrderNumber = currState.workOrders
          .where(
              (element) => (element.status == WorkOrderStatus.cancelled.name))
          .length;
    }

    return Dialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text("Quantidade de ordens de serviço",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Visibility(
              visible: showWaitingWorkOrder,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WorkOrderStatus.waiting.color(context)),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text("Em espera: $waitingWorkOrderNumber",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Visibility(
              visible: showOngoingWorkOrder,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WorkOrderStatus.ongoing.color(context)),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text("Em andamento: $ongoingWorkOrderNumber",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Visibility(
              visible: showFinishedWorkOrder,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WorkOrderStatus.finished.color(context)),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text("Finalizadas: $finishedWorkOrderNumber",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Visibility(
              visible: showCancelledWorkOrder,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WorkOrderStatus.cancelled.color(context)),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text("Canceladas: $cancelledWorkOrderNumber",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )),
        ),
      ],
    ));
  }
}
