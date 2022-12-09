import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:work_order_manager_ui/api/api_services.dart';
import 'package:work_order_manager_ui/models/work_order.dart';
import 'package:work_order_manager_ui/tools/authentication_manager.dart';

abstract class WorkOrderApiServices extends ApiServices {
  static Map<String, String> headers = Map.from(ApiServices.headers);
  static const String _workOrderUrlBase = ApiServices.hostname;
  static const String _workOrderUrlPath = '/api/WorkOrder/';

  static Future<List<WorkOrder>> fetchAllWorkOrders() async {
    try {
      headers["Authorization"] =
          "Bearer ${await AuthenticationManager.getToken()}";
      Response response = await http
          .get(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));

      _checkAndThrowErrorCode(response.statusCode);
      Iterable list = jsonDecode(response.body);
      return list.map((obj) => WorkOrder.fromJson(obj)).toList();
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<WorkOrder>> fetchWorkOrdersFilteredByStatus(
      List<String> status) async {
    try {
      headers["Authorization"] =
          "Bearer ${await AuthenticationManager.getToken()}";
      Map<String, String> queryParams = {};
      for (int i = 0; i < status.length; i++) {
        queryParams["status[$i]"] = status[i];
      }
      final url = Uri.https(_workOrderUrlBase, _workOrderUrlPath, queryParams);
      Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));

      _checkAndThrowErrorCode(response.statusCode);
      Iterable list = jsonDecode(response.body);
      return list.map((obj) => WorkOrder.fromJson(obj)).toList();
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }
  }

  static Future postWorkOrder(WorkOrder workOrder) async {
    try {
      var workOrderMap = workOrder.toJson();
      var workOrderBody = json.encode(workOrderMap);

      headers["Authorization"] =
          "Bearer ${await AuthenticationManager.getToken()}";
      Response response = await http
          .post(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));

      _checkAndThrowErrorCode(response.statusCode);
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }
  }

  static Future putWorkOrder(WorkOrder workOrder) async {
    try {
      var workOrderMap = workOrder.toJson();
      var workOrderBody = json.encode(workOrderMap);

      headers["Authorization"] =
          "Bearer ${await AuthenticationManager.getToken()}";
      Response response = await http
          .put(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));

      _checkAndThrowErrorCode(response.statusCode);
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }
  }

  static void _checkAndThrowErrorCode(int statusCode) {
    if (statusCode == 401) {
      throw Exception("401: Falha de autenticação");
    } else if (statusCode == 403) {
      throw Exception("403: Usuário não autorizado");
    } else if (statusCode != 200 && statusCode != 204) {
      throw Exception("Erro ao requisitar dados do servidor");
    }
  }
}
