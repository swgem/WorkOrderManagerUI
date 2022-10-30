import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/events/work_order_list_event_type.dart';

import 'package:work_order_manager_ui/models/api_services.dart';

import '../models/work_order.dart';

class WorkOrderListUi extends StatefulWidget {
  final Stream<WorkOrderListEventType> parentEvent;

  const WorkOrderListUi({super.key, required this.parentEvent});

  @override
  State<WorkOrderListUi> createState() => _WorkOrderListUiState();
}

class _WorkOrderListUiState extends State<WorkOrderListUi> {
  List<WorkOrder>? _workOrders;
  late StreamSubscription<WorkOrderListEventType> _subscription;

  _getWorkOrders() => ApiServices.fetchAllWorkOrders()
      .then((response) => setState(() => _workOrders = response));

  @override
  void initState() {
    _subscription = widget.parentEvent.asBroadcastStream().listen((event) {
      if (event == WorkOrderListEventType.refetchList) _getWorkOrders();
    });
    _getWorkOrders();

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_workOrders == null)
        ? const Center(child: Text('Nenhuma ordem de serviço'))
        : _buildWorkOrderList();
  }

  Widget _buildWorkOrderList() {
    return ListView.builder(
        itemCount: _workOrders?.length,
        itemBuilder: (content, index) => Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: ListTile(
                  title: Text(_workOrders?[index].client ?? ''),
                  subtitle: Text(_workOrders?[index].clientRequest ?? ''),
                ),
              ),
            ));
  }
}
