import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/components/work_order_card_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_tile_ui.dart';
import 'package:work_order_manager_ui/ui/responsive.dart';

class WorkOrderListUi extends StatefulWidget {
  const WorkOrderListUi({super.key});

  @override
  State<WorkOrderListUi> createState() => _WorkOrderListUiState();
}

class _WorkOrderListUiState extends State<WorkOrderListUi> {
  late ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: RefreshIndicator(
        onRefresh: () => Future(() =>
            BlocProvider.of<WorkOrderListBloc>(context)
                .add(WorkOrderListFetchEvent())),
        child: BlocConsumer<WorkOrderListBloc, WorkOrderListState>(
            bloc: BlocProvider.of(context),
            listener: (context, state) {
              if (state is WorkOrderListLoadingState) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            },
            buildWhen: (previous, current) =>
                (current is! WorkOrderListLoadingState),
            builder: (context, state) {
              if (state is WorkOrderListSucessState) {
                return _buildWorkOrderList(state.workOrders);
              } else if (state is WorkOrderListEmptyState) {
                return _buildEmpty();
              } else if (state is WorkOrderListErrorState) {
                return _buildError();
              } else /* if (state is WorkOrderListBlankState) */ {
                return _buildBlank();
              }
            }),
      ),
    );
  }

  Widget _buildWorkOrderList(List<WorkOrder> workOrders) {
    return FocusTraversalGroup(
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 150.0),
            itemCount: workOrders.length,
            itemBuilder: (content, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: (Responsive.platform(context) == Platform.mobile)
                      ? WorkOrderCardUi(workOrder: workOrders[index])
                      : WorkOrderTileUi(workOrder: workOrders[index]));
            }),
      ),
    );
  }

  Widget _buildEmpty() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          ListView(children: [
        SizedBox(
            height: constraints.maxHeight,
            child: const Center(child: Text("Não há ordens de serviço")))
      ]),
    );
  }

  Widget _buildError() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          ListView(children: [
        SizedBox(
            height: constraints.maxHeight,
            child:
                const Center(child: Text("Erro ao carregar ordens de serviço")))
      ]),
    );
  }

  Widget _buildBlank() {
    return Container();
  }
}
