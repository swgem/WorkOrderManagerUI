abstract class WorkOrderEditorState {}

class WorkOrderEditorEditingState extends WorkOrderEditorState {}

class WorkOrderEditorSavingState extends WorkOrderEditorState {}

class WorkOrderEditorSavedState extends WorkOrderEditorState {}

class WorkOrderEditorErrorState extends WorkOrderEditorState {
  String error;
  WorkOrderEditorErrorState({required this.error});
}
