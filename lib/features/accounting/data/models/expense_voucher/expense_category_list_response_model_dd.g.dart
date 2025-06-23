// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category_list_response_model_dd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategoryListResponseModelDD _$ExpenseCategoryListResponseModelDDFromJson(
        Map<String, dynamic> json) =>
    ExpenseCategoryListResponseModelDD(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpenseCategoryListResponseModelDDToJson(
        ExpenseCategoryListResponseModelDD instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      root: (json['root'] as num).toInt(),
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
    };
