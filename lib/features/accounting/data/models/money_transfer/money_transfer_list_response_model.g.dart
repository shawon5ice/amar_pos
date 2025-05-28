// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transfer_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyTransferListResponseModel _$MoneyTransferListResponseModelFromJson(
        Map<String, dynamic> json) =>
    MoneyTransferListResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
    );

Map<String, dynamic> _$MoneyTransferListResponseModelToJson(
        MoneyTransferListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MoneyTransferData.fromJson(e as Map<String, dynamic>))
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

MoneyTransferData _$MoneyTransferDataFromJson(Map<String, dynamic> json) =>
    MoneyTransferData(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      amount: (json['amount'] as num).toDouble(),
      creator: json['creator'] == null
          ? null
          : Creator.fromJson(json['creator'] as Map<String, dynamic>),
      fromStore: json['from_store'] == null
          ? null
          : Store.fromJson(json['from_store'] as Map<String, dynamic>),
      toAccount: json['to_account'] == null
          ? null
          : Account.fromJson(json['to_account'] as Map<String, dynamic>),
      toStore: json['to_store'] == null
          ? null
          : Store.fromJson(json['to_store'] as Map<String, dynamic>),
      fromAccount: json['from_account'] == null
          ? null
          : Account.fromJson(json['from_account'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : Business.fromJson(json['business'] as Map<String, dynamic>),
      remarks: json['remarks'] as String?,
      status: json['status'] as String?,
      isApprovable: json['isApprovable'] as bool,
      isCreator: json['isCreator'] as bool,
    );

Map<String, dynamic> _$MoneyTransferDataToJson(MoneyTransferData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'sl_no': instance.slNo,
      'business': instance.business,
      'from_store': instance.fromStore,
      'to_store': instance.toStore,
      'to_account': instance.toAccount,
      'from_account': instance.fromAccount,
      'creator': instance.creator,
      'amount': instance.amount,
      'remarks': instance.remarks,
      'status': instance.status,
      'isCreator': instance.isCreator,
      'isApprovable': instance.isApprovable,
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

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
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
