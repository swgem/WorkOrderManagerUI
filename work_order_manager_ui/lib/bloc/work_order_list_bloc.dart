import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/api/work_order_api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class WorkOrderListBloc extends Bloc<WorkOrderListEvent, WorkOrderListState> {
  List<String>? workOrderStatusFilter;
  List<WorkOrder>? workOrders;

  WorkOrderListBloc() : super(WorkOrderListLoadingState()) {
    on<WorkOrderListFetchEvent>((event, emit) async {
      emit(WorkOrderListLoadingState());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(await _fetchFilteredWorkOrders());
    });

    on<WorkOrderListLoadStatusFilterEvent>(
        (event, emit) => workOrderStatusFilter = event.status);

    on<WorkOrderSearchEvent>((event, emit) {
      emit(_searchWorkOrders(event.text));
    });

    on<WorkOrderCancelSearchEvent>((event, emit) {
      if (workOrders != null && workOrders!.isNotEmpty) {
        emit(WorkOrderListSucessState(workOrders: workOrders!));
      } else {
        emit(WorkOrderListEmptyState());
      }
    });

    on<WorkOrderListClearEvent>((event, emit) {
      workOrders = null;
      emit(WorkOrderListBlankState());
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

  Future<WorkOrderListState> _fetchFilteredWorkOrders() async {
    try {
      if (workOrderStatusFilter == null) {
        workOrders = await WorkOrderApiServices.fetchAllWorkOrders();
      } else {
        workOrders = await WorkOrderApiServices.fetchWorkOrdersFilteredByStatus(
            workOrderStatusFilter!);
        workOrders!.sort(_sortWorkOrdersByStatus);
      }

      if (workOrders!.isEmpty) {
        return WorkOrderListEmptyState();
      } else {
        return WorkOrderListSucessState(workOrders: workOrders!);
      }
    } catch (e) {
      workOrders = null;
      return WorkOrderListErrorState(message: e.toString());
    }
  }

  WorkOrderListState _searchWorkOrders(String text) {
    List<WorkOrder>? searchResult;

    // Simplified because case is forced low to ignore case and
    // diacritics are ignored
    var simplifiedText = removeDiacritics(text).toLowerCase();
    var searchTextList = simplifiedText.split(" ");

    if (workOrders != null) {
      searchResult = workOrders!.where((element) {
        var simplifiedClient = removeDiacritics(element.client).toLowerCase();
        var simplifiedVehicle = removeDiacritics(element.vehicle).toLowerCase();
        var simplifiedVehiclePlate = element.vehiclePlate?.toLowerCase() ?? "";
        var simplifiedPhone =
            element.phone?.replaceAll(RegExp(r"\D"), "") ?? "";

        bool valid = true;

        for (var searhText in searchTextList) {
          if (simplifiedClient.contains(searhText) ||
              simplifiedVehicle.contains(searhText) ||
              simplifiedVehiclePlate.contains(searhText) ||
              simplifiedPhone.contains(searhText)) {
            valid &= true;
          } else {
            valid = false;
          }
        }

        return valid;
      }).toList();
    }

    if (searchResult != null && searchResult.isNotEmpty) {
      return WorkOrderListSucessState(workOrders: searchResult);
    } else {
      return WorkOrderListEmptyState();
    }
  }
}
