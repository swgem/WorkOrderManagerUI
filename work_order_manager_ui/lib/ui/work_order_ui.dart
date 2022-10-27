import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class WorkOrderUi extends StatefulWidget {
  const WorkOrderUi({super.key});

  @override
  State<WorkOrderUi> createState() => _WorkOrderUiState();
}

class _WorkOrderUiState extends State<WorkOrderUi> {
  List<WorkOrder>? workOrders;

  _getWorkOrders() {
    ApiServices.fetchWorkOrder().then((response) {
      Iterable list = jsonDecode(response.body);
      var workOrderList = list.map((obj) => WorkOrder.fromObject(obj)).toList();
      setState(() {
        workOrders = workOrderList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getWorkOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
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
}
