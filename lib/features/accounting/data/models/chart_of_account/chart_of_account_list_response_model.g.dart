// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_of_account_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartOfAccountListResponseModel _$ChartOfAccountListResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChartOfAccountListResponseModel(
      success: json['success'] as bool,
      data: ChartOfAccountData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartOfAccountListResponseModelToJson(
        ChartOfAccountListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ChartOfAccountData _$ChartOfAccountDataFromJson(Map<String, dynamic> json) =>
    ChartOfAccountData(
      data: (json['data'] as List<dynamic>)
          .map((e) => ChartOfAccountItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartOfAccountDataToJson(ChartOfAccountData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

ChartOfAccountItem _$ChartOfAccountItemFromJson(Map<String, dynamic> json) =>
    ChartOfAccountItem(
      id: (json['id'] as num).toInt(),
      parentId: null,
      business: _parseBusiness(json['business']),
      store: _parseStore(json['store']),
      code: json['code'] as String?,
      name: json['name'] as String,
      root: chartRootFromJson(json['root']),
      type: json['type'] as String,
      remarks: json['remarks'] as String?,
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$ChartOfAccountItemToJson(ChartOfAccountItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'business': _businessToJson(instance.business),
      'store': _storeToJson(instance.store),
      'code': instance.code,
      'name': instance.name,
      'root': chartRootToJson(instance.root),
      'type': instance.type,
      'remarks': instance.remarks,
      'is_actionable': instance.isActionable,
    };

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      logo: json['logo'] as String,
      address: json['address'] as String,
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'logo': instance.logo,
      'address': instance.address,
      'photo_url': instance.photoUrl,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

ChartOfAccountRoot _$ChartOfAccountRootFromJson(Map<String, dynamic> json) =>
    ChartOfAccountRoot(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ChartOfAccountRootToJson(ChartOfAccountRoot instance) =>
    <String, dynamic>{
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
