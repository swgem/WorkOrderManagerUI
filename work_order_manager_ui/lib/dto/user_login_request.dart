import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'user_login_request.g.dart';

@JsonSerializable()
class UserLoginRequest {
  final String userName;
  final String password;

  UserLoginRequest({
    required this.userName,
    required this.password,
  });

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$UserLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}
