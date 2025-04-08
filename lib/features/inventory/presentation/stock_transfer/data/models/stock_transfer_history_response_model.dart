import 'package:json_annotation/json_annotation.dart';

part 'stock_transfer_history_response_model.g.dart';

@JsonSerializable()
class StockTransferResponse {
  final bool success;
  final StockTransferData data;
  @JsonKey(name: 'count_total')
  final int countTotal;
  @JsonKey(name: 'quantity_total')
  final int quantityTotal;
  @JsonKey(name: 'amount_total')
  final num amountTotal;

  StockTransferResponse({
    required this.success,
    required this.data,
    required this.countTotal,
    required this.quantityTotal,
    required this.amountTotal,
  });

  factory StockTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$StockTransferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StockTransferResponseToJson(this);
}

@JsonSerializable()
class StockTransferData {
  final List<StockTransfer> data;
  final PaginationMeta meta;

  StockTransferData({
    required this.data,
    required this.meta,
  });

  factory StockTransferData.fromJson(Map<String, dynamic> json) =>
      _$StockTransferDataFromJson(json);
  Map<String, dynamic> toJson() => _$StockTransferDataToJson(this);
}

@JsonSerializable()
class StockTransfer {
  final int id;
  final String date;
  @JsonKey(name: 'received_date')
  final String? receivedDate;
  @JsonKey(name: 'order_no')
  final String orderNo;
  @JsonKey(name: 'from_store')
  final Store fromStore;
  @JsonKey(name: 'to_store')
  final Store toStore;
  final int quantity;
  final num total;
  final int type;
  final String? remarks;
  final String status;
  @JsonKey(name: 'is_editable')
  final bool isEditable;
  @JsonKey(name: 'is_receivable')
  final bool isReceivable;

  StockTransfer({
    required this.id,
    required this.date,
    this.receivedDate,
    required this.orderNo,
    required this.fromStore,
    required this.toStore,
    required this.quantity,
    required this.total,
    required this.type,
    this.remarks,
    required this.status,
    required this.isEditable,
    required this.isReceivable,
  });

  factory StockTransfer.fromJson(Map<String, dynamic> json) =>
      _$StockTransferFromJson(json);
  Map<String, dynamic> toJson() => _$StockTransferToJson(this);
}

@JsonSerializable()
class Store {
  final int id;
  final String name;
  final String phone;
  final String address;

  Store({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) =>
      _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}


@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  PaginationMeta({
    required this.lastPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}
