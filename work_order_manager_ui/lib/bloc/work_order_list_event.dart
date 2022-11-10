abstract class WorkOrderListEvent {}

class WorkOrderListFetchEvent extends WorkOrderListEvent {}

class WorkOrderListLoadStatusFilterEvent extends WorkOrderListEvent {
  final List<String>? status;
  WorkOrderListLoadStatusFilterEvent({this.status});
}
