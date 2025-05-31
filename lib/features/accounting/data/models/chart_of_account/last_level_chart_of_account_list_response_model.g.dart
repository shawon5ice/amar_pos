// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_level_chart_of_account_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastLevelChartOfAccountListResponseModel
    _$LastLevelChartOfAccountListResponseModelFromJson(
            Map<String, dynamic> json) =>
        LastLevelChartOfAccountListResponseModel(
          success: json['success'] as bool,
          data: (json['data'] as List<dynamic>)
              .map((e) => ChartOfAccount.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$LastLevelChartOfAccountListResponseModelToJson(
        LastLevelChartOfAccountListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ChartOfAccount _$ChartOfAccountFromJson(Map<String, dynamic> json) =>
    ChartOfAccount(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ChartOfAccountToJson(ChartOfAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
