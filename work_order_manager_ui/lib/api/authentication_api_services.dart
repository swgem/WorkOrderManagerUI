import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_manager_ui/api/api_services.dart';
import 'package:work_order_manager_ui/dto/user_login_request.dart';
import 'package:work_order_manager_ui/dto/user_login_response.dart';
import 'package:work_order_manager_ui/dto/user_register_response.dart';

import '../dto/user_register_request.dart';

abstract class AuthenticationApiServices extends ApiServices {
  static const String _authenticationBaseUrl =
      'https://${ApiServices.ip}/api/User/';
  // static const String _authenticationBaseUrl =
  //     'https://${ApiServices.ip}:${ApiServices.port}/api/User/';
  static const String _authenticationLoginUrl =
      '${_authenticationBaseUrl}login';
  static const String _authenticationRegisterUrl =
      '${_authenticationBaseUrl}register';

  static Future<bool> login(String userName, String password) async {
    var request = UserLoginRequest(userName: userName, password: password);

    var requestMap = request.toJson();
    var requestBody = json.encode(requestMap);

    Response response;

    try {
      response = await http
          .post(Uri.parse(_authenticationLoginUrl),
              headers: ApiServices.headers, body: requestBody)
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
      var prefs = await SharedPreferences.getInstance();
      if (loginResponse.success && loginResponse.token != null) {
        prefs.setString("tokenjwt", loginResponse.token!);
        success = true;
      } else {
        throw Exception(
            loginResponse.errors?.join('. ') ?? "Erro ao realizar login");
      }
    } else {
      UserLoginResponse? loginResponse;
      try {
        loginResponse = UserLoginResponse.fromJson(jsonDecode(response.body));
        // ignore: empty_catches
      } catch (e) {}

      throw Exception(
          loginResponse?.errors?.join('. ') ?? "Erro ao realizar login");
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
          .post(Uri.parse(_authenticationRegisterUrl),
              headers: ApiServices.headers, body: requestBody)
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
            registerResponse.errors?.join('. ') ?? "Erro ao registrar usuário");
      }
    } else {
      UserRegisterResponse? registerResponse;
      try {
        registerResponse =
            UserRegisterResponse.fromJson(jsonDecode(response.body));
        // ignore: empty_catches
      } catch (e) {}

      throw Exception(
          registerResponse?.errors?.join('. ') ?? "Erro ao registrar usuário");
    }
    return success;
  }
}
