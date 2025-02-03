import 'package:json_annotation/json_annotation.dart';

part 'purchase_history_response_model.g.dart';


@JsonSerializable()
class PurchaseHistoryResponseModel {
  final bool success;

  @DataConverter()
  @JsonKey(name: 'data')
  final PurchaseHistoryData data;
  @JsonKey(name: 'count_total')
  final num countTotal;
  @JsonKey(name: 'amount_total')
  final num amountTotal;

  PurchaseHistoryResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal
  });

  factory PurchaseHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseHistoryResponseModelToJson(this);
}

@JsonSerializable()
class PurchaseHistoryData {
  @JsonKey(name: 'data')
  final List<PurchaseOrderInfo> purchaseHistoryList;
  final Meta? meta;

  PurchaseHistoryData({
    required this.purchaseHistoryList,
    required this.meta,
  });

  factory PurchaseHistoryData.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseHistoryDataToJson(this);
}

@JsonSerializable()
class PurchaseOrderInfo {
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

  PurchaseOrderInfo({
    required this.id,
    required this.dateTime,
    required this.supplier,
    required this.phone,
    required this.orderNo,
    required this.discount,
    required this.amount,
    required this.isActionable,
  });


  factory PurchaseOrderInfo.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOrderInfoToJson(this);
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


class DataConverter implements JsonConverter<PurchaseHistoryData, dynamic> {
  const DataConverter();

  @override
  PurchaseHistoryData fromJson(dynamic json) {
    if (json is List) {
      return PurchaseHistoryData(purchaseHistoryList: [], meta: null);
    } else if (json is Map<String, dynamic>) {
      return PurchaseHistoryData.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(PurchaseHistoryData object) => object.toJson();
}