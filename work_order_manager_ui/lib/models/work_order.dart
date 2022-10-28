import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'work_order.g.dart';

@JsonSerializable()
class WorkOrder {
  final int id;
  final String? client;
  final String? serviceSummary;

  WorkOrder({this.id = 0, this.client, this.serviceSummary});
  factory WorkOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFromJson(json);

  Map<String, dynamic> toJson() => _$WorkOrderToJson(this);
}
