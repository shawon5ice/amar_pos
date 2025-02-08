// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_categories_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategoriesResponseModel _$ExpenseCategoriesResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExpenseCategoriesResponseModel(
      success: json['success'] as bool,
      data: DataWrapper.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExpenseCategoriesResponseModelToJson(
        ExpenseCategoriesResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExpenseCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) =>
    ExpenseCategory(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      name: json['name'] as String,
      root: Root.fromJson(json['root'] as Map<String, dynamic>),
      type: json['type'] as String,
      remarks: json['remarks'] as String?,
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$ExpenseCategoryToJson(ExpenseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'root': instance.root,
      'type': instance.type,
      'remarks': instance.remarks,
      'is_actionable': instance.isActionable,
    };

Root _$RootFromJson(Map<String, dynamic> json) => Root(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RootToJson(Root instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };
