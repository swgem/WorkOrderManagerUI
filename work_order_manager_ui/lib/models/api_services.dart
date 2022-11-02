import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

class ApiServices {
  static const String ip = 'localhost' /*'10.0.2.2'*/;
  static const String port = '5189';
  static const String workOrderUrl = 'http://${ip}:${port}/api/WorkOrder/';
  static const int requestTimeoutSeconds = 60;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    //'Accept': '*/*'
  };

  static Future fetchAllWorkOrders() async {
    Response? response;
    try {
      response = await http
          .get(Uri.parse(workOrderUrl))
          .timeout(const Duration(seconds: requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    Iterable list = jsonDecode(response.body);
    return list.map((obj) => WorkOrder.fromJson(obj)).toList();
  }

  static Future<bool> postWorkOrder(WorkOrder workOrder) async {
    var workOrderMap = workOrder.toJson();
    var workOrderBody = json.encode(workOrderMap);

    Response response;

    try {
      response = await http
          .post(Uri.parse(workOrderUrl), headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    return Future.value(response.statusCode == 200 ? true : false);
  }
}
