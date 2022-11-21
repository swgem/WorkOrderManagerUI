import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_manager_ui/api/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';

abstract class WorkOrderApiServices extends ApiServices {
  static Map<String, String> headers = Map.from(ApiServices.headers);
  static const String _workOrderUrl =
      'https://${ApiServices.ip}:${ApiServices.port}/api/WorkOrder/';

  static Future fetchAllWorkOrders() async {
    Response? response;
    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      response = await http
          .get(Uri.parse(_workOrderUrl), headers: headers)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
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

  static Future postWorkOrder(WorkOrder workOrder) async {
    var workOrderMap = workOrder.toJson();
    var workOrderBody = json.encode(workOrderMap);

    Response response;

    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      response = await http
          .post(Uri.parse(_workOrderUrl), headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode != 200) {
      throw Exception("Erro ao salvar ordem de serviço");
    }
  }

  static Future putWorkOrder(WorkOrder workOrder) async {
    var workOrderMap = workOrder.toJson();
    var workOrderBody = json.encode(workOrderMap);

    Response response;

    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      response = await http
          .put(Uri.parse(_workOrderUrl), headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode != 200) {
      throw Exception("Erro ao salvar ordem de serviço");
    }
  }

  static Future<String> _getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return (prefs.getString("tokenjwt") ?? "");
  }
}
