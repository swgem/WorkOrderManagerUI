import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class AddWorkOrderUi extends StatefulWidget {
  const AddWorkOrderUi({super.key});

  @override
  State<AddWorkOrderUi> createState() => _AddWorkOrderUiState();
}

class _AddWorkOrderUiState extends State<AddWorkOrderUi> {
  late TextEditingController clientController;
  late TextEditingController requestedServiceController;
  late TextStyle textFormFieldStyle;
  late InputDecorationTheme textFormFieldDecoration;

  @override
  Widget build(BuildContext context) {
    clientController = TextEditingController();
    requestedServiceController = TextEditingController();
    textFormFieldStyle = Theme.of(context).textTheme.titleLarge!;
    textFormFieldDecoration = Theme.of(context).inputDecorationTheme!;
    return Scaffold(appBar: _buildAppBar(), body: _buildForm());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Nova Ordem de Serviço'));
  }

  Widget _buildForm() {
    return Padding(
        padding: const EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: [
          TextFormField(
            controller: clientController,
            style: textFormFieldStyle,
            decoration: InputDecoration(
                labelText: "Cliente",
                labelStyle: textFormFieldStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                controller: requestedServiceController,
                style: textFormFieldStyle,
                decoration: InputDecoration(
                    labelText: "Descrição do serviço",
                    labelStyle: textFormFieldStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  saveWorkOrder();
                },
                child: const Text("Salvar"),
              ),
            ],
          )
        ]));
  }

  Future saveWorkOrder() async {
    var workOrder = WorkOrder(
        client: clientController.text,
        clientRequest: requestedServiceController.text,
        dayId: 0,
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
