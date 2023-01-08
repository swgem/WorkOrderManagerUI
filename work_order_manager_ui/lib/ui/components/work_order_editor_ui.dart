import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/api/work_order_api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';

class WorkOrderEditorUi extends StatefulWidget {
  final WorkOrder? workOrder;
  const WorkOrderEditorUi({super.key, required this.workOrder});

  @override
  State<WorkOrderEditorUi> createState() => _WorkOrderEditorUiState();
}

class _WorkOrderEditorUiState extends State<WorkOrderEditorUi> {
  late GlobalKey<FormState> formKey;

  late Key _clientFieldKey;

  late FocusNode _phoneFocusNode;
  late FocusNode _clientFocusNode;

  late ScrollController _scrollController;
  late TextEditingController _clientController;
  late TextEditingController _phoneController;
  late TextEditingController _vehicleController;
  late TextEditingController _vehiclePlateController;
  late TextEditingController _requestedServiceController;
  late TextEditingController _deadlineController;
  late TextEditingController _remarksController;
  late TextStyle _textFieldTextStyle;
  late TextStyle _textFieldLabelStyle;
  late TextStyle _textFieldLabelAsteriskStyle;
  late MaskTextInputFormatter _maskPhone;
  late MaskTextInputFormatter _maskVehiclePlate;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    _clientFieldKey = GlobalKey();
    _phoneFocusNode = FocusNode()
      ..addListener(() {
        if (_phoneFocusNode.hasFocus) {
          _maskPhone.updateMask(mask: '###########');
        } else {
          if (_phoneController.text.length == 8) {
            _maskPhone.updateMask(mask: '####-####');
          } else if (_phoneController.text.length == 9) {
            _maskPhone.updateMask(mask: '#####-####');
          } else if (_phoneController.text.length == 10) {
            _maskPhone.updateMask(mask: '(##) ####-####');
          } else if (_phoneController.text.length == 11) {
            _maskPhone.updateMask(mask: '(##) #####-####');
          }
        }
        _phoneController.text = _maskPhone.maskText(_phoneController.text);
      });
    _clientFocusNode = FocusNode();
    _scrollController = ScrollController();
    _clientController = TextEditingController();
    _phoneController = TextEditingController();
    _vehicleController = TextEditingController();
    _vehiclePlateController = TextEditingController();
    _requestedServiceController = TextEditingController();
    _deadlineController = TextEditingController();
    _remarksController = TextEditingController();

    _maskPhone = MaskTextInputFormatter(
        mask: '###########', filter: {'#': RegExp(r'[0-9]')});
    _maskVehiclePlate = MaskTextInputFormatter(
        mask: 'xxxxxxxx', filter: {'x': RegExp(r'[0-9a-zA-Z-]')});

    _inputInitialValues();
    _clientFocusNode.requestFocus();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _textFieldTextStyle = Theme.of(context).textTheme.titleMedium!;
    _textFieldLabelStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(color: Theme.of(context).hintColor);
    _textFieldLabelAsteriskStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkOrderEditorBloc, WorkOrderEditorState>(
      bloc: BlocProvider.of(context),
      listener: (context, state) {
        if (state is WorkOrderEditorRequestedSaveState) {
          BlocProvider.of<WorkOrderEditorBloc>(context)
              .add(WorkOrderEditorEditEvent());
          if (formKey.currentState!.validate()) {
            showDialog<String>(
                context: context,
                builder: (context) => _buildButtonAlertDialog());
          }
        }
      },
      buildWhen: (previous, current) =>
          ((current is! WorkOrderEditorSavingState) &&
              (current is! WorkOrderEditorSavedState)),
      builder: (context, state) => _buildForm(),
    );
  }

  void _inputInitialValues() {
    _clientController.text = widget.workOrder?.client ?? "";
    _phoneController.text = widget.workOrder?.phone ?? "";
    _vehicleController.text = widget.workOrder?.vehicle ?? "";
    _vehiclePlateController.text = widget.workOrder?.vehiclePlate ?? "";
    _requestedServiceController.text = widget.workOrder?.clientRequest ?? "";
    _deadlineController.text = widget.workOrder?.deadline ?? "";
    _remarksController.text = widget.workOrder?.remarks ?? "";

    _maskPhone = MaskTextInputFormatter(
        mask: '###########', filter: {'#': RegExp(r'[0-9]')});
  }

  Widget _buildForm() {
    return FocusTraversalGroup(
      child: Form(
          key: formKey,
          child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        key: _clientFieldKey,
                        focusNode: _clientFocusNode,
                        controller: _clientController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        style: _textFieldTextStyle,
                        validator: (value) =>
                            (value!.isEmpty) ? "Insira o cliente" : null,
                        decoration: InputDecoration(
                            label:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text("Cliente", style: _textFieldLabelStyle),
                              Text("*", style: _textFieldLabelAsteriskStyle)
                            ]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        focusNode: _phoneFocusNode,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_maskPhone],
                        textInputAction: TextInputAction.next,
                        style: _textFieldTextStyle,
                        decoration: InputDecoration(
                            label:
                                Text("Telefone", style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: TextFormField(
                      controller: _vehicleController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      style: _textFieldTextStyle,
                      validator: (value) =>
                          (value!.isEmpty) ? "Insira o veículo" : null,
                      decoration: InputDecoration(
                          label: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("Veículo", style: _textFieldLabelStyle),
                            Text("*", style: _textFieldLabelAsteriskStyle)
                          ]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        controller: _vehiclePlateController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          _maskVehiclePlate,
                          UpperCaseTextFormatter()
                        ],
                        textInputAction: TextInputAction.next,
                        style: _textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Placa do veículo",
                                style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: TextFormField(
                      controller: _requestedServiceController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: _textFieldTextStyle,
                      validator: (value) => (value!.isEmpty)
                          ? "Insira a descrição serviço"
                          : null,
                      decoration: InputDecoration(
                          label: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("Descrição do serviço",
                                style: _textFieldLabelStyle),
                            Text("*", style: _textFieldLabelAsteriskStyle)
                          ]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        focusNode: FocusNode(onKey: (node, event) {
                          if (event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey == LogicalKeyboardKey.space) {
                            _openDeadlineDateTimePicker();
                            return KeyEventResult.handled;
                          } else {
                            return KeyEventResult.ignored;
                          }
                        }),
                        controller: _deadlineController,
                        readOnly: true,
                        enabled: true,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        style: _textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Prazo", style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: _openDeadlineDateTimePicker,
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        controller: _remarksController,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: _textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Observações",
                                style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  const SizedBox(height: 10.0)
                ]),
              ))),
    );
  }

  Widget _buildButtonAlertDialog() {
    return AlertDialog(
        title: const Text("Salvar ordem de serviço"),
        content:
            const Text("Tem certeza que deseja salvar a ordem de serviço?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, "Sim");
                if (_phoneController.text.isEmpty) {
                  showDialog<String>(
                      context: context,
                      builder: (context) => _buildEmptyPhoneAlertDialog());
                } else {
                  _saveWorkOrder();
                }
              },
              child: const Text("Sim")),
          TextButton(
              onPressed: () {
                BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorEditEvent());
                Navigator.pop(context, "Não");
              },
              child: const Text("Não"))
        ]);
  }

  Widget _buildEmptyPhoneAlertDialog() {
    return AlertDialog(
        title: const Text("Telefone não inserido"),
        content: const Text("Tem certeza que deseja salvar sem telefone?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, "Sim");
                _saveWorkOrder();
              },
              child: const Text("Sim")),
          TextButton(
              onPressed: () {
                BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorEditEvent());
                Navigator.pop(context, "Não");
              },
              child: const Text("Não"))
        ]);
  }

  Future _openDeadlineDateTimePicker() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2999));
    if (date == null) {
      return;
    }
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 18, minute: 0),
        initialEntryMode: TimePickerEntryMode.input);
    if (time == null) {
      return;
    }
    String dateString =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    String timeString =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    _deadlineController.text = '$dateString $timeString';
  }

  Future _saveWorkOrder() async {
    context.loaderOverlay.show();
    BlocProvider.of<WorkOrderEditorBloc>(context)
        .add(WorkOrderEditorSavingEvent());
    var currentDateTime =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var newWorkOrder = WorkOrder(
      id: widget.workOrder?.id ?? 0,
      dayId: widget.workOrder?.dayId ?? 0,
      status: widget.workOrder?.status ?? WorkOrderStatus.waiting.name,
      priority: widget.workOrder?.priority ?? 0,
      orderOpeningDatetime:
          widget.workOrder?.orderOpeningDatetime ?? currentDateTime,
      orderClosingDatetime: widget.workOrder?.orderClosingDatetime,
      client: _clientController.text,
      phone: _phoneController.text,
      vehicle: _vehicleController.text,
      vehiclePlate: _vehiclePlateController.text,
      clientRequest: _requestedServiceController.text,
      pendencies: widget.workOrder?.pendencies,
      deadline: _deadlineController.text,
      remarks: _remarksController.text,
    );

    try {
      if (widget.workOrder == null) {
        await WorkOrderApiServices.postWorkOrder(newWorkOrder);
      } else {
        await WorkOrderApiServices.putWorkOrder(newWorkOrder);
      }
      BlocProvider.of<WorkOrderEditorBloc>(context)
          .add(WorkOrderEditorSavedEvent());
    } catch (e) {
      BlocProvider.of<WorkOrderEditorBloc>(context)
          .add(WorkOrderEditorEditEvent());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      ));
    }
    context.loaderOverlay.hide();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
