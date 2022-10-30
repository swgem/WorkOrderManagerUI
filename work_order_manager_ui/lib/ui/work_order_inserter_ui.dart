import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class AddWorkOrderUi extends StatefulWidget {
  const AddWorkOrderUi({super.key});

  @override
  State<AddWorkOrderUi> createState() => _AddWorkOrderUiState();
}

class _AddWorkOrderUiState extends State<AddWorkOrderUi> {
  late GlobalKey<FormState> formKey;

  late TextEditingController clientController;
  late TextEditingController telephoneController;
  late TextEditingController requestedServiceController;
  late TextStyle textFieldTextStyle;
  late TextStyle textFieldLabelStyle;
  late TextStyle textFieldLabelAsteriskStyle;
  late InputDecorationTheme textFormFieldDecoration;

  @override
  Widget build(BuildContext context) {
    formKey = GlobalKey<FormState>();
    clientController = TextEditingController();
    telephoneController = TextEditingController();
    requestedServiceController = TextEditingController();
    textFieldTextStyle = Theme.of(context).textTheme.titleLarge!;
    textFieldLabelStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Theme.of(context).hintColor);
    textFieldLabelAsteriskStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red);
    textFormFieldDecoration = Theme.of(context).inputDecorationTheme;
    return Scaffold(appBar: _buildAppBar(), body: _buildForm());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('NOVA ORDEM DE SERVIÇO'));
  }

  Widget _buildForm() {
    return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                child: TextFormField(
                  controller: clientController,
                  textCapitalization: TextCapitalization.words,
                  style: textFieldTextStyle,
                  validator: (value) =>
                      (value!.isEmpty) ? "Insira um cliente" : null,
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
                controller: requestedServiceController,
                textCapitalization: TextCapitalization.sentences,
                style: textFieldTextStyle,
                validator: (value) =>
                    (value!.isEmpty) ? "Insira a descrição serviço" : null,
                decoration: InputDecoration(
                    label: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text("Descrição do serviço", style: textFieldLabelStyle),
                      Text("*", style: textFieldLabelAsteriskStyle)
                    ]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 24),
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    saveWorkOrder();
                  }
                },
                child: const Text("SALVAR"),
              ),
            )
          ]),
        ));
  }

  Future saveWorkOrder() async {
    var workOrder = WorkOrder(
        client: clientController.text,
        clientRequest: requestedServiceController.text,
        telephone: telephoneController.text,
        orderOpeningDatetime: '',
        priority: 0,
        vehicle: '');
    var saveResponse = await ApiServices.postWorkOrder(workOrder);

    saveResponse
        ? Navigator.pop(context, true)
        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Problema de conexão!"),
          ));
  }
}
