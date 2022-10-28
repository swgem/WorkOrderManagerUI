import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/ui/add_work_order_ui.dart';

import '../models/work_order.dart';

class WorkOrderUi extends StatefulWidget {
  const WorkOrderUi({super.key});

  @override
  State<WorkOrderUi> createState() => _WorkOrderUiState();
}

class _WorkOrderUiState extends State<WorkOrderUi> {
  List<WorkOrder>? workOrders;

  _getWorkOrders() => ApiServices.fetchAllWorkOrders()
      .then((response) => setState(() => workOrders = response));

  @override
  void initState() {
    super.initState();
    _getWorkOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: (workOrders == null)
            ? const Center(child: Text("Empty"))
            : _buildWorkOrderList());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Work Order List'));
  }

  Widget _buildWorkOrderList() {
    return ListView.builder(
        itemCount: workOrders?.length,
        itemBuilder: (content, index) => Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: ListTile(
                  title: Text(workOrders?[index].client ?? "EMPTY CLIENT"),
                  subtitle: Text(workOrders?[index].serviceSummary ??
                      "EMPTY SERVICE SUMMARY"),
                ),
              ),
            ));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          navigateToWorkOrder();
        },
        child: const Icon(Icons.add));
  }

  void navigateToWorkOrder() async {
    await Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const AddWorkOrderUi())))
        .then((value) => ApiServices.fetchAllWorkOrders()
            .then((response) => setState(() => workOrders = response)));
  }
}
