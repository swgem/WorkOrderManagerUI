import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_list_ui.dart';
import 'package:work_order_manager_ui/ui/dialogs/work_order_editor_dialog_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/responsive_page_ui.dart';

abstract class WorkOrderListSharedPageUi extends StatefulWidget {
  final String pageTitle;
  final List<String>? statusFilter;
  final bool hasAddWorkOrderButton;

  const WorkOrderListSharedPageUi(
      {super.key,
      required this.pageTitle,
      this.statusFilter,
      required this.hasAddWorkOrderButton});

  @override
  State<WorkOrderListSharedPageUi> createState() =>
      _WorkOrderListSharedPageUiState();
}

class _WorkOrderListSharedPageUiState extends State<WorkOrderListSharedPageUi> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListClearEvent());
    BlocProvider.of<WorkOrderListBloc>(context)
        .add(WorkOrderListLoadStatusFilterEvent(status: widget.statusFilter));
    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageUi(
      mobileAppBar: _buildMobileAppBar(),
      tabletAppBar: _buildTabletDesktopAppBar(),
      desktopAppBar: _buildTabletDesktopAppBar(),
      mobileBody: _buildMobileBody(),
      tabletBody: _buildTabletDesktopBody(),
      desktopBody: _buildTabletDesktopBody(),
      mobileFloatingActionButton: _buildMobileFloatingActionButton(),
      tabletFloatingActionButton: null,
      desktopFloatingActionButton: null,
      mobileDrawer: const DrawerUi(),
      tabletDrawer: const DrawerUi(),
      desktopDrawer: const DrawerUi(),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(widget.pageTitle),
      const Spacer(),
      IconButton(onPressed: _refreshWorkOrders, icon: const Icon(Icons.refresh))
    ]));
  }

  PreferredSizeWidget _buildTabletDesktopAppBar() {
    return AppBar(title: Text(widget.pageTitle));
  }

  Widget? _buildMobileFloatingActionButton() {
    return (widget.hasAddWorkOrderButton)
        ? FloatingActionButton(
            onPressed: () {
              BlocProvider.of<WorkOrderEditorBloc>(context)
                  .add(WorkOrderEditorAddEvent());
              _navigateToWorkOrderEditorPage();
            },
            tooltip: "Adicionar ordem de serviço",
            child: const Icon(Icons.add))
        : null;
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
              child: Column(
                children: [
                  SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.hasAddWorkOrderButton,
                            child: Row(
                              children: [
                                _buildAddWorkOrderButton(),
                                const SizedBox(width: 25),
                              ],
                            ),
                          ),
                          _buildRefreshButton()
                        ],
                      )),
                  const Expanded(child: WorkOrderListUi()),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: "Atualizar lista de ordens de serviço",
        onPressed: _refreshWorkOrders);
  }

  Widget _buildAddWorkOrderButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: "Adicionar ordem de serviço",
      onPressed: () {
        BlocProvider.of<WorkOrderEditorBloc>(context)
            .add(WorkOrderEditorAddEvent());
        _showWorkOrderEditorDialog();
      },
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

  Future _showWorkOrderEditorDialog() async {
    await showDialog(
        context: context,
        builder: (context) =>
            const WorkOrderEditorDialogUi(workOrder: null)).then((value) =>
        BlocProvider.of<WorkOrderListBloc>(context)
            .add(WorkOrderListFetchEvent()));
  }

  void _refreshWorkOrders() {
    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListFetchEvent());
  }
}
