// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

SaleHistory _$SaleHistoryFromJson(Map<String, dynamic> json) => SaleHistory(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      orderNo: json['order_no'] as String,
      saleType: json['sale_type'] as String,
      quantity: json['quantity'] as int,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      discount: (json['discount'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$SaleHistoryToJson(SaleHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'order_no': instance.orderNo,
      'sale_type': instance.saleType,
      'customer': instance.customer,
      'discount': instance.discount,
      'amount': instance.amount,
      'paid_amount': instance.paidAmount,
      'vat': instance.vat,
      'is_actionable': instance.isActionable,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      currentPage: (json['current_page'] as num).toInt(),
      from: (json['from'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'total': instance.total,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      saleHistoryList: (json['data'] as List<dynamic>)
          .map((e) => SaleHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.saleHistoryList,
      'meta': instance.meta,
    };

SaleHistoryResponseModel _$SaleHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    SaleHistoryResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
      countTotal: (json['count_total'] as num).toInt(),
      amountTotal: (json['amount_total'] as num).toDouble(),
    );

Map<String, dynamic> _$SaleHistoryResponseModelToJson(
        SaleHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };
