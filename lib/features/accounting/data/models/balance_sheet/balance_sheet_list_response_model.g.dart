// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceSheetListResponseModel _$BalanceSheetListResponseModelFromJson(
        Map<String, dynamic> json) =>
    BalanceSheetListResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BalanceSheet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BalanceSheetListResponseModelToJson(
        BalanceSheetListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

BalanceSheet _$BalanceSheetFromJson(Map<String, dynamic> json) => BalanceSheet(
      name: json['name'] as String?,
      debit: json['is_minus'] as num? ?? 0,
      credit:
          json['credit'] == null ? 0 : dynamicNumberFromJson(json['credit']),
    );

Map<String, dynamic> _$BalanceSheetToJson(BalanceSheet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'is_minus': instance.debit,
      'credit': dynamicNumberToJson(instance.credit),
    };
