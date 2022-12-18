import 'package:work_order_manager_ui/ui/pages/base_work_order_list_page_ui.dart';

class WorkOrdersPageUi extends BaseWorkOrderListPageUi {
  static const routeName = '/workOrders';
  const WorkOrdersPageUi({super.key})
      : super(pageTitle: "Ordens de serviço", hasAddWorkOrderButton: false);
}
