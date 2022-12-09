abstract class WorkOrderListEvent {}

class WorkOrderListFetchEvent extends WorkOrderListEvent {}

class WorkOrderListLoadStatusFilterEvent extends WorkOrderListEvent {
  final List<String>? status;
  WorkOrderListLoadStatusFilterEvent({this.status});
}

class WorkOrderSearchEvent extends WorkOrderListEvent {
  final String text;
  WorkOrderSearchEvent({required this.text});
}

class WorkOrderCancelSearchEvent extends WorkOrderListEvent {}

class WorkOrderListClearEvent extends WorkOrderListEvent {}
