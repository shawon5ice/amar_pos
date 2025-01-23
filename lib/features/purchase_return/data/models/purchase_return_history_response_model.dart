import 'package:json_annotation/json_annotation.dart';

part 'purchase_return_history_response_model.g.dart';


@JsonSerializable()
class PurchaseReturnHistoryResponseModel {
  final bool success;
  final PurchaseReturnHistoryData data;
  @JsonKey(name: 'count_total')
  final num countTotal;
  @JsonKey(name: 'amount_total')
  final num amountTotal;

  PurchaseReturnHistoryResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal
  });

  factory PurchaseReturnHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseReturnHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseReturnHistoryResponseModelToJson(this);
}

@JsonSerializable()
class PurchaseReturnHistoryData {
  @JsonKey(name: 'data')
  final List<PurchaseReturnOrderInfo> purchaseReturnHistoryList;
  final Links links;
  final Meta meta;

  PurchaseReturnHistoryData({
    required this.purchaseReturnHistoryList,
    required this.links,
    required this.meta,
  });

  factory PurchaseReturnHistoryData.fromJson(Map<String, dynamic> json) =>
      _$PurchaseReturnHistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseReturnHistoryDataToJson(this);
}

@JsonSerializable()
class PurchaseReturnOrderInfo {
  final int id;
  @JsonKey(name: 'date_time')
  final String dateTime;
  @JsonKey(name: 'order_no')
  final String orderNo;
  final String phone;
  final String supplier;

  final num discount;
  final num amount;
  @JsonKey(name: 'is_actionable')
  final bool isActionable;

  PurchaseReturnOrderInfo({
    required this.id,
    required this.dateTime,
    required this.supplier,
    required this.phone,
    required this.orderNo,
    required this.discount,
    required this.amount,
    required this.isActionable,
  });


  factory PurchaseReturnOrderInfo.fromJson(Map<String, dynamic> json) =>
      _$PurchaseReturnOrderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseReturnOrderInfoToJson(this);
}

@JsonSerializable()
class Customer {
  final int id;
  final String name;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class Links {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final int from;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final List<PageLink> links;
  final String path;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) =>
      _$PageLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PageLinkToJson(this);
}


// {
// "success": true,
// "data": {
// "data": [
// {
// "id": 103,
// "date_time": "22 Jan 2025, 08:21 AM",
// "order_no": "GP-PO-90053",
// "supplier": "Priyo Supplier",
// "phone": "01332505465",
// "discount": 50,
// "amount": 600,
// "is_actionable": true
// }
// ],
// "links": {
// "first": "https://amarpos.motionview.com.bd/api/purchase/get-all-purchase-list?page=1",
// "last": "https://amarpos.motionview.com.bd/api/purchase/get-all-purchase-list?page=1",
// "prev": null,
// "next": null
// },
// "meta": {
// "current_page": 1,
// "from": 1,
// "last_page": 1,
// "links": [
// {
// "url": null,
// "label": "&laquo; Previous",
// "active": false
// },
// {
// "url": "https://amarpos.motionview.com.bd/api/purchase/get-all-purchase-list?page=1",
// "label": "1",
// "active": true
// },
// {
// "url": null,
// "label": "Next &raquo;",
// "active": false
// }
// ],
// "path": "https://amarpos.motionview.com.bd/api/purchase/get-all-purchase-list",
// "per_page": 20,
// "to": 4,
// "total": 4
// }
// },
// "count_total": 4,
// "amount_total": 2885
// }