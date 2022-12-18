import 'package:work_order_manager_ui/shared/work_order_status.dart';
import 'package:work_order_manager_ui/ui/pages/base_work_order_list_page_ui.dart';

class HomePageUi extends BaseWorkOrderListPageUi {
  static const String routeName = '/homePage';
  HomePageUi({super.key})
      : super(
            pageTitle: "Início",
            statusFilter: [WorkOrderStatus.waiting, WorkOrderStatus.ongoing],
            hasAddWorkOrderButton: true);
}
