import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/ui/work_order_inserter_ui.dart';

import '../models/work_order.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
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
            ? const Center(child: Text('Nenhuma ordem de serviço'))
            : _buildWorkOrderList());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('LISTA DE ORDENS DE SERVIÇO'));
  }

  Widget _buildWorkOrderList() {
    return ListView.builder(
        itemCount: workOrders?.length,
        itemBuilder: (content, index) => Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: ListTile(
                  title: Text(workOrders?[index].client ?? ''),
                  subtitle: Text(workOrders?[index].clientRequest ?? ''),
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
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderInserterUi()))).then(
        (value) => ApiServices.fetchAllWorkOrders()
            .then((response) => setState(() => workOrders = response)));
  }
}
