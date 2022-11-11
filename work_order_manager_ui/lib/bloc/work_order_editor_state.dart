import 'package:work_order_manager_ui/models/work_order.dart';

abstract class WorkOrderEditorState {}

class WorkOrderEditorEmptyState extends WorkOrderEditorState {}

class WorkOrderEditorEditingState extends WorkOrderEditorState {
  WorkOrder? workOrder;
  WorkOrderEditorEditingState({this.workOrder});
}

class WorkOrderEditorSavingState extends WorkOrderEditorState {}

class WorkOrderEditorSavedState extends WorkOrderEditorState {}

class WorkOrderEditorErrorState extends WorkOrderEditorState {
  String error;
  WorkOrderEditorErrorState({required this.error});
}
