// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_collection_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DueCollectionListResponseModel _$DueCollectionListResponseModelFromJson(
        Map<String, dynamic> json) =>
    DueCollectionListResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
      countTotal: (json['count_total'] as num?)?.toInt() ?? 0,
      amountTotal: json['amount_total'] as num? ?? 0,
    );

Map<String, dynamic> _$DueCollectionListResponseModelToJson(
        DueCollectionListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DueCollectionData.fromJson(e as Map<String, dynamic>))
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

DueCollectionData _$DueCollectionDataFromJson(Map<String, dynamic> json) =>
    DueCollectionData(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      paymentMethod: ChartOfAccountPaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      creator: json['creator'] == null
          ? null
          : Creator.fromJson(json['creator'] as Map<String, dynamic>),
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : Business.fromJson(json['business'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : ClientInfo.fromJson(json['client'] as Map<String, dynamic>),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$DueCollectionDataToJson(DueCollectionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'sl_no': instance.slNo,
      'payment_method': instance.paymentMethod,
      'business': instance.business,
      'store': instance.store,
      'creator': instance.creator,
      'client': instance.client,
      'amount': instance.amount,
      'remarks': instance.remarks,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      businessId: (json['business_id'] as num?)?.toInt(),
      storeId: (json['store_id'] as num?)?.toInt(),
      name: json['name'] as String,
      code: json['code'] as String?,
      remarks: json['remarks'] as String?,
      root: (json['root'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'store_id': instance.storeId,
      'name': instance.name,
      'code': instance.code,
      'remarks': instance.remarks,
      'root': instance.root,
      'type': instance.type,
      'status': instance.status,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Creator _$CreatorFromJson(Map<String, dynamic> json) => Creator(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
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
