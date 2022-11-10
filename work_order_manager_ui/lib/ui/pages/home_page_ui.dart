import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/stream/work_order_editor_event.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_editor_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_list_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/responsive_page_ui.dart';

class HomePageUi extends StatefulWidget {
  static const String routeName = '/homePage';
  const HomePageUi({super.key});

  @override
  State<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi> {
  late final StreamController<WorkOrderEditorEvent> eventController;
  final List<String> _workOrderStatus = ["waiting", "ongoing"];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorkOrderListBloc>(context)
        .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus));
    eventController = StreamController<WorkOrderEditorEvent>.broadcast();
  }

  @override
  void dispose() {
    super.dispose();

    eventController.close();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageUi(
      appBar: _buildAppBar(),
      mobileBody: _buildMobileBody(),
      tabletBody: _buildTabletBody(),
      desktopBody: _buildDesktopBody(),
      mobileFloatingActionButton: _buildMobileFloatingActionButton(),
      tabletFloatingActionButton: _buildTabletFloatingActionButton(),
      desktopFloatingActionButton: _buildDesktopFloatingActionButton(),
      mobileDrawer: const DrawerUi(),
      tabletDrawer: const DrawerUi(),
      desktopDrawer: const DrawerUi(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Text('Início'),
      const Spacer(),
      IconButton(
          onPressed: () => BlocProvider.of<WorkOrderListBloc>(context)
              .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus)),
          icon: const Icon(Icons.refresh))
    ]));
  }

  Widget _buildMobileFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () => _navigateToWorkOrderInserter(),
        tooltip: "Adicionar ordem de serviço",
        child: const Icon(Icons.add));
  }

  Widget _buildTabletFloatingActionButton() {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () => _navigateToWorkOrderInserter(),
                tooltip: "Adicionar ordem de serviço",
                heroTag: "addButton",
                label: Row(children: const [
                  Icon(Icons.add),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Adicionar')
                ]))
          ])),
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () {},
                tooltip: "Salvar ordem de serviço",
                heroTag: "saveButton",
                label: Row(children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Salvar')
                ]))
          ])),
    ]);
  }

  Widget _buildDesktopFloatingActionButton() {
    return Row(children: [
      const SizedBox(width: 300),
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () => _navigateToWorkOrderInserter(),
                tooltip: "Adicionar ordem de serviço",
                heroTag: "addButton",
                label: Row(children: const [
                  Icon(Icons.add),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Adicionar')
                ]))
          ])),
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () {},
                tooltip: "Salvar ordem de serviço",
                heroTag: "saveButton",
                label: Row(children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Salvar')
                ]))
          ])),
    ]);
  }

  Widget _buildMobileBody() {
    return BlocListener(
        bloc: BlocProvider.of<WorkOrderListBloc>(context),
        listener: (context, state) {
          if (state is WorkOrderListErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message.toString()),
                duration: const Duration(seconds: 5)));
          }
        },
        child: WorkOrderListUi(
          workOrderStatus: _workOrderStatus,
        ));
  }

  Widget _buildTabletBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: BlocListener(
              bloc: BlocProvider.of<WorkOrderListBloc>(context),
              listener: (context, state) {
                if (state is WorkOrderListErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message.toString()),
                      duration: const Duration(seconds: 5)));
                }
              },
              child: WorkOrderListUi(
                workOrderStatus: _workOrderStatus,
              )),
        ),
        Expanded(
            flex: 1,
            child: WorkOrderEditorUi(parentEvent: eventController.stream))
      ],
    );
  }

  Widget _buildDesktopBody() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: BlocListener(
                bloc: BlocProvider.of<WorkOrderListBloc>(context),
                listener: (context, state) {
                  if (state is WorkOrderListErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message.toString()),
                        duration: const Duration(seconds: 5)));
                  }
                },
                child: WorkOrderListUi(
                  workOrderStatus: _workOrderStatus,
                )),
          ),
          Expanded(
              flex: 1,
              child: WorkOrderEditorUi(parentEvent: eventController.stream))
        ],
      ),
    );
  }

  Future _navigateToWorkOrderInserter() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderEditorPageUi()))).then(
        (value) => BlocProvider.of<WorkOrderListBloc>(context)
            .add(WorkOrderListFetchByStatusEvent(status: _workOrderStatus)));
  }
}
