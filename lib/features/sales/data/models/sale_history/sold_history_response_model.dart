import 'package:json_annotation/json_annotation.dart';

part 'sold_history_response_model.g.dart';

@JsonSerializable()
class Customer {
  final int id;
  final String name;
  final String phone;
  @JsonKey(defaultValue: "N/A")
  final String? address;

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
  @JsonKey(name: 'order_no')
  final String orderNo;
  @JsonKey(name: 'sale_type')
  final String saleType;
  final Customer customer;
  final double discount;
  final double amount;
  @JsonKey(name: 'paid_amount')
  final double paidAmount;
  final double vat;
  @JsonKey(name: 'is_actionable')
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

  Meta.empty()
      : currentPage = 0,
        lastPage = 0,
        from = 0,
        total = 0;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'data')
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
  @DataConverter()
  final Data data;
  @JsonKey(name: 'count_total')
  int countTotal;
  @JsonKey(name: 'amount_total')
  double amountTotal;

  SaleHistoryResponseModel({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.amountTotal,
  });

  factory SaleHistoryResponseModel.fromJson(Map<String, dynamic> json) => _$SaleHistoryResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleHistoryResponseModelToJson(this);
}


class DataConverter implements JsonConverter<Data, dynamic> {
  const DataConverter();

  @override
  Data fromJson(dynamic json) {
    if (json is List) {
      return Data(saleHistoryList: [],meta: Meta.empty());
    } else if (json is Map<String, dynamic>) {
      return Data.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(Data object) => object.toJson();
}