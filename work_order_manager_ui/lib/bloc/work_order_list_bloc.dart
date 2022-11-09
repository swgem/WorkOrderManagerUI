import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class WorkOrderListBloc extends Bloc<WorkOrderListEvent, WorkOrderListState> {
  // final _workOrdersMock = [
  //   WorkOrder(
  //     client: 'Claudinelson',
  //     status: 'waiting',
  //     dayId: 1,
  //     priority: 0,
  //     telephone: '15 3127 1543',
  //     clientRequest: 'Alinhamento e balanceamento',
  //     orderOpeningDatetime: '01/11/2022 7:51:37',
  //     vehicle: 'Porsche',
  //   ),
  //   WorkOrder(
  //       client: 'Elton da marmoraria Henriques',
  //       status: 'ongoing',
  //       dayId: 2,
  //       priority: 1,
  //       telephone: '+12 47 95471 3150',
  //       clientRequest:
  //           'Troca dos amortecedores. Vazamento de óleo. Ventoinha não está ligando',
  //       orderOpeningDatetime: '01/11/2022 9:35:10',
  //       vehicle: 'Strada Endurance cabine dupla',
  //       remarks: 'Bateu o carro em um poste')
  // ];

  WorkOrderListBloc() : super(WorkOrderListLoadingState()) {
    on<WorkOrderListFetchEvent>((event, emit) async {
      emit(WorkOrderListLoadingState());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(await _fetchWorkOrders());
    });
    on<WorkOrderListFetchByStatusEvent>((event, emit) async {
      emit(WorkOrderListLoadingState());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(await _fetchWorkOrderByStatus(event.status));
    });
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

  Future<WorkOrderListState> _fetchWorkOrders() async {
    try {
      List<WorkOrder> workOrders = await ApiServices.fetchAllWorkOrders();
      // List<WorkOrder> workOrders =
      //     await Future.delayed(Duration(seconds: 5), () => _workOrdersMock);

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

  Future<WorkOrderListState> _fetchWorkOrderByStatus(
      List<String>? status) async {
    if (status == null || status.isEmpty) {
      return _fetchWorkOrders();
    }
    try {
      List<WorkOrder> workOrders = await ApiServices.fetchAllWorkOrders();
      // List<WorkOrder> workOrders =
      //     await Future.delayed(Duration(seconds: 5), () => _workOrdersMock);

      workOrders.removeWhere((element) => !status.contains(element.status));
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
