// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transfer_history_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTransferHistoryDetailsResponseModel
    _$StockTransferHistoryDetailsResponseModelFromJson(
            Map<String, dynamic> json) =>
        StockTransferHistoryDetailsResponseModel(
          success: json['success'] as bool,
          data: StockTransferHistoryDetailsData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$StockTransferHistoryDetailsResponseModelToJson(
        StockTransferHistoryDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

StockTransferHistoryDetailsData _$StockTransferHistoryDetailsDataFromJson(
        Map<String, dynamic> json) =>
    StockTransferHistoryDetailsData(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      orderNo: json['order_no'] as String,
      type: (json['type'] as num).toInt(),
      remarks: json['remarks'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      details: (json['order_details'] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      fromStore: Store.fromJson(json['from_store'] as Map<String, dynamic>),
      toStore: Store.fromJson(json['to_store'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockTransferHistoryDetailsDataToJson(
        StockTransferHistoryDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'order_no': instance.orderNo,
      'quantity': instance.quantity,
      'type': instance.type,
      'remarks': instance.remarks,
      'business': instance.business,
      'from_store': instance.fromStore,
      'to_store': instance.toStore,
      'order_details': instance.details,
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

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      id: (json['id'] as num).toInt(),
      detailsId: (json['details_id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      costingPrice: (json['costing_price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      snNo: (json['sn_no'] as List<dynamic>?)
          ?.map((e) => SnNo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'details_id': instance.detailsId,
      'name': instance.name,
      'quantity': instance.quantity,
      'costing_price': instance.costingPrice,
      'total': instance.total,
      'sn_no': instance.snNo,
    };
