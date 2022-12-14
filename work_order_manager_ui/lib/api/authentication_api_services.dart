import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:work_order_manager_ui/api/api_services.dart';
import 'package:work_order_manager_ui/dto/user_login_request.dart';
import 'package:work_order_manager_ui/dto/user_login_response.dart';
import 'package:work_order_manager_ui/dto/user_register_response.dart';
import 'package:work_order_manager_ui/shared/authentication_manager.dart';

import '../dto/user_register_request.dart';

abstract class AuthenticationApiServices extends ApiServices {
  static Map<String, String> headers = Map.from(ApiServices.headers);
  static const String _authenticationBaseUrl = ApiServices.hostname;
  static const String _authenticationUrlPath = '/api/User/';
  static const String _authenticationLoginUrlPath =
      '${_authenticationUrlPath}login';
  static const String _authenticationRegisterUrlPath =
      '${_authenticationUrlPath}register';

  static Future<bool> login(String userName, String password) async {
    var request = UserLoginRequest(userName: userName, password: password);

    var requestMap = request.toJson();
    var requestBody = json.encode(requestMap);

    Response response;

    try {
      response = await http
          .post(Uri.https(_authenticationBaseUrl, _authenticationLoginUrlPath),
              headers: headers, body: requestBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    bool success = false;
    if (response.statusCode == 200) {
      var loginResponse = UserLoginResponse.fromJson(jsonDecode(response.body));
      if (loginResponse.success && loginResponse.token != null) {
        AuthenticationManager.setAuth(
            loginResponse.token, loginResponse.expirationDate);
        success = true;
      } else {
        throw Exception(
            loginResponse.errors?.toString() ?? "Erro ao realizar login");
      }
    } else {
      String? errors;
      try {
        errors = jsonDecode(response.body)['errors'].toString();
        // ignore: empty_catches
      } catch (e) {}

      throw Exception(errors ?? "Erro ao registrar usuário");
    }
    return success;
  }

  static Future<bool> register(
      String userName, String password, String passwordConfirmation) async {
    var request = UserRegisterRequest(
        userName: userName,
        password: password,
        passwordConfirmation: passwordConfirmation);

    var requestMap = request.toJson();
    var requestBody = json.encode(requestMap);

    Response response;

    try {
      response = await http
          .post(
              Uri.https(_authenticationBaseUrl, _authenticationRegisterUrlPath),
              headers: headers,
              body: requestBody)
          .timeout(const Duration(seconds: ApiServices.requestTimeoutSeconds));
    } on SocketException {
      throw Exception("Problema com a conexão");
    } on TimeoutException {
      throw Exception("Requisição ao servidor resultou em timeout");
    } on Error catch (e) {
      throw Exception(e);
    }

    bool success = false;
    if (response.statusCode == 200) {
      var registerResponse =
          UserRegisterResponse.fromJson(jsonDecode(response.body));
      if (registerResponse.success) {
        success = true;
      } else {
        throw Exception(
            registerResponse.errors?.toString() ?? "Erro ao registrar usuário");
      }
    } else {
      String? errors;
      try {
        errors = jsonDecode(response.body)['errors'].toString();
        // ignore: empty_catches
      } catch (e) {}

      throw Exception(errors ?? "Erro ao registrar usuário");
    }
    return success;
  }
}
