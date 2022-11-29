import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/api/work_order_api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class WorkOrderListBloc extends Bloc<WorkOrderListEvent, WorkOrderListState> {
  List<String>? workOrderStatusFilter;

  WorkOrderListBloc() : super(WorkOrderListLoadingState()) {
    on<WorkOrderListFetchEvent>((event, emit) async {
      emit(WorkOrderListLoadingState());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(await _fetchFilteredWorkOrders());
    });

    on<WorkOrderListLoadStatusFilterEvent>(
        (event, emit) => workOrderStatusFilter = event.status);

    on<WorkOrderListClearEvent>(
        (event, emit) => emit(WorkOrderListBlankState()));
  }

  int _sortWorkOrdersByStatus(WorkOrder a, WorkOrder b) {
    final Map<String, int> workOrderStatusOrder = {
      "waiting": 1,
      "ongoing": 2,
      "finished": 3,
      "cancelled": 4
    };

    if (workOrderStatusOrder[a.status]! > workOrderStatusOrder[b.status]!) {
      return 1;
    } else if (workOrderStatusOrder[a.status]! <
        workOrderStatusOrder[b.status]!) {
      return -1;
    } else {
      return 0;
    }
  }

  Future<WorkOrderListState> _fetchFilteredWorkOrders() async {
    try {
      List<WorkOrder> workOrders;

      if (workOrderStatusFilter == null) {
        workOrders = await WorkOrderApiServices.fetchAllWorkOrders();
      } else {
        workOrders = await WorkOrderApiServices.fetchWorkOrdersFilteredByStatus(
            workOrderStatusFilter!);
      }

      workOrders.sort(_sortWorkOrdersByStatus);

      if (workOrders.isEmpty) {
        return WorkOrderListEmptyState();
      } else {
        return WorkOrderListSucessState(workOrders: workOrders);
      }
    } catch (e) {
      return WorkOrderListErrorState(message: e.toString());
    }
  }
}
