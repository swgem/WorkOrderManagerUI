import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/api/work_order_api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';

class WorkOrderListBloc extends Bloc<WorkOrderListEvent, WorkOrderListState> {
  List<WorkOrderStatus>? workOrderStatusFilter;
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
    final Map<WorkOrderStatus, int> workOrderStatusOrder = {
      WorkOrderStatus.waiting: 1,
      WorkOrderStatus.ongoing: 2,
      WorkOrderStatus.finished: 3,
      WorkOrderStatus.cancelled: 4
    };

    var aStatus = WorkOrderStatusExtension.fromString(a.status);
    var bStatus = WorkOrderStatusExtension.fromString(b.status);

    if (workOrderStatusOrder[aStatus]! > workOrderStatusOrder[bStatus]!) {
      return 1;
    } else if (workOrderStatusOrder[aStatus]! <
        workOrderStatusOrder[bStatus]!) {
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

    if (workOrders != null && text.isNotEmpty) {
      searchResult = workOrders!.where((element) {
        var simplifiedClient = removeDiacritics(element.client).toLowerCase();
        var simplifiedVehicle = removeDiacritics(element.vehicle).toLowerCase();
        var simplifiedVehiclePlate = element.vehiclePlate?.toLowerCase() ?? "";
        var simplifiedPhone =
            element.phone?.replaceAll(RegExp(r"\D"), "") ?? "";
        var simplifiedDayId = element.dayId.toString().padLeft(2, '0');

        bool valid = true;

        for (var searchText in searchTextList) {
          bool onlyNumber = (int.tryParse(searchText) != null);

          if (onlyNumber) {
            if ((searchText.length == 2) && (simplifiedDayId == searchText)) {
              valid &= true;
            } else if ((searchText.length > 2) &&
                simplifiedPhone.contains(searchText)) {
              valid &= true;
            } else {
              valid = false;
            }
          } else if (simplifiedClient.contains(searchText) ||
              simplifiedVehicle.contains(searchText) ||
              simplifiedVehiclePlate.contains(searchText)) {
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
