import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/stream/work_order_editor_event.dart';

import '../../models/work_order.dart';

class WorkOrderEditorUi extends StatefulWidget {
  final Stream<WorkOrderEditorEvent> parentEvent;
  final WorkOrder? workOrder;

  const WorkOrderEditorUi(
      {super.key, required this.parentEvent, this.workOrder});

  @override
  State<WorkOrderEditorUi> createState() => _WorkOrderEditorUiState();
}

class _WorkOrderEditorUiState extends State<WorkOrderEditorUi> {
  late GlobalKey<FormState> formKey;

  late StreamSubscription<WorkOrderEditorEvent> _eventSubscription;

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
  void initState() {
    super.initState();

    _eventSubscription = widget.parentEvent.asBroadcastStream().listen((event) {
      if (event == WorkOrderEditorEvent.saveWorkOrder) {
        if (formKey.currentState!.validate()) {
          showDialog<String>(
              context: context,
              builder: (context) => _buildButtonAlertDialog(
                  "Salvar ordem de serviço", () => saveWorkOrder()));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _eventSubscription.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    formKey = GlobalKey<FormState>();
    scrollController = ScrollController();
    clientController = TextEditingController(text: widget.workOrder?.client);
    telephoneController =
        TextEditingController(text: widget.workOrder?.telephone);
    vehicleController = TextEditingController(text: widget.workOrder?.vehicle);
    vehiclePlateController =
        TextEditingController(text: widget.workOrder?.vehiclePlate);
    requestedServiceController =
        TextEditingController(text: widget.workOrder?.clientRequest);
    deadlineController =
        TextEditingController(text: widget.workOrder?.deadline);
    remarksController = TextEditingController(text: widget.workOrder?.remarks);
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
    return Container(
      child: _buildForm(),
    );
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
      id: widget.workOrder?.id ?? 0,
      dayId: widget.workOrder?.id ?? 0,
      status: widget.workOrder?.status ?? "waiting",
      priority: widget.workOrder?.priority ?? 0,
      orderOpeningDatetime:
          widget.workOrder?.orderOpeningDatetime ?? currentDateTime,
      client: clientController.text,
      telephone: telephoneController.text,
      vehicle: vehicleController.text,
      vehiclePlate: vehiclePlateController.text,
      clientRequest: requestedServiceController.text,
      deadline: deadlineController.text,
      remarks: remarksController.text,
    );

    bool isResponseOk = (widget.workOrder == null)
        ? await ApiServices.postWorkOrder(newWorkOrder).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()),
              duration: const Duration(seconds: 5),
            ));
            return false;
          })
        : await ApiServices.putWorkOrder(newWorkOrder).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()),
              duration: const Duration(seconds: 5),
            ));
            return false;
          });

    if (isResponseOk) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Problema de conexão!")));
    }
  }
}
