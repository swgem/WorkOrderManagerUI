import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';
import 'package:work_order_manager_ui/ui/dialogs/work_order_info_dialog_ui.dart';
import 'package:work_order_manager_ui/ui/responsive.dart';

class WorkOrderListItemUi extends StatefulWidget {
  final WorkOrder workOrder;

  const WorkOrderListItemUi({super.key, required this.workOrder});

  @override
  State<WorkOrderListItemUi> createState() => _WorkOrderListItemUiState();
}

class _WorkOrderListItemUiState extends State<WorkOrderListItemUi> {
  late TextStyle _expTileTitleStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _expTileTitleStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: WorkOrderStatusExtension.fromString(widget.workOrder.status)!
            .color(context),
        child: InkWell(
            onTap: () => showDialog(
                context: context,
                builder: ((context) => WorkOrderInfoDialogUi(
                      workOrder: widget.workOrder,
                    ))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Responsive.platform(context) == Platform.mobile)
                  ? _buildCard(context)
                  : _buildTile(context),
            )));
  }

  Widget _buildCard(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 0,
          child: Column(
            children: [
              Text("#${widget.workOrder.dayId.toString().padLeft(2, '0')}",
                  style: _expTileTitleStyle),
              const SizedBox(height: 5),
              Text(widget.workOrder.orderOpeningDatetime.substring(0, 5),
                  style: _expTileTitleStyle),
            ],
          )),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(Icons.description, color: _expTileTitleStyle.color),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(
                widget.workOrder.clientRequest.replaceAll('\n', '; '),
                style: _expTileTitleStyle,
                overflow: TextOverflow.ellipsis,
              )),
            ]),
          ),
        ],
      )),
    ]);
  }

  Widget _buildTile(BuildContext context) {
    return Row(children: [
      Text(widget.workOrder.orderOpeningDatetime.substring(0, 5),
          style: _expTileTitleStyle),
      const SizedBox(width: 15),
      Text("#${widget.workOrder.dayId.toString().padLeft(2, '0')}",
          style: _expTileTitleStyle),
      const SizedBox(width: 15),
      Flexible(
        flex: 1,
        child: Row(
          children: [
            Icon(const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                color: _expTileTitleStyle.color),
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              widget.workOrder.vehicle,
              style: _expTileTitleStyle,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
      ),
      const SizedBox(width: 15),
      Flexible(
        flex: 1,
        child: Row(
          children: [
            Icon(Icons.person, color: _expTileTitleStyle.color),
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              widget.workOrder.client,
              style: _expTileTitleStyle,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
      ),
      const SizedBox(width: 15),
      Flexible(
        flex: (Responsive.platform(context) == Platform.desktop) ? 4 : 2,
        child: Row(
          children: [
            Icon(Icons.description, color: _expTileTitleStyle.color),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                widget.workOrder.clientRequest.replaceAll('\n', '; '),
                style: _expTileTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
