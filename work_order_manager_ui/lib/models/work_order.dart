import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
part 'work_order.g.dart';

@JsonSerializable()
class WorkOrder {
  final int id;
  final int dayId;
  final String status;
  final int priority;
  final String orderOpeningDatetime;
  final String? orderClosingDatetime;
  final String client;
  final String? telephone;
  final String vehicle;
  final String? vehiclePlate;
  final String clientRequest;
  final String? pendencies;
  final String? deadline;
  final String? remarks;

  WorkOrder(
      {this.id = 0,
      this.dayId = 0,
      required this.status,
      required this.priority,
      required this.orderOpeningDatetime,
      this.orderClosingDatetime,
      required this.client,
      this.telephone,
      required this.vehicle,
      this.vehiclePlate,
      required this.clientRequest,
      this.pendencies,
      this.deadline,
      this.remarks});

  factory WorkOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFromJson(json);

  Map<String, dynamic> toJson() => _$WorkOrderToJson(this);
}
