import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_manager_ui/api/api_services.dart';
import 'package:work_order_manager_ui/dto/user_login_request.dart';
import 'package:work_order_manager_ui/dto/user_login_response.dart';

abstract class AuthenticationApiServices extends ApiServices {
  static const String _authenticationBaseUrl =
      'https://${ApiServices.ip}:${ApiServices.port}/api/User/';
  static const String _authenticationLoginUrl =
      '${_authenticationBaseUrl}login';

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
      var loginResponse = UserLoginResponse.fromJson(jsonDecode(response.body));
      throw Exception(
          loginResponse.errors?.join('. ') ?? "Erro ao realizar login");
    }
    return success;
  }
}
