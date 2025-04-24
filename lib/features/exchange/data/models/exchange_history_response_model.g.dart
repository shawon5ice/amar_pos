// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeHistoryResponseModel _$ExchangeHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeHistoryResponseModel(
      success: json['success'] as bool,
      data: ExchangeHistoryData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExchangeHistoryResponseModelToJson(
        ExchangeHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ExchangeHistoryData _$ExchangeHistoryDataFromJson(Map<String, dynamic> json) =>
    ExchangeHistoryData(
      exchangeHistoryList: (json['data'] as List<dynamic>)
          .map((e) => ExchangeOrderInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: Links.fromJson(json['links'] as Map<String, dynamic>),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExchangeHistoryDataToJson(
        ExchangeHistoryData instance) =>
    <String, dynamic>{
      'data': instance.exchangeHistoryList,
      'links': instance.links,
      'meta': instance.meta,
    };

ExchangeOrderInfo _$ExchangeOrderInfoFromJson(Map<String, dynamic> json) =>
    ExchangeOrderInfo(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      orderNo: json['order_no'] as String,
      saleType: json['sale_type'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      discount: (json['discount'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      paidAmount: (json['paid_amount'] as num).toInt(),
      vat: (json['vat'] as num).toInt(),
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$ExchangeOrderInfoToJson(ExchangeOrderInfo instance) =>
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

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      first: json['first'] as String,
      last: json['last'] as String,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      currentPage: (json['current_page'] as num).toInt(),
      from: (json['from'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      links: (json['links'] as List<dynamic>)
          .map((e) => PageLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'links': instance.links,
      'path': instance.path,
      'per_page': instance.perPage,
      'to': instance.to,
      'total': instance.total,
    };

PageLink _$PageLinkFromJson(Map<String, dynamic> json) => PageLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$PageLinkToJson(PageLink instance) => <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
