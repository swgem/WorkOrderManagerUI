import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class WorkOrderCardUi extends StatefulWidget {
  final WorkOrder workOrder;

  WorkOrderCardUi({super.key, required this.workOrder});

  @override
  State<WorkOrderCardUi> createState() => _WorkOrderCardUiState();
}

class _WorkOrderCardUiState extends State<WorkOrderCardUi> {
  final Map<String, Color> _statusColor = {
    "waiting": Colors.yellow,
    "ongoing": Colors.green,
    "finished": Colors.grey,
    "cancelled": Colors.red
  };

  late TextStyle _expTileTitleStyle;
  late TextStyle _expTileChildKeyStyle;
  late TextStyle _expTileChildValueStyle;
  late TextStyle _expTileButtonStyle;

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
    _expTileButtonStyle = Theme.of(context).textTheme.titleMedium!;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: _statusColor[widget.workOrder.status],
        child: ExpansionTile(
          key: GlobalKey(),
          title: _buildExpTileTitle(context),
          children: [_buildExpTileChild()],
        ));
  }

  Widget _buildExpTileTitle(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 0,
          child: Text("#${widget.workOrder.dayId.toString().padLeft(2, '0')}",
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
                    child: Text(widget.workOrder.client,
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
                    child: Text(widget.workOrder.vehicle,
                        style: _expTileTitleStyle)),
              ])),
        ],
      ),
    ]);
  }

  Widget _buildExpTileChild() {
    return Column(children: [
      Table(columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth()
      }, children: [
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
              child: Text(widget.workOrder.clientRequest,
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
                  (widget.workOrder.telephone?.isNotEmpty ?? false)
                      ? widget.workOrder.telephone!
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
              (widget.workOrder.remarks?.isNotEmpty ?? false)
                  ? widget.workOrder.remarks!
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
              widget.workOrder.orderOpeningDatetime,
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
              (widget.workOrder.deadline?.isNotEmpty ?? false)
                  ? widget.workOrder.deadline!
                  : "-",
              style: _expTileChildValueStyle,
            ),
          ),
        ]),
      ]),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
          child: _buildExpTileButtons())
    ]);
  }

  Widget _buildExpTileButtons() {
    return (MediaQuery.of(context).size.width > 500)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildExpTileButtonChildren(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildExpTileButtonChildren(),
          );
  }

  List<Widget> _buildExpTileButtonChildren() {
    List<Widget> buttonList;

    if (widget.workOrder.status == "waiting") {
      buttonList = [
        _buildToOngoingButton(),
      ];
    } else if (widget.workOrder.status == "ongoing") {
      buttonList = [
        _buildToCancelledButton(),
        const SizedBox(width: 25, height: 12),
        _buildToWaitingButton(),
      ];
    } else {
      buttonList = [
        _buildToWaitingButton(),
      ];
    }
    return buttonList;
  }

  Widget _buildToWaitingButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(175, 0),
            backgroundColor: Theme.of(context).highlightColor),
        onPressed: () {
          var workOrder = WorkOrder(
            id: widget.workOrder.id,
            dayId: widget.workOrder.dayId,
            status: 'waiting',
            priority: widget.workOrder.priority,
            orderOpeningDatetime: widget.workOrder.orderOpeningDatetime,
            orderClosingDatetime: widget.workOrder.orderClosingDatetime,
            client: widget.workOrder.client,
            telephone: widget.workOrder.telephone,
            vehicle: widget.workOrder.vehicle,
            vehiclePlate: widget.workOrder.vehiclePlate,
            clientRequest: widget.workOrder.clientRequest,
            pendencies: widget.workOrder.pendencies,
            deadline: widget.workOrder.deadline,
            remarks: widget.workOrder.remarks,
          );
          saveWorkOrder(workOrder);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Retornar à espera", style: _expTileButtonStyle)));
  }

  Widget _buildToOngoingButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(175, 0),
            backgroundColor: Theme.of(context).highlightColor),
        onPressed: () {
          var workOrder = WorkOrder(
            id: widget.workOrder.id,
            dayId: widget.workOrder.dayId,
            status: 'ongoing',
            priority: widget.workOrder.priority,
            orderOpeningDatetime: widget.workOrder.orderOpeningDatetime,
            orderClosingDatetime: widget.workOrder.orderClosingDatetime,
            client: widget.workOrder.client,
            telephone: widget.workOrder.telephone,
            vehicle: widget.workOrder.vehicle,
            vehiclePlate: widget.workOrder.vehiclePlate,
            clientRequest: widget.workOrder.clientRequest,
            pendencies: widget.workOrder.pendencies,
            deadline: widget.workOrder.deadline,
            remarks: widget.workOrder.remarks,
          );
          saveWorkOrder(workOrder);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Iniciar serviço", style: _expTileButtonStyle)));
  }

  Widget _buildToCancelledButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(175, 0),
            backgroundColor: Theme.of(context).highlightColor),
        onPressed: () {
          var workOrder = WorkOrder(
            id: widget.workOrder.id,
            dayId: widget.workOrder.dayId,
            status: 'cancelled',
            priority: widget.workOrder.priority,
            orderOpeningDatetime: widget.workOrder.orderOpeningDatetime,
            orderClosingDatetime: widget.workOrder.orderClosingDatetime,
            client: widget.workOrder.client,
            telephone: widget.workOrder.telephone,
            vehicle: widget.workOrder.vehicle,
            vehiclePlate: widget.workOrder.vehiclePlate,
            clientRequest: widget.workOrder.clientRequest,
            pendencies: widget.workOrder.pendencies,
            deadline: widget.workOrder.deadline,
            remarks: widget.workOrder.remarks,
          );
          saveWorkOrder(workOrder);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Cancelar", style: _expTileButtonStyle)));
  }

  Future saveWorkOrder(WorkOrder workOrder) async {
    bool saveResponse =
        await ApiServices.putWorkOrder(workOrder).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      ));
      return false;
    });

    if (!saveResponse) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Problema de conexão!"),
      ));
    }

    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListFetchEvent());
  }
}
