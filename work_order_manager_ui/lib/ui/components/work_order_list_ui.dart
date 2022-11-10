import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/ui/components/work_order_card_ui.dart';

class WorkOrderListUi extends StatefulWidget {
  const WorkOrderListUi({super.key});

  @override
  State<WorkOrderListUi> createState() => _WorkOrderListUiState();
}

class _WorkOrderListUiState extends State<WorkOrderListUi> {
  @override
  Widget build(BuildContext context) {
    return _buildWorkOrderList(context);
  }

  Widget _buildWorkOrderList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future(() => BlocProvider.of<WorkOrderListBloc>(context)
          .add(WorkOrderListFetchEvent())),
      child: BlocBuilder<WorkOrderListBloc, WorkOrderListState>(
          bloc: BlocProvider.of(context),
          builder: (context, state) {
            if (state is WorkOrderListSucessState) {
              return ListView.builder(
                  padding: const EdgeInsets.only(top: 7.0, bottom: 150.0),
                  itemCount: state.workOrders.length,
                  itemBuilder: (content, index) {
                    return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
                        child: WorkOrderCardUi(
                            workOrder: state.workOrders[index]));
                  });
            } else if (state is WorkOrderListEmptyState) {
              return const Center(child: Text("Não há ordens de serviço"));
            } else if (state is WorkOrderListErrorState) {
              return const Center(
                  child: Text("Erro ao carregar ordens de serviço"));
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
