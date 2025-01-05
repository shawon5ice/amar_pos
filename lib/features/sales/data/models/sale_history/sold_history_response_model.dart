import 'package:json_annotation/json_annotation.dart';

part 'sold_history_response_model.g.dart';

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

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class SaleHistory {
  final int id;
  final String date;
  final String orderNo;
  final String saleType;
  final Customer customer;
  final double discount;
  final double amount;
  final double paidAmount;
  final double vat;
  final bool isActionable;

  SaleHistory({
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

  factory SaleHistory.fromJson(Map<String, dynamic> json) => _$SaleHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$SaleHistoryToJson(this);
}


@JsonSerializable()
class Meta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'from')
  final int from;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Data {
  final List<SaleHistory> saleHistoryList;
  final Meta meta;

  Data({
    required this.saleHistoryList,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class SaleHistoryResponseModel {
  final bool success;
  final Data data;
  @JsonKey(name: 'count_total')
  final int countTotal;
  @JsonKey(name: 'amount_total')
  final double amountTotal;

  SaleHistoryResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal,
  });

  factory SaleHistoryResponseModel.fromJson(Map<String, dynamic> json) => _$SaleHistoryResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleHistoryResponseModelToJson(this);
}
