import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'user_register_request.g.dart';

@JsonSerializable()
class UserRegisterRequest {
  final String userName;
  final String password;
  final String passwordConfirmation;

  UserRegisterRequest({
    required this.userName,
    required this.password,
    required this.passwordConfirmation,
  });

  factory UserRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegisterRequestToJson(this);
}
