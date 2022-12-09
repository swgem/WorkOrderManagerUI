import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';

class WorkOrderEditorBloc
    extends Bloc<WorkOrderEditorEvent, WorkOrderEditorState> {
  WorkOrderEditorBloc() : super(WorkOrderEditorEditingState()) {
    on<WorkOrderEditorEditEvent>(
        (event, emit) => emit(WorkOrderEditorEditingState()));
    on<WorkOrderEditorSaveEvent>(
        ((event, emit) => emit(WorkOrderEditorSavingState())));
    on<WorkOrderEditorSavedEvent>(
        ((event, emit) => emit(WorkOrderEditorSavedState())));
    on<WorkOrderEditorErrorEvent>(
        ((event, emit) => emit(WorkOrderEditorErrorState(error: event.error))));
  }
}
