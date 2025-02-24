// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_balance_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrialBalanceListResponseModel _$TrialBalanceListResponseModelFromJson(
        Map<String, dynamic> json) =>
    TrialBalanceListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataWrapper.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrialBalanceListResponseModelToJson(
        TrialBalanceListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      trialBalanceList: (json['data'] as List<dynamic>?)
          ?.map((e) => TrialBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      debit: json['debit'] == null ? 0 : dynamicNumberFromJson(json['debit']),
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.trialBalanceList,
      'debit': dynamicNumberToJson(instance.debit),
      'credit': dynamicNumberToJson(instance.credit),
    };

TrialBalance _$TrialBalanceFromJson(Map<String, dynamic> json) => TrialBalance(
      code: json['code'] as String?,
      name: json['name'] as String?,
      debit: json['debit'] == null ? 0 : dynamicNumberFromJson(json['debit']),
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
    );

Map<String, dynamic> _$TrialBalanceToJson(TrialBalance instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'debit': dynamicNumberToJson(instance.debit),
      'credit': dynamicNumberToJson(instance.credit),
    };
