import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/models/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';

class WorkOrderCardUi extends StatefulWidget {
  final WorkOrder workOrder;
  final List<String>? workOrderListFilterStatus;

  const WorkOrderCardUi(
      {super.key, required this.workOrder, this.workOrderListFilterStatus});

  @override
  State<WorkOrderCardUi> createState() => _WorkOrderCardUiState();
}

class _WorkOrderCardUiState extends State<WorkOrderCardUi> {
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
        color: _getColorByStatus(widget.workOrder.status),
        child: ExpansionTile(
          key: GlobalKey(),
          title: _buildExpTileTitle(context),
          children: [_buildExpTileChild()],
        ));
  }

  Color _getColorByStatus(String status) {
    var currentThemeMode = AdaptiveTheme.of(context).brightness;

    final Map<String, Color> statusColor = {
      "waiting": (currentThemeMode == Brightness.light)
          ? const Color.fromARGB(255, 255, 242, 121)
          : const Color.fromARGB(255, 128, 118, 31),
      "ongoing": (currentThemeMode == Brightness.light)
          ? const Color.fromARGB(255, 123, 199, 125)
          : const Color.fromARGB(255, 67, 112, 69),
      "finished": (currentThemeMode == Brightness.light)
          ? const Color.fromARGB(255, 185, 185, 185)
          : const Color.fromARGB(255, 97, 97, 97),
      "cancelled": (currentThemeMode == Brightness.light)
          ? const Color.fromARGB(255, 255, 129, 120)
          : const Color.fromARGB(255, 159, 70, 64)
    };

    return statusColor[status]!;
  }

  Widget _buildExpTileTitle(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 0,
          child: Text("#${widget.workOrder.dayId.toString().padLeft(2, '0')}",
              style: _expTileTitleStyle)),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(Icons.person, color: _expTileTitleStyle.color),
              const SizedBox(width: 5),
              Expanded(
                  child:
                      Text(widget.workOrder.client, style: _expTileTitleStyle)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
            child: Row(children: [
              Icon(const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                  color: _expTileTitleStyle.color),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(widget.workOrder.vehicle,
                      style: _expTileTitleStyle)),
            ]),
          ),
        ],
      )),
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
        padding: const EdgeInsets.only(bottom: 15.0),
        child: _buildExpTileButtons(),
      ),
    ]);
  }

  Widget _buildExpTileButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildExpTileButtonChildren(),
    );
  }

  List<Widget> _buildExpTileButtonChildren() {
    List<Widget> buttonList;

    if (widget.workOrder.status == "waiting") {
      buttonList = [
        _buildToOngoingButton(),
        const SizedBox(width: 25, height: 12),
        _buildToCancelledButton(),
        const SizedBox(width: 25, height: 12),
        _buildEditButton(),
      ];
    } else if (widget.workOrder.status == "ongoing") {
      buttonList = [
        _buildToCancelledButton(),
        const SizedBox(width: 25, height: 12),
        _buildToWaitingButton(),
        const SizedBox(width: 25, height: 12),
        _buildToFinishedButton(),
        const SizedBox(width: 25, height: 12),
        _buildEditButton(),
      ];
    } else if (widget.workOrder.status == "finished") {
      buttonList = [
        _buildToCancelledButton(),
      ];
    } else /*if (widget.workOrder.status == "cancelled")*/ {
      buttonList = [
        _buildToWaitingButton(),
      ];
    }
    return buttonList;
  }

  Widget _buildToWaitingButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).hoverColor),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (context) => _buildButtonAlertDialog(
                    "Retornar ordem de serviço à espera?", () {
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
                  _saveWorkOrder(workOrder);
                })),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Retornar à espera", style: _expTileButtonStyle)));
  }

  Widget _buildToOngoingButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).hoverColor),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (context) =>
                _buildButtonAlertDialog("Iniciar ordem de serviço?", () {
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
                  _saveWorkOrder(workOrder);
                })),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Iniciar serviço", style: _expTileButtonStyle)));
  }

  Widget _buildToFinishedButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).hoverColor),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (context) =>
                _buildButtonAlertDialog("Finalizar ordem de serviço?", () {
                  var workOrder = WorkOrder(
                    id: widget.workOrder.id,
                    dayId: widget.workOrder.dayId,
                    status: 'finished',
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
                  _saveWorkOrder(workOrder);
                })),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Finalizar", style: _expTileButtonStyle)));
  }

  Widget _buildToCancelledButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).hoverColor),
        onPressed: () => showDialog<String>(
            context: context,
            builder: ((context) =>
                _buildButtonAlertDialog("Cancelar ordem de serviço?", () {
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
                  _saveWorkOrder(workOrder);
                }))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Cancelar", style: _expTileButtonStyle)));
  }

  Widget _buildEditButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).highlightColor),
        onPressed: () => _navigateToWorkOrderEditor(),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text("Editar", style: _expTileButtonStyle)));
  }

  Widget _buildButtonAlertDialog(
      String titleText, void Function() yesCallback) {
    return AlertDialog(
        title: Text(titleText),
        content: const Text(
            "Tem certeza que deseja alterar o status da ordem de serviço?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, "Não"),
              child: const Text("Não")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, "Sim");
                yesCallback();
              },
              child: const Text("Sim"))
        ]);
  }

  Future _saveWorkOrder(WorkOrder workOrder) async {
    bool isResponseOk =
        await ApiServices.putWorkOrder(workOrder).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      ));
      return false;
    });

    if (!isResponseOk) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Problema de conexão!"),
      ));
    }

    BlocProvider.of<WorkOrderListBloc>(context).add(
        WorkOrderListFetchByStatusEvent(
            status: widget.workOrderListFilterStatus));
  }

  Future _navigateToWorkOrderEditor() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => WorkOrderEditorPageUi(
                  workOrder: widget.workOrder,
                )))).then((value) => BlocProvider.of<WorkOrderListBloc>(context)
        .add(WorkOrderListFetchByStatusEvent(
            status: widget.workOrderListFilterStatus)));
  }
}
