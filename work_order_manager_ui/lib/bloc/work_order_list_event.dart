abstract class WorkOrderListEvent {}

class WorkOrderListFetchEvent extends WorkOrderListEvent {}

class WorkOrderListFetchByStatusEvent extends WorkOrderListEvent {
  final List<String>? status;
  WorkOrderListFetchByStatusEvent({this.status});
}
