import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'user_register_response.g.dart';

@JsonSerializable()
class UserRegisterResponse {
  final bool success;
  final List<String>? errors;

  UserRegisterResponse({required this.success, required this.errors});

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegisterResponseToJson(this);
}
