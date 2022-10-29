// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => WorkOrder(
      id: json['id'] as int? ?? 0,
      dayId: json['dayId'] as int,
      status: json['status'] as int? ?? 0,
      priority: json['priority'] as int,
      orderOpeningDatetime: json['orderOpeningDatetime'] as String,
      orderClosingDatetime: json['orderClosingDatetime'] as String?,
      client: json['client'] as String,
      telephone: json['telephone'] as String?,
      vehicle: json['vehicle'] as String,
      vehiclePlate: json['vehiclePlate'] as String?,
      clientRequest: json['clientRequest'] as String,
      pendencies: json['pendencies'] as String?,
      deadline: json['deadline'] as String?,
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$WorkOrderToJson(WorkOrder instance) => <String, dynamic>{
      'id': instance.id,
      'dayId': instance.dayId,
      'status': instance.status,
      'priority': instance.priority,
      'orderOpeningDatetime': instance.orderOpeningDatetime,
      'orderClosingDatetime': instance.orderClosingDatetime,
      'client': instance.client,
      'telephone': instance.telephone,
      'vehicle': instance.vehicle,
      'vehiclePlate': instance.vehiclePlate,
      'clientRequest': instance.clientRequest,
      'pendencies': instance.pendencies,
      'deadline': instance.deadline,
      'remarks': instance.remarks,
    };
