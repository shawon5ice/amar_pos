// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

ReturnHistory _$ReturnHistoryFromJson(Map<String, dynamic> json) =>
    ReturnHistory(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      orderNo: json['order_no'] as String,
      saleType: json['sale_type'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      discount: (json['discount'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$ReturnHistoryToJson(ReturnHistory instance) =>
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
      returnHistoryList: (json['data'] as List<dynamic>)
          .map((e) => ReturnHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.returnHistoryList,
      'meta': instance.meta,
    };

ReturnHistoryResponseModel _$ReturnHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    ReturnHistoryResponseModel(
      success: json['success'] as bool,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      countTotal: (json['count_total'] as num).toInt(),
      amountTotal: (json['amount_total'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnHistoryResponseModelToJson(
        ReturnHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };
