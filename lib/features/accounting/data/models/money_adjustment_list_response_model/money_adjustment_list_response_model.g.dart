// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_adjustment_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyAdjustmentListResponseModel _$MoneyAdjustmentListResponseModelFromJson(
        Map<String, dynamic> json) =>
    MoneyAdjustmentListResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
    );

Map<String, dynamic> _$MoneyAdjustmentListResponseModelToJson(
        MoneyAdjustmentListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MoneyAdjustmentData.fromJson(e as Map<String, dynamic>))
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

MoneyAdjustmentData _$MoneyAdjustmentDataFromJson(Map<String, dynamic> json) =>
    MoneyAdjustmentData(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      amount: (json['amount'] as num).toDouble(),
      creator: json['creator'] == null
          ? null
          : Creator.fromJson(json['creator'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : Business.fromJson(json['business'] as Map<String, dynamic>),
      remarks: json['remarks'] as String?,
      paymentMethod: ChartOfAccountPaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoneyAdjustmentDataToJson(
        MoneyAdjustmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'sl_no': instance.slNo,
      'business': instance.business,
      'store': instance.store,
      'creator': instance.creator,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'remarks': instance.remarks,
    };

Creator _$CreatorFromJson(Map<String, dynamic> json) => Creator(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      logo: json['logo'] as String?,
      photoUrl: json['photo_url'] as String?,
      timeZone: json['time_zone'] as String?,
      currencyId: (json['currency_id'] as num?)?.toInt(),
      ownerId: (json['owner_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'logo': instance.logo,
      'address': instance.address,
      'photo_url': instance.photoUrl,
      'currency_id': instance.currencyId,
      'owner_id': instance.ownerId,
      'time_zone': instance.timeZone,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };
