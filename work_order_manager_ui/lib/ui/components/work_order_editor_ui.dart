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

  late ScrollController scrollController;
  late TextEditingController clientController;
  late TextEditingController phoneController;
  late TextEditingController vehicleController;
  late TextEditingController vehiclePlateController;
  late TextEditingController requestedServiceController;
  late TextEditingController deadlineController;
  late TextEditingController remarksController;
  late TextEditingController pendenciesController;
  late TextStyle textFieldTextStyle;
  late TextStyle textFieldLabelStyle;
  late TextStyle textFieldLabelAsteriskStyle;
  late InputDecorationTheme textFormFieldDecoration;
  late MaskTextInputFormatter _maskPhone;
  late MaskTextInputFormatter _maskVehiclePlate;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    _clientFieldKey = GlobalKey();
    _phoneFocusNode = FocusNode()
      ..addListener(() {
        if (_phoneFocusNode.hasFocus) {
          _maskPhone.updateMask(mask: '###########');
        } else {
          if (phoneController.text.length == 8) {
            _maskPhone.updateMask(mask: '####-####');
          } else if (phoneController.text.length == 9) {
            _maskPhone.updateMask(mask: '#####-####');
          } else if (phoneController.text.length == 10) {
            _maskPhone.updateMask(mask: '(##) ####-####');
          } else if (phoneController.text.length == 11) {
            _maskPhone.updateMask(mask: '(##) #####-####');
          }
        }
        phoneController.text = _maskPhone.maskText(phoneController.text);
      });
    _clientFocusNode = FocusNode();
    scrollController = ScrollController();
    clientController = TextEditingController();
    phoneController = TextEditingController();
    vehicleController = TextEditingController();
    vehiclePlateController = TextEditingController();
    requestedServiceController = TextEditingController();
    deadlineController = TextEditingController();
    remarksController = TextEditingController();
    pendenciesController = TextEditingController();

    _maskPhone = MaskTextInputFormatter(
        mask: '###########', filter: {'#': RegExp(r'[0-9]')});
    _maskVehiclePlate = MaskTextInputFormatter(
        mask: 'xxxxxxxx', filter: {'x': RegExp(r'[0-9a-zA-Z-]')});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textFieldTextStyle = Theme.of(context).textTheme.titleMedium!;
    textFieldLabelStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(color: Theme.of(context).hintColor);
    textFieldLabelAsteriskStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red);
    textFormFieldDecoration = Theme.of(context).inputDecorationTheme;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkOrderEditorBloc, WorkOrderEditorState>(
      bloc: BlocProvider.of(context),
      listener: (context, state) {
        if (state is WorkOrderEditorSavingState) {
          if (formKey.currentState!.validate()) {
            showDialog<String>(
                context: context,
                builder: (context) => _buildButtonAlertDialog());
          }
        } else if (state is WorkOrderEditorSavedState ||
            state is WorkOrderEditorErrorState) {
          context.loaderOverlay.hide();
        }
      },
      child: BlocBuilder<WorkOrderEditorBloc, WorkOrderEditorState>(
        bloc: BlocProvider.of(context),
        buildWhen: (previous, current) =>
            (current is! WorkOrderEditorSavingState) &&
            (current is! WorkOrderEditorSavedState) &&
            (current is! WorkOrderEditorErrorState),
        builder: _buildBloc,
      ),
    );
  }

  void _inputInitialValues() {
    clientController.text = widget.workOrder?.client ?? "";
    phoneController.text = widget.workOrder?.phone ?? "";
    vehicleController.text = widget.workOrder?.vehicle ?? "";
    vehiclePlateController.text = widget.workOrder?.vehiclePlate ?? "";
    requestedServiceController.text = widget.workOrder?.clientRequest ?? "";
    deadlineController.text = widget.workOrder?.deadline ?? "";
    pendenciesController.text = widget.workOrder?.pendencies ?? "";
    remarksController.text = widget.workOrder?.remarks ?? "";

    _maskPhone = MaskTextInputFormatter(
        mask: '###########', filter: {'#': RegExp(r'[0-9]')});
  }

  Widget _buildBloc(BuildContext context, WorkOrderEditorState state) {
    _inputInitialValues();
    _clientFocusNode.requestFocus();

    return _buildForm();
  }

  Widget _buildForm() {
    return FocusTraversalGroup(
      child: Form(
          key: formKey,
          child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        key: _clientFieldKey,
                        focusNode: _clientFocusNode,
                        controller: clientController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        style: textFieldTextStyle,
                        validator: (value) =>
                            (value!.isEmpty) ? "Insira o cliente" : null,
                        decoration: InputDecoration(
                            label:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text("Cliente", style: textFieldLabelStyle),
                              Text("*", style: textFieldLabelAsteriskStyle)
                            ]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        focusNode: _phoneFocusNode,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_maskPhone],
                        textInputAction: TextInputAction.next,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Telefone", style: textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: TextFormField(
                      controller: vehicleController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      style: textFieldTextStyle,
                      validator: (value) =>
                          (value!.isEmpty) ? "Insira o veículo" : null,
                      decoration: InputDecoration(
                          label: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("Veículo", style: textFieldLabelStyle),
                            Text("*", style: textFieldLabelAsteriskStyle)
                          ]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        controller: vehiclePlateController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          _maskVehiclePlate,
                          UpperCaseTextFormatter()
                        ],
                        textInputAction: TextInputAction.next,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Placa do veículo",
                                style: textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: TextFormField(
                      controller: requestedServiceController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: textFieldTextStyle,
                      validator: (value) => (value!.isEmpty)
                          ? "Insira a descrição serviço"
                          : null,
                      decoration: InputDecoration(
                          label: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text("Descrição do serviço",
                                style: textFieldLabelStyle),
                            Text("*", style: textFieldLabelAsteriskStyle)
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
                        controller: deadlineController,
                        readOnly: true,
                        enabled: true,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                            label: Text("Prazo", style: textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: _openDeadlineDateTimePicker,
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        controller: remarksController,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                            label:
                                Text("Observações", style: textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: TextFormField(
                        controller: pendenciesController,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                            label:
                                Text("Pendências", style: textFieldLabelStyle),
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
                if (phoneController.text.isEmpty) {
                  showDialog<String>(
                      context: context,
                      builder: (context) => _buildEmptyPhoneAlertDialog());
                } else {
                  context.loaderOverlay.show();
                  _saveWorkOrder();
                }
              },
              child: const Text("Sim")),
          TextButton(
              onPressed: () => Navigator.pop(context, "Não"),
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
                context.loaderOverlay.show();
                _saveWorkOrder();
              },
              child: const Text("Sim")),
          TextButton(
              onPressed: () => Navigator.pop(context, "Não"),
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
    deadlineController.text = '$dateString $timeString';
  }

  Future _saveWorkOrder() async {
    var currentDateTime =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var newWorkOrder = WorkOrder(
      id: widget.workOrder?.id ?? 0,
      dayId: widget.workOrder?.dayId ?? 0,
      status: widget.workOrder?.status ?? "waiting",
      priority: widget.workOrder?.priority ?? 0,
      orderOpeningDatetime:
          widget.workOrder?.orderOpeningDatetime ?? currentDateTime,
      orderClosingDatetime: widget.workOrder?.orderClosingDatetime,
      client: clientController.text,
      phone: phoneController.text,
      vehicle: vehicleController.text,
      vehiclePlate: vehiclePlateController.text,
      clientRequest: requestedServiceController.text,
      pendencies: pendenciesController.text,
      deadline: deadlineController.text,
      remarks: remarksController.text,
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
          .add(WorkOrderEditorErrorEvent(error: e.toString()));
    }
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
