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
    _expTileTitleStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
    _expTileChildKeyStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.bold);
    _expTileChildValueStyle = Theme.of(context).textTheme.bodyMedium!;

    return (_workOrders == null)
        ? const Center(child: Text('Nenhuma ordem de serviço'))
        : _buildWorkOrderList();
  }

  Widget _buildWorkOrderList() {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 15.0),
        itemCount: _workOrders?.length,
        itemBuilder: (content, index) => Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
            child: ExpansionTile(
              title: Row(children: [
                Expanded(
                    flex: 0,
                    child: Text(
                        "#${_workOrders![index].dayId?.toString().padLeft(2, '0') ?? ""}",
                        style: _expTileTitleStyle)),
                const SizedBox(width: 6),
                Expanded(
                    flex: 2,
                    child: Text(_workOrders![index].client,
                        style: _expTileTitleStyle)),
                const SizedBox(width: 6),
                Expanded(
                    flex: 3,
                    child: Text(_workOrders![index].vehicle,
                        style: _expTileTitleStyle))
              ]),
              children: [
                Table(
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
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
                          child: Text(_workOrders![index].clientRequest,
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
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
                          child: Text(
                              _workOrders![index].telephone ?? "Sem telefone",
                              style: _expTileChildValueStyle)),
                    ]),
                    TableRow(children: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
                          child: Text("Observações:",
                              style: _expTileChildKeyStyle)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
                        child: Text(
                          _workOrders![index].remarks ?? "Sem observações",
                          style: _expTileChildValueStyle,
                        ),
                      ),
                    ]),
                  ],
                )
              ],
            )));
  }
}
