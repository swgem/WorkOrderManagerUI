import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class AddWorkOrderUi extends StatefulWidget {
  const AddWorkOrderUi({super.key});

  @override
  State<AddWorkOrderUi> createState() => _AddWorkOrderUiState();
}

class _AddWorkOrderUiState extends State<AddWorkOrderUi> {
  TextEditingController clientController;
  TextEditingController serviceSummaryController;
  TextStyle? textStyle;

  _AddWorkOrderUiState()
      : clientController = TextEditingController(),
        serviceSummaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(appBar: _buildAppBar(), body: _buildForm());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Work Order List'));
  }

  Widget _buildForm() {
    return Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: [
          TextField(
            controller: clientController,
            style: textStyle,
            decoration: InputDecoration(
                labelText: "Client",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          ),
          Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: serviceSummaryController,
                style: textStyle,
                decoration: InputDecoration(
                    labelText: "Service Summary",
                    labelStyle: textStyle,
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
                child: Text("Save"),
              ),
            ],
          )
        ]));
  }

  void saveWorkOrder() async {
    var workOrder = WorkOrder(
        client: clientController.text,
        serviceSummary: serviceSummaryController.text);
    var saveResponse = await ApiServices.postWorkOrder(workOrder);

    saveResponse
        ? Navigator.pop(context, true)
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Connection Issue!"),
          ));
  }
}
