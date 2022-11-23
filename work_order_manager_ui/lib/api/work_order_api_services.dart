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
  static const String _workOrderUrlBase =
      '${ApiServices.ip}:${ApiServices.port}';
  static const String _workOrderUrlPath = '/api/WorkOrder/';

  static Future fetchAllWorkOrders() async {
    Response? response;
    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      response = await http
          .get(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200 || response.statusCode == 204) {
      Iterable list = jsonDecode(response.body);
      return list.map((obj) => WorkOrder.fromJson(obj)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("401: Falha de autenticação");
    } else {
      throw Exception("Erro ao requisitar dados do servidor");
    }
  }

  static Future<List<WorkOrder>> fetchWorkOrdersFilteredByStatus(
      List<String> status) async {
    Response? response;
    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      Map<String, String> queryParams = {};
      for (int i = 0; i < status.length; i++) {
        queryParams["status[$i]"] = status[i];
      }
      final url = Uri.https(_workOrderUrlBase, _workOrderUrlPath, queryParams);
      response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200 || response.statusCode == 204) {
      Iterable list = jsonDecode(response.body);
      return list.map((obj) => WorkOrder.fromJson(obj)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("401: Falha de autenticação");
    } else {
      throw Exception("Erro ao requisitar dados do servidor");
    }
  }

  static Future postWorkOrder(WorkOrder workOrder) async {
    var workOrderMap = workOrder.toJson();
    var workOrderBody = json.encode(workOrderMap);

    Response response;

    try {
      headers["Authorization"] = "Bearer ${await _getToken()}";
      response = await http
          .post(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 401) {
      throw Exception("401: Falha de autenticação");
    } else if (response.statusCode != 200 && response.statusCode != 201) {
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
          .put(Uri.https(_workOrderUrlBase, _workOrderUrlPath),
              headers: headers, body: workOrderBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 401) {
      throw Exception("401: Falha de autenticação");
    } else if (response.statusCode != 200) {
      throw Exception("Erro ao salvar ordem de serviço");
    }
  }

  static Future<String> _getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return (prefs.getString("tokenjwt") ?? "");
  }
}
