import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_bloc.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_event.dart';
import 'package:work_order_manager_ui/bloc/work_order_list_state.dart';
import 'package:work_order_manager_ui/ui/components/drawer_ui.dart';
import 'package:work_order_manager_ui/ui/components/work_order_list_ui.dart';

class WorkOrdersPageUi extends StatefulWidget {
  static const routeName = '/workOrders';
  const WorkOrdersPageUi({super.key});

  @override
  State<WorkOrdersPageUi> createState() => _WorkOrdersPageUiState();
}

class _WorkOrdersPageUiState extends State<WorkOrdersPageUi> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorkOrderListBloc>(context)
        .add(WorkOrderListFetchByStatusEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(), drawer: const DrawerUi(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Text('Ordens de serviço'),
      const Spacer(),
      IconButton(
          onPressed: () => BlocProvider.of<WorkOrderListBloc>(context)
              .add(WorkOrderListFetchByStatusEvent()),
          icon: const Icon(Icons.refresh))
    ]));
  }

  Widget _buildBody() {
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
}
