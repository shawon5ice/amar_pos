// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseHistoryResponseModel _$PurchaseHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseHistoryResponseModel(
      success: json['success'] as bool,
      data: PurchaseHistoryData.fromJson(json['data'] as Map<String, dynamic>),
      countTotal: json['count_total'] as num,
      amountTotal: json['amount_total'] as num,
    );

Map<String, dynamic> _$PurchaseHistoryResponseModelToJson(
        PurchaseHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'count_total': instance.countTotal,
      'amount_total': instance.amountTotal,
    };

PurchaseHistoryData _$PurchaseHistoryDataFromJson(Map<String, dynamic> json) =>
    PurchaseHistoryData(
          purchaseHistoryList: (json['data'] as List<dynamic>)
          .map((e) => PurchaseOrderInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: Links.fromJson(json['links'] as Map<String, dynamic>),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseHistoryDataToJson(
        PurchaseHistoryData instance) =>
    <String, dynamic>{
      'data': instance.purchaseHistoryList,
      'links': instance.links,
      'meta': instance.meta,
    };

PurchaseOrderInfo _$PurchaseOrderInfoFromJson(Map<String, dynamic> json) =>
    PurchaseOrderInfo(
      id: (json['id'] as num).toInt(),
      dateTime: json['date_time'] as String,
      supplier: json['supplier'] as String,
      phone: json['phone'] as String,
      orderNo: json['order_no'] as String,
      discount: json['discount'] as num,
      amount: json['amount'] as num,
      isActionable: json['is_actionable'] as bool,
    );

Map<String, dynamic> _$PurchaseOrderInfoToJson(PurchaseOrderInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_time': instance.dateTime,
      'order_no': instance.orderNo,
      'phone': instance.phone,
      'supplier': instance.supplier,
      'discount': instance.discount,
      'amount': instance.amount,
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
