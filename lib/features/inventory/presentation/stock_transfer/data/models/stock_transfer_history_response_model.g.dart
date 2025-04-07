// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transfer_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTransferResponse _$StockTransferResponseFromJson(
        Map<String, dynamic> json) =>
    StockTransferResponse(
      success: json['success'] as bool,
      data: StockTransferData.fromJson(json['data'] as Map<String, dynamic>),
      countTotal: (json['count_total'] as num).toInt(),
      quantityTotal: (json['quantity_total'] as num).toInt(),
      amountTotal: json['amount_total'] as num,
    );

Map<String, dynamic> _$StockTransferResponseToJson(
        StockTransferResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'count_total': instance.countTotal,
      'quantity_total': instance.quantityTotal,
      'amount_total': instance.amountTotal,
    };

StockTransferData _$StockTransferDataFromJson(Map<String, dynamic> json) =>
    StockTransferData(
      data: (json['data'] as List<dynamic>)
          .map((e) => StockTransfer.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockTransferDataToJson(StockTransferData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

StockTransfer _$StockTransferFromJson(Map<String, dynamic> json) =>
    StockTransfer(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      receivedDate: json['received_date'] as String?,
      orderNo: json['order_no'] as String,
      fromStore: Store.fromJson(json['from_store'] as Map<String, dynamic>),
      toStore: Store.fromJson(json['to_store'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      total: json['total'] as num,
      type: (json['type'] as num).toInt(),
      remarks: json['remarks'] as String?,
      status: json['status'] as String,
      isEditable: json['is_editable'] as bool,
      isReceivable: json['is_receivable'] as bool,
    );

Map<String, dynamic> _$StockTransferToJson(StockTransfer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'received_date': instance.receivedDate,
      'order_no': instance.orderNo,
      'from_store': instance.fromStore,
      'to_store': instance.toStore,
      'quantity': instance.quantity,
      'total': instance.total,
      'type': instance.type,
      'remarks': instance.remarks,
      'status': instance.status,
      'is_editable': instance.isEditable,
      'is_receivable': instance.isReceivable,
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

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };
