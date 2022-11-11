import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_state.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
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
  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorkOrderListBloc>(context).add(
        WorkOrderListLoadStatusFilterEvent(status: ["waiting", "ongoing"]));
    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageUi(
      appBar: _buildAppBar(),
      mobileBody: _buildMobileBody(),
      tabletBody: _buildTabletDesktopBody(),
      desktopBody: _buildTabletDesktopBody(),
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
              .add(WorkOrderListFetchEvent()),
          icon: const Icon(Icons.refresh))
    ]));
  }

  Widget _buildMobileFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          BlocProvider.of<WorkOrderEditorBloc>(context)
              .add(WorkOrderEditorAddEvent());
          _navigateToWorkOrderEditorPage();
        },
        tooltip: "Adicionar ordem de serviço",
        child: const Icon(Icons.add));
  }

  Widget _buildTabletFloatingActionButton() {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () => BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorAddEvent()),
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
        child: _buildEditorButtons(),
      )
    ]);
  }

  Widget _buildDesktopFloatingActionButton() {
    return Row(children: [
      const SizedBox(width: 300),
      Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () => BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorAddEvent()),
                tooltip: "Adicionar ordem de serviço",
                heroTag: "addButton",
                label: Row(children: const [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Adicionar')
                ]))
          ])),
      Expanded(
        flex: 1,
        child: _buildEditorButtons(),
      )
    ]);
  }

  Widget _buildEditorButtons() {
    return BlocBuilder<WorkOrderEditorBloc, WorkOrderEditorState>(
      bloc: BlocProvider.of(context),
      builder: ((context, state) {
        if (state is WorkOrderListEmptyState) {
          return const SizedBox();
        } else if (state is WorkOrderEditorEditingState) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
                onPressed: () => BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorClearEvent()),
                tooltip: "Descartar alterações",
                heroTag: "discardButton",
                label: Row(children: [
                  Icon(
                      (state.workOrder == null) ? Icons.delete : Icons.restore),
                  const SizedBox(width: 8),
                  const Text('Descartar')
                ])),
            const SizedBox(width: 8),
            FloatingActionButton.extended(
                onPressed: () => BlocProvider.of<WorkOrderEditorBloc>(context)
                    .add(WorkOrderEditorSaveEvent()),
                tooltip: "Salvar ordem de serviço",
                heroTag: "saveButton",
                label: Row(children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Salvar')
                ]))
          ]);
        } else {
          return const SizedBox();
        }
      }),
    );
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
        child: const WorkOrderListUi());
  }

  Widget _buildTabletDesktopBody() {
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
              child: const WorkOrderListUi()),
        ),
        Expanded(
            flex: 1,
            child: BlocListener<WorkOrderEditorBloc, WorkOrderEditorState>(
              bloc: BlocProvider.of(context),
              listener: (context, state) {
                if (state is WorkOrderEditorSavedState) {
                  BlocProvider.of<WorkOrderEditorBloc>(context)
                      .add(WorkOrderEditorClearEvent());
                  BlocProvider.of<WorkOrderListBloc>(context)
                      .add(WorkOrderListFetchEvent());
                } else if (state is WorkOrderEditorErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    duration: const Duration(seconds: 5),
                  ));
                }
              },
              child: const WorkOrderEditorUi(),
            ))
      ],
    );
  }

  Future _navigateToWorkOrderEditorPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderEditorPageUi()))).then(
        (value) => BlocProvider.of<WorkOrderListBloc>(context)
            .add(WorkOrderListFetchEvent()));
  }
}
