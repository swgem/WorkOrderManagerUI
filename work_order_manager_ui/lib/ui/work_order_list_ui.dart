import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/events/work_order_list_event_type.dart';

import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/ui/work_order_card_ui.dart';

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

  int _sortWorkOrdersByStatus(WorkOrder a, WorkOrder b) {
    final Map<String, int> workOrderStatusOrder = {
      "waiting": 1,
      "ongoing": 2,
      "finished": 3,
      "cancelled": 4
    };

    if (workOrderStatusOrder[a.status]! > workOrderStatusOrder[b.status]!) {
      return 1;
    } else if (workOrderStatusOrder[a.status]! <
        workOrderStatusOrder[b.status]!) {
      return -1;
    } else {
      return 0;
    }
  }

  Future<void> _refreshWorkOrderList() async {
    ApiServices.fetchAllWorkOrders().then((response) {
      _workOrders = response;
      setState(() {
        if (_workOrders != null) {
          _workOrders!.sort(_sortWorkOrdersByStatus);
        }
      });
    }).catchError((e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
        )));
  }

  // Future<void> _refreshWorkOrderList() async => setState(() => _workOrders = [
  //       WorkOrder(
  //         client: 'Claudinelson',
  //         status: 'waiting',
  //         dayId: 1,
  //         priority: 0,
  //         telephone: '15 3127 1543',
  //         clientRequest: 'Alinhamento e balanceamento',
  //         orderOpeningDatetime: '01/11/2022 7:51:37',
  //         vehicle: 'Porsche',
  //       ),
  //       WorkOrder(
  //           client: 'Elton da marmoraria Henriques',
  //           status: 'ongoing',
  //           dayId: 2,
  //           priority: 1,
  //           telephone: '+12 47 95471 3150',
  //           clientRequest:
  //               'Troca dos amortecedores. Vazamento de óleo. Ventoinha não está ligando',
  //           orderOpeningDatetime: '01/11/2022 9:35:10',
  //           vehicle: 'Strada Endurance cabine dupla',
  //           remarks: 'Bateu o carro em um poste')
  //     ]);

  @override
  void initState() {
    super.initState();

    _subscription = widget.parentEvent.asBroadcastStream().listen((event) {
      if (event == WorkOrderListEventType.refetchList) _refreshWorkOrderList();
    });
    _refreshWorkOrderList();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return (_workOrders?.isNotEmpty ?? false)
        ? _buildWorkOrderList(context)
        : const Center(child: Text('Nenhuma ordem de serviço'));
  }

  Widget _buildWorkOrderList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshWorkOrderList(),
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 15.0),
          itemCount: _workOrders?.length,
          itemBuilder: (content, index) => Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
              child: WorkOrderCardUi(workOrder: _workOrders![index]))),
    );
  }
}
