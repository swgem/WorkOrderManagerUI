// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => WorkOrder(
      id: json['id'] as int? ?? 0,
      client: json['client'] as String?,
      serviceSummary: json['serviceSummary'] as String?,
    );

Map<String, dynamic> _$WorkOrderToJson(WorkOrder instance) => <String, dynamic>{
      'id': instance.id,
      'client': instance.client,
      'serviceSummary': instance.serviceSummary,
    };
