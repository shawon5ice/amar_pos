import 'package:json_annotation/json_annotation.dart';

part 'exchange_history_response_model.g.dart';

@JsonSerializable()
class ExchangeHistoryResponseModel {
  final bool success;
  final ExchangeHistoryData data;
  @JsonKey(name: "count_total")
  final num countTotal;
  @JsonKey(name: "amount_total")
  final num amountTotal;

  ExchangeHistoryResponseModel({
    required this.success,
    required this.data,
    required this.amountTotal,
    required this.countTotal
  });

  factory ExchangeHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeHistoryResponseModelToJson(this);
}

@JsonSerializable()
class ExchangeHistoryData {
  @JsonKey(name: 'data')
  final List<ExchangeOrderInfo> exchangeHistoryList;
  final Links links;
  final Meta meta;

  ExchangeHistoryData({
    required this.exchangeHistoryList,
    required this.links,
    required this.meta,
  });

  factory ExchangeHistoryData.fromJson(Map<String, dynamic> json) =>
      _$ExchangeHistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeHistoryDataToJson(this);
}

@JsonSerializable()
class ExchangeOrderInfo {
  final int id;
  final String date;
  @JsonKey(name: 'order_no')
  final String orderNo;
  @JsonKey(name: 'sale_type')
  final String saleType;
  final Customer customer;
  final int discount;
  final int amount;
  @JsonKey(name: 'paid_amount')
  final int paidAmount;
  final int vat;
  @JsonKey(name: 'is_actionable')
  final bool isActionable;

  ExchangeOrderInfo({
    required this.id,
    required this.date,
    required this.orderNo,
    required this.saleType,
    required this.customer,
    required this.discount,
    required this.amount,
    required this.paidAmount,
    required this.vat,
    required this.isActionable,
  });

  factory ExchangeOrderInfo.fromJson(Map<String, dynamic> json) =>
      _$ExchangeOrderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeOrderInfoToJson(this);
}

@JsonSerializable()
class Customer {
  final int id;
  final String name;
  final String phone;
  final String? address;

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
