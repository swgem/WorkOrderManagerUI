import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_editor_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/shared/work_order_status.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_list_ui.dart';
import 'package:work_order_manager_ui/ui/dialogs/work_order_editor_dialog_ui.dart';
import 'package:work_order_manager_ui/ui/dialogs/work_order_list_info_dialog_ui.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_editor_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/responsive_page_ui.dart';

abstract class WorkOrderListSharedPageUi extends StatefulWidget {
  final String pageTitle;
  final List<WorkOrderStatus>? statusFilter;
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
      mobileAppBar: _buildMobileTabletAppBar(),
      tabletAppBar: _buildMobileTabletAppBar(),
      desktopAppBar: _buildDesktopAppBar(),
      mobileBody: _buildMobileTabletBody(),
      tabletBody: _buildMobileTabletBody(),
      desktopBody: _buildDesktopBody(),
      mobileFloatingActionButton: _buildMobileTabletFloatingActionButton(),
      tabletFloatingActionButton: _buildMobileTabletFloatingActionButton(),
      desktopFloatingActionButton: null,
      mobileDrawer: const DrawerUi(),
      tabletDrawer: const DrawerUi(),
      desktopDrawer: const DrawerUi(),
    );
  }

  PreferredSizeWidget _buildMobileTabletAppBar() {
    return AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(widget.pageTitle),
      const Spacer(),
      IconButton(
          onPressed: _refreshWorkOrders,
          tooltip: "Atualizar lista de ordens de serviço",
          icon: const Icon(Icons.refresh))
    ]));
  }

  PreferredSizeWidget _buildDesktopAppBar() {
    return AppBar(title: Text(widget.pageTitle));
  }

  Widget? _buildMobileTabletFloatingActionButton() {
    return (widget.hasAddWorkOrderButton)
        ? FloatingActionButton(
            onPressed: () {
              BlocProvider.of<WorkOrderEditorBloc>(context)
                  .add(WorkOrderEditorEditEvent());
              _navigateToWorkOrderEditorPage();
            },
            tooltip: "Adicionar ordem de serviço",
            child: const Icon(Icons.add))
        : null;
  }

  Widget _buildMobileTabletBody() {
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
                    Flexible(
                      flex: 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                                height: 70,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: _buildSearchField())),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: IconButton(
                                onPressed: _showInfoDialog,
                                tooltip: "Informações da lista de ordens",
                                icon: const Icon(Icons.info_outlined)),
                          )
                        ],
                      ),
                    ),
                    const Expanded(child: WorkOrderListUi())
                  ],
                )))
      ],
    );
  }

  Widget _buildDesktopBody() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              child: Column(children: [
                SizedBox(
                    height: 70,
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 450),
                                  child: _buildSearchField(),
                                ),
                              ),
                              const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 0,
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
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: IconButton(
                                onPressed: _showInfoDialog,
                                tooltip:
                                    "Informações da lista de ordens de serviço",
                                icon: const Icon(Icons.info_outlined)),
                          ),
                        ),
                      )
                    ])),
                const Expanded(child: WorkOrderListUi()),
              ])))
    ]);
  }

  Widget _buildSearchField() {
    return TextField(
        onChanged: _requestSearch,
        onSubmitted: _requestSearch,
        decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: UnderlineInputBorder(),
            labelText: 'Pesquisar'));
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
            .add(WorkOrderEditorEditEvent());
        _showWorkOrderEditorDialog();
      },
    );
  }

  void _navigateToWorkOrderEditorPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const WorkOrderEditorPageUi())));
  }

  void _showWorkOrderEditorDialog() {
    showDialog(
        context: context,
        builder: (context) => const WorkOrderEditorDialogUi(workOrder: null));
  }

  void _showInfoDialog() {
    showDialog(
        context: context,
        builder: (context) => const WorkOrderListInfoDialogUi());
  }

  void _requestSearch(String value) {
    if (value.isNotEmpty) {
      BlocProvider.of<WorkOrderListBloc>(context)
          .add(WorkOrderSearchEvent(text: value));
    } else {
      BlocProvider.of<WorkOrderListBloc>(context)
          .add(WorkOrderCancelSearchEvent());
    }
  }

  void _refreshWorkOrders() {
    BlocProvider.of<WorkOrderListBloc>(context).add(WorkOrderListFetchEvent());
  }
}
