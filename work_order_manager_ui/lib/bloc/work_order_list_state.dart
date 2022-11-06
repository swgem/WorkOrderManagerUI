import 'package:work_order_manager_ui/models/work_order.dart';

abstract class WorkOrderListState {
  List<WorkOrder> workOrders;
  WorkOrderListState({required this.workOrders});
}

class WorkOrderListLoadingState extends WorkOrderListState {
  WorkOrderListLoadingState() : super(workOrders: []);
}

class WorkOrderListSucessState extends WorkOrderListState {
  WorkOrderListSucessState({required List<WorkOrder> workOrders})
      : super(workOrders: workOrders);
}

class WorkOrderListEmptyState extends WorkOrderListState {
  WorkOrderListEmptyState() : super(workOrders: []);
}

class WorkOrderListErrorState extends WorkOrderListState {
  final String message;
  WorkOrderListErrorState({required this.message}) : super(workOrders: []);
}
