import 'package:work_order_manager_ui/shared/work_order_status.dart';
import 'package:work_order_manager_ui/ui/pages/work_order_list_shared_page_ui.dart';

class HomePageUi extends WorkOrderListSharedPageUi {
  static const String routeName = '/homePage';
  HomePageUi({super.key})
      : super(
            pageTitle: "Início",
            statusFilter: [WorkOrderStatus.waiting, WorkOrderStatus.ongoing],
            hasAddWorkOrderButton: true);
}
