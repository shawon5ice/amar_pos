// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_or_loss_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfitOrLossListResponseModel _$ProfitOrLossListResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProfitOrLossListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProfitOrLoss.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfitOrLossListResponseModelToJson(
        ProfitOrLossListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ProfitOrLoss _$ProfitOrLossFromJson(Map<String, dynamic> json) => ProfitOrLoss(
      align: json['align'] as String?,
      isMinus: (json['is_minus'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      debit: json['debit'] == null ? 0 : dynamicNumberFromJson(json['debit']),
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
    );

Map<String, dynamic> _$ProfitOrLossToJson(ProfitOrLoss instance) =>
    <String, dynamic>{
      'align': instance.align,
      'name': instance.name,
      'is_minus': instance.isMinus,
      'debit': dynamicNumberToJson(instance.debit),
      'credit': dynamicNumberToJson(instance.credit),
    };
