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
  late TextStyle _expTileTitleStyle;
  late TextStyle _expTileChildKeyStyle;
  late TextStyle _expTileChildValueStyle;

  int _sortWorkOrdersByStatus(WorkOrder a, WorkOrder b) {
    if (a.status == "waiting" && b.status == "onGoing") {
      return -1;
    } else if (a.status == "onGoing" && b.status == "waiting") {
      return 1;
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
  //           status: 'onGoing',
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    _expTileTitleStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
    _expTileChildKeyStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.bold);
    _expTileChildValueStyle = Theme.of(context).textTheme.bodyMedium!;
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
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 15.0),
        itemCount: _workOrders?.length,
        itemBuilder: (content, index) => Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
            child: ExpansionTile(
              title: _buildExpTileTitle(index, context),
              children: [_buildExpTitleChild(index)],
            )));
  }

  Widget _buildExpTileTitle(int workOrderIndex, BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 0,
          child: Text(
              "#${_workOrders![workOrderIndex].dayId.toString().padLeft(2, '0')}",
              style: _expTileTitleStyle)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 130),
              padding: const EdgeInsets.fromLTRB(15, 5, 8, 0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Icon(Icons.person, color: _expTileTitleStyle.color),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(_workOrders![workOrderIndex].client,
                        style: _expTileTitleStyle)),
              ])),
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 130),
              padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
              child: Row(children: [
                Icon(const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                    color: _expTileTitleStyle.color),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(_workOrders![workOrderIndex].vehicle,
                        style: _expTileTitleStyle)),
              ])),
        ],
      ),
    ]);
  }

  Widget _buildExpTitleChild(int workOrderIndex) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth()
      },
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
            child: Text(
              "Descrição:",
              style: _expTileChildKeyStyle,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
              child: Text(_workOrders![workOrderIndex].clientRequest,
                  style: _expTileChildValueStyle)),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
            child: Text(
              "Telefone:",
              style: _expTileChildKeyStyle,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
              child: Text(
                  (_workOrders![workOrderIndex].telephone?.isNotEmpty ?? false)
                      ? _workOrders![workOrderIndex].telephone!
                      : "-",
                  style: _expTileChildValueStyle)),
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
              child: Text("Observações:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
            child: Text(
              (_workOrders![workOrderIndex].remarks?.isNotEmpty ?? false)
                  ? _workOrders![workOrderIndex].remarks!
                  : "-",
              style: _expTileChildValueStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
              child: Text("Criado em:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
            child: Text(
              _workOrders![workOrderIndex].orderOpeningDatetime,
              style: _expTileChildValueStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
              child: Text("Prazo:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 15.0),
            child: Text(
              (_workOrders![workOrderIndex].deadline?.isNotEmpty ?? false)
                  ? _workOrders![workOrderIndex].deadline!
                  : "-",
              style: _expTileChildValueStyle,
            ),
          ),
        ]),
      ],
    );
  }
}
