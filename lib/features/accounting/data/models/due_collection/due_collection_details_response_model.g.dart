// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_collection_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DueCollectionDetailsResponseModel _$DueCollectionDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    DueCollectionDetailsResponseModel(
      success: json['success'] as bool,
      data: DueCollectionDetailsData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DueCollectionDetailsResponseModelToJson(
        DueCollectionDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

DueCollectionDetailsData _$DueCollectionDetailsDataFromJson(
        Map<String, dynamic> json) =>
    DueCollectionDetailsData(
      id: (json['id'] as num).toInt(),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      slNo: json['sl_no'] as String,
      date: json['date'] as String,
      remarks: json['remarks'] as String,
      creator: Creator.fromJson(json['creator'] as Map<String, dynamic>),
      previousDue: (json['previous_due'] as num).toDouble(),
      details: (json['details'] as List<dynamic>)
          .map((e) => Detail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DueCollectionDetailsDataToJson(
        DueCollectionDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business': instance.business,
      'store': instance.store,
      'client': instance.client,
      'sl_no': instance.slNo,
      'date': instance.date,
      'remarks': instance.remarks,
      'creator': instance.creator,
      'previous_due': instance.previousDue,
      'details': instance.details,
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

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: (json['id'] as num).toInt(),
      clientNo: json['client_no'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      openingBalance: (json['opening_balance'] as num).toDouble(),
      previousDue: (json['previous_due'] as num).toDouble(),
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'client_no': instance.clientNo,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'opening_balance': instance.openingBalance,
      'previous_due': instance.previousDue,
      'status': instance.status,
    };

Creator _$CreatorFromJson(Map<String, dynamic> json) => Creator(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: PaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      root: (json['root'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
    };
