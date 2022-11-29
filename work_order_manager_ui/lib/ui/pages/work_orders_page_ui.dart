import 'package:work_order_manager_ui/ui/pages/work_order_list_shared_page_ui.dart';

class WorkOrdersPageUi extends WorkOrderListSharedPageUi {
  static const routeName = '/workOrders';
  const WorkOrdersPageUi({super.key})
      : super(pageTitle: "Ordens de serviço", hasAddWorkOrderButton: false);
}
