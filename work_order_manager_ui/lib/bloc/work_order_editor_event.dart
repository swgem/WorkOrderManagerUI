import 'package:work_order_manager_ui/models/work_order.dart';

abstract class WorkOrderEditorEvent {}

class WorkOrderEditorClearEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorAddEvent extends WorkOrderEditorEvent {
  WorkOrder? workOrder;
  WorkOrderEditorAddEvent({this.workOrder});
}

class WorkOrderEditorSaveEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorSavedEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorErrorEvent extends WorkOrderEditorEvent {
  String error;
  WorkOrderEditorErrorEvent({required this.error});
}
