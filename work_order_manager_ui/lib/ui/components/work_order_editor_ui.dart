import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class WorkOrderEditorUi extends StatefulWidget {
  const WorkOrderEditorUi({super.key});

  @override
  State<WorkOrderEditorUi> createState() => _WorkOrderEditorUiState();
}

class _WorkOrderEditorUiState extends State<WorkOrderEditorUi> {
  late GlobalKey<FormState> formKey;

  WorkOrder? workOrder;

  late ScrollController scrollController;
  late TextEditingController clientController;
  late TextEditingController telephoneController;
  late TextEditingController vehicleController;
  late TextEditingController vehiclePlateController;
  late TextEditingController requestedServiceController;
  late TextEditingController deadlineController;
  late TextEditingController remarksController;
  late TextStyle textFieldTextStyle;
  late TextStyle textFieldLabelStyle;
  late TextStyle textFieldLabelAsteriskStyle;
  late InputDecorationTheme textFormFieldDecoration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    formKey = GlobalKey<FormState>();
    scrollController = ScrollController();
    clientController = TextEditingController();
    telephoneController = TextEditingController();
    vehicleController = TextEditingController();
    vehiclePlateController = TextEditingController();
    requestedServiceController = TextEditingController();
    deadlineController = TextEditingController();
    remarksController = TextEditingController();
    textFieldTextStyle = Theme.of(context).textTheme.titleMedium!;
    textFieldLabelStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(color: Theme.of(context).hintColor);
    textFieldLabelAsteriskStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red);
    textFormFieldDecoration = Theme.of(context).inputDecorationTheme;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkOrderEditorBloc, WorkOrderEditorState>(
      bloc: BlocProvider.of(context),
      listener: (context, state) {
        if (state is WorkOrderEditorSavingState) {
          if (formKey.currentState!.validate()) {
            showDialog<String>(
                context: context,
                builder: (context) => _buildButtonAlertDialog(
                    "Salvar ordem de serviço", () => saveWorkOrder()));
          }
        }
      },
      child: BlocBuilder<WorkOrderEditorBloc, WorkOrderEditorState>(
        bloc: BlocProvider.of(context),
        buildWhen: (previous, current) =>
            (current != previous) &&
            (current is! WorkOrderEditorSavingState) &&
            (current is! WorkOrderEditorSavedState) &&
            (current is! WorkOrderEditorErrorState),
        builder: ((context, state) {
          if (state is WorkOrderEditorEditingState) {
            workOrder = state.workOrder;
            _inputInitialValues();
            return _buildForm();
          } else {
            return Container();
          }
        }),
      ),
    );
  }

  void _inputInitialValues() {
    clientController.text = workOrder?.client ?? "";
    telephoneController.text = workOrder?.telephone ?? "";
    vehicleController.text = workOrder?.vehicle ?? "";
    vehiclePlateController.text = workOrder?.vehiclePlate ?? "";
    requestedServiceController.text = workOrder?.clientRequest ?? "";
    deadlineController.text = workOrder?.deadline ?? "";
    remarksController.text = workOrder?.remarks ?? "";
  }

  Widget _buildForm() {
    return Form(
        key: formKey,
        child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: TextFormField(
                      controller: clientController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      style: textFieldTextStyle,
                      validator: (value) =>
                          (value!.isEmpty) ? "Insira o cliente" : null,
                      decoration: InputDecoration(
                          label: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("Cliente", style: textFieldLabelStyle),
                            Text("*", style: textFieldLabelAsteriskStyle)
                          ]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: TextFormField(
                      controller: telephoneController,
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(
                          label: Text("Telefone", style: textFieldLabelStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: TextFormField(
                    controller: vehicleController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    style: textFieldTextStyle,
                    validator: (value) =>
                        (value!.isEmpty) ? "Insira o veículo" : null,
                    decoration: InputDecoration(
                        label: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("Veículo", style: textFieldLabelStyle),
                          Text("*", style: textFieldLabelAsteriskStyle)
                        ]),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: TextFormField(
                      controller: vehiclePlateController,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(
                          label: Text("Placa do veículo",
                              style: textFieldLabelStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: TextFormField(
                    controller: requestedServiceController,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: textFieldTextStyle,
                    validator: (value) =>
                        (value!.isEmpty) ? "Insira a descrição serviço" : null,
                    decoration: InputDecoration(
                        label: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("Descrição do serviço",
                              style: textFieldLabelStyle),
                          Text("*", style: textFieldLabelAsteriskStyle)
                        ]),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: TextFormField(
                      controller: deadlineController,
                      keyboardType: TextInputType.datetime,
                      maxLines: null,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(
                          label: Text("Prazo", style: textFieldLabelStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: TextFormField(
                      controller: remarksController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      textCapitalization: TextCapitalization.characters,
                      style: textFieldTextStyle,
                      decoration: InputDecoration(
                          label:
                              Text("Observações", style: textFieldLabelStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                const SizedBox(height: 25.0)
              ]),
            )));
  }

  Widget _buildButtonAlertDialog(
      String titleText, void Function() yesCallback) {
    return AlertDialog(
        title: Text(titleText),
        content:
            const Text("Tem certeza que deseja salvar a ordem de serviço?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, "Não"),
              child: const Text("Não")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, "Sim");
                yesCallback();
              },
              child: const Text("Sim"))
        ]);
  }

  Future saveWorkOrder() async {
    var currentDateTime =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var newWorkOrder = WorkOrder(
      id: workOrder?.id ?? 0,
      dayId: workOrder?.id ?? 0,
      status: workOrder?.status ?? "waiting",
      priority: workOrder?.priority ?? 0,
      orderOpeningDatetime: workOrder?.orderOpeningDatetime ?? currentDateTime,
      client: clientController.text,
      telephone: telephoneController.text,
      vehicle: vehicleController.text,
      vehiclePlate: vehiclePlateController.text,
      clientRequest: requestedServiceController.text,
      deadline: deadlineController.text,
      remarks: remarksController.text,
    );

    try {
      if (workOrder == null) {
        await ApiServices.postWorkOrder(newWorkOrder);
      } else {
        await ApiServices.putWorkOrder(newWorkOrder);
      }
      BlocProvider.of<WorkOrderEditorBloc>(context)
          .add(WorkOrderEditorSavedEvent());
    } catch (e) {
      BlocProvider.of<WorkOrderEditorBloc>(context)
          .add(WorkOrderEditorErrorEvent(error: e.toString()));
    }
  }
}
