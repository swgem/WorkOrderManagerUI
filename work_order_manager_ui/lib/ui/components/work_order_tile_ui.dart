import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_order_manager_ui/api/work_order_api_services.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/dialogs/work_order_editor_dialog_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';
import 'package:work_order_manager_ui/ui/responsive.dart';

class WorkOrderTileUi extends StatefulWidget {
  final WorkOrder workOrder;

  const WorkOrderTileUi({super.key, required this.workOrder});

  @override
  State<WorkOrderTileUi> createState() => _WorkOrderTileUiState();
}

class _WorkOrderTileUiState extends State<WorkOrderTileUi> {
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
              "Cliente:",
              style: _expTileChildKeyStyle,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
              child: SelectableText(
                  enableInteractiveSelection: true,
                  widget.workOrder.client,
                  style: _expTileChildValueStyle)),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
            child: Text(
              "Veículo:",
              style: _expTileChildKeyStyle,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
              child: SelectableText(
                  enableInteractiveSelection: true,
                  widget.workOrder.vehicle,
                  style: _expTileChildValueStyle)),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
            child: Text(
              "Placa:",
              style: _expTileChildKeyStyle,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
              child: SelectableText(
                  enableInteractiveSelection: true,
                  (widget.workOrder.vehiclePlate?.isNotEmpty ?? false)
                      ? widget.workOrder.vehiclePlate!
                      : "-",
                  style: _expTileChildValueStyle)),
        ]),
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
              child: SelectableText(
                  enableInteractiveSelection: true,
                  widget.workOrder.clientRequest,
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
              child: SelectableText(
                  enableInteractiveSelection: true,
                  onTap: (widget.workOrder.phone?.isNotEmpty ?? false)
                      ? _handlePhoneTapped
                      : null,
                  (widget.workOrder.phone?.isNotEmpty ?? false)
                      ? widget.workOrder.phone!
                      : "-",
                  style: (widget.workOrder.phone?.isNotEmpty ?? false)
                      ? _expTileChildValueStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)
                      : _expTileChildValueStyle)),
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
              child: Text("Observações:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
            child: SelectableText(
              enableInteractiveSelection: true,
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
              child: Text("Pendências:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
            child: SelectableText(
              enableInteractiveSelection: true,
              (widget.workOrder.pendencies?.isNotEmpty ?? false)
                  ? widget.workOrder.pendencies!
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
            child: SelectableText(
              enableInteractiveSelection: true,
              widget.workOrder.orderOpeningDatetime,
              style: _expTileChildValueStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8.0, 4.0, 5.0),
              child: Text("Finalizado em:", style: _expTileChildKeyStyle)),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 15.0, 5.0),
            child: SelectableText(
              enableInteractiveSelection: true,
              (widget.workOrder.orderClosingDatetime?.isNotEmpty ?? false)
                  ? widget.workOrder.orderClosingDatetime!
                  : "-",
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
            child: SelectableText(
              enableInteractiveSelection: true,
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
        const SizedBox(width: 25, height: 5),
        _buildToCancelledButton(),
        const SizedBox(width: 25, height: 5),
        _buildEditButton(),
      ];
    } else if (widget.workOrder.status == "ongoing") {
      buttonList = [
        _buildToCancelledButton(),
        const SizedBox(width: 25, height: 5),
        _buildToWaitingButton(),
        const SizedBox(width: 25, height: 5),
        _buildToFinishedButton(),
        const SizedBox(width: 25, height: 5),
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
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
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
                    phone: widget.workOrder.phone,
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
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
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
                    phone: widget.workOrder.phone,
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
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).hoverColor),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (context) =>
                _buildButtonAlertDialog("Finalizar ordem de serviço?", () {
                  var currentDateTime =
                      DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());
                  var workOrder = WorkOrder(
                    id: widget.workOrder.id,
                    dayId: widget.workOrder.dayId,
                    status: 'finished',
                    priority: widget.workOrder.priority,
                    orderOpeningDatetime: widget.workOrder.orderOpeningDatetime,
                    orderClosingDatetime: currentDateTime,
                    client: widget.workOrder.client,
                    phone: widget.workOrder.phone,
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
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
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
                    phone: widget.workOrder.phone,
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
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(190, 0),
            backgroundColor: Theme.of(context).highlightColor),
        onPressed: () {
          BlocProvider.of<WorkOrderEditorBloc>(context)
              .add(WorkOrderEditorAddEvent(workOrder: widget.workOrder));
          _showWorkOrderEditorDialog();
        },
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
              onPressed: () {
                Navigator.pop(context, "Sim");
                yesCallback();
              },
              child: const Text("Sim")),
          TextButton(
              onPressed: () => Navigator.pop(context, "Não"),
              child: const Text("Não"))
        ]);
  }

  Future _saveWorkOrder(WorkOrder workOrder) async {
    context.loaderOverlay.show();
    try {
      await WorkOrderApiServices.putWorkOrder(workOrder);
      BlocProvider.of<WorkOrderListBloc>(context)
          .add(WorkOrderListFetchEvent());
    } catch (e) {
      BlocProvider.of<WorkOrderEditorBloc>(context)
          .add(WorkOrderEditorErrorEvent(error: e.toString()));
    }
    context.loaderOverlay.hide();
  }

  Future _showWorkOrderEditorDialog() async {
    showDialog(
        context: context,
        builder: (context) =>
            WorkOrderEditorDialogUi(workOrder: widget.workOrder)).then(
        (value) => BlocProvider.of<WorkOrderListBloc>(context)
            .add(WorkOrderListFetchEvent()));
  }

  void _handlePhoneTapped() {
    if (widget.workOrder.phone == null) return;
    String rawPhone = widget.workOrder.phone!.replaceAll(RegExp(r"\D"), "");
    if (rawPhone.length < 10) {
      rawPhone = "44$rawPhone";
    }
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text('${widget.workOrder.phone}'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await launchUrl(
                        Uri.parse(
                            'https://api.whatsapp.com/send?phone=55$rawPhone'),
                        mode: LaunchMode.externalApplication);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.whatsapp),
                      SizedBox(width: 5),
                      Text('WhatsApp')
                    ],
                  )),
              TextButton(
                onPressed: () async {
                  await launchUrl(Uri.parse("tel:${widget.workOrder.phone}"));
                  Navigator.pop(context);
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(Icons.phone),
                  SizedBox(width: 5),
                  Text('Ligação')
                ]),
              )
            ],
          )),
    );
  }
}
