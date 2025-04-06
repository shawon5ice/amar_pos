// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_statement_report_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStatementReportResponseModel _$DailyStatementReportResponseModelFromJson(
        Map<String, dynamic> json) =>
    DailyStatementReportResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
    );

Map<String, dynamic> _$DailyStatementReportResponseModelToJson(
        DailyStatementReportResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
    };

DailyStatementData _$DailyStatementDataFromJson(Map<String, dynamic> json) =>
    DailyStatementData(
      data: (json['data'] as List<dynamic>)
          .map((e) => DailyStatementItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyStatementDataToJson(DailyStatementData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

DailyStatementItem _$DailyStatementItemFromJson(Map<String, dynamic> json) =>
    DailyStatementItem(
      date: json['date'] as String,
      order_no: json['order_no'] as String,
      transaction: json['transaction'] as String,
      total: json['total'] as num,
    );

Map<String, dynamic> _$DailyStatementItemToJson(DailyStatementItem instance) =>
    <String, dynamic>{
      'date': instance.date,
      'order_no': instance.order_no,
      'transaction': instance.transaction,
      'total': instance.total,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      last_page: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.last_page,
      'total': instance.total,
    };
