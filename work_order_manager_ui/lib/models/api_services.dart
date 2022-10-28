import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:work_order_manager_ui/models/work_order.dart';

class ApiServices {
  static const String ip = 'localhost' /*'10.0.2.2'*/;
  static const String port = '5189';
  static const String workOrderUrl = 'http://${ip}:${port}/api/WorkOrder/';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    //'Accept': '*/*'
  };

  static Future fetchAllWorkOrders() async {
    var response = await http.get(Uri.parse(workOrderUrl));
    Iterable list = jsonDecode(response.body);

    return list.map((obj) => WorkOrder.fromJson(obj)).toList();
  }

  static Future<bool> postWorkOrder(WorkOrder workOrder) async {
    var workOrderMap = workOrder.toJson();
    var workOrderBody = json.encode(workOrderMap);
    var response = await http.post(Uri.parse(workOrderUrl),
        headers: headers, body: workOrderBody);
    return Future.value(response.statusCode == 200 ? true : false);
  }
}
