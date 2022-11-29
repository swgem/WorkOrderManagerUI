import 'package:work_order_manager_ui/ui/pages/work_order_list_shared_page_ui.dart';

class HomePageUi extends WorkOrderListSharedPageUi {
  static const String routeName = '/homePage';
  HomePageUi({super.key})
      : super(
            pageTitle: "Início",
            statusFilter: ["waiting", "ongoing"],
            hasAddWorkOrderButton: true);
}
