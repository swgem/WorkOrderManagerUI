import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'user_login_response.g.dart';

@JsonSerializable()
class UserLoginResponse {
  final bool success;
  final String? token;
  final String? expirationDate;
  final List<String>? errors;

  UserLoginResponse(
      {required this.success,
      required this.token,
      required this.expirationDate,
      required this.errors});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$UserLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginResponseToJson(this);
}
