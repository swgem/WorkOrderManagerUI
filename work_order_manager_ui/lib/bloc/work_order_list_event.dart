import 'package:work_order_manager_ui/shared/work_order_status.dart';

abstract class WorkOrderListEvent {}

class WorkOrderListFetchEvent extends WorkOrderListEvent {}

class WorkOrderListLoadStatusFilterEvent extends WorkOrderListEvent {
  final List<WorkOrderStatus>? status;
  WorkOrderListLoadStatusFilterEvent({this.status});
}

class WorkOrderSearchEvent extends WorkOrderListEvent {
  final String text;
  WorkOrderSearchEvent({required this.text});
}

class WorkOrderCancelSearchEvent extends WorkOrderListEvent {}

class WorkOrderListClearEvent extends WorkOrderListEvent {}
