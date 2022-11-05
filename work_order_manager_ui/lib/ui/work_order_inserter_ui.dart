import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class WorkOrderInserterUi extends StatefulWidget {
  const WorkOrderInserterUi({super.key});

  @override
  State<WorkOrderInserterUi> createState() => _WorkOrderInserterUiState();
}

class _WorkOrderInserterUiState extends State<WorkOrderInserterUi> {
  late GlobalKey<FormState> formKey;

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
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildForm(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Nova ordem de serviço'));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            saveWorkOrder();
          }
        },
        child: const Icon(Icons.save));
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

  Future saveWorkOrder() async {
    var currentDateTime =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var workOrder = WorkOrder(
      status: 'waiting',
      priority: 0,
      orderOpeningDatetime: currentDateTime,
      client: clientController.text,
      clientRequest: requestedServiceController.text,
      telephone: telephoneController.text,
      vehicle: vehicleController.text,
      vehiclePlate: vehiclePlateController.text,
      deadline: deadlineController.text,
      remarks: remarksController.text,
    );

    bool saveResponse =
        await ApiServices.postWorkOrder(workOrder).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      ));
      return false;
    });

    saveResponse
        ? Navigator.pop(context, true)
        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Problema de conexão!"),
          ));
  }
}
