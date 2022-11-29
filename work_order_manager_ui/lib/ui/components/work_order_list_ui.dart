import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/ui/components/work_order_card_ui.dart';

class WorkOrderListUi extends StatefulWidget {
  const WorkOrderListUi({super.key});

  @override
  State<WorkOrderListUi> createState() => _WorkOrderListUiState();
}

class _WorkOrderListUiState extends State<WorkOrderListUi> {
  late ScrollController scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: RefreshIndicator(
        onRefresh: () => Future(() =>
            BlocProvider.of<WorkOrderListBloc>(context)
                .add(WorkOrderListFetchEvent())),
        child: BlocListener<WorkOrderListBloc, WorkOrderListState>(
          bloc: BlocProvider.of(context),
          listener: (context, state) {
            if (state is WorkOrderListLoadingState) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          },
          child: BlocBuilder<WorkOrderListBloc, WorkOrderListState>(
              bloc: BlocProvider.of(context),
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
      ),
    );
  }

  Widget _buildWorkOrderList(List<WorkOrder> workOrders) {
    return FocusTraversalGroup(
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 7.0, bottom: 150.0),
            itemCount: workOrders.length,
            itemBuilder: (content, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: WorkOrderCardUi(workOrder: workOrders[index]));
            }),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(child: Text("Não há ordens de serviço"));
  }

  Widget _buildError() {
    return const Center(child: Text("Erro ao carregar ordens de serviço"));
  }

  Widget _buildBlank() {
    return Container();
  }
}
