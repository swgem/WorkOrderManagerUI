abstract class WorkOrderEditorEvent {}

class WorkOrderEditorEditEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorSaveEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorSavedEvent extends WorkOrderEditorEvent {}

class WorkOrderEditorErrorEvent extends WorkOrderEditorEvent {
  String error;
  WorkOrderEditorErrorEvent({required this.error});
}
