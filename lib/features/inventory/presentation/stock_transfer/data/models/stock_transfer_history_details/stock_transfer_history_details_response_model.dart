import 'package:json_annotation/json_annotation.dart';

part 'stock_transfer_history_details_response_model.g.dart';

@JsonSerializable()
class StockTransferHistoryDetailsResponseModel {
  final bool success;
  final StockTransferHistoryDetailsData data;

  StockTransferHistoryDetailsResponseModel({required this.success, required this.data});

  factory StockTransferHistoryDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$StockTransferHistoryDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$StockTransferHistoryDetailsResponseModelToJson(this);
}

@JsonSerializable()
class StockTransferHistoryDetailsData {
  final int id;
  final String date;
  @JsonKey(name: 'order_no')
  final String orderNo;
  final int quantity;
  final int type;
  final String? remarks;
  final Business business;
  @JsonKey(name: 'from_store')
  final Store fromStore;
  @JsonKey(name: 'to_store')
  final Store toStore;
  @JsonKey(name: 'order_details')
  final List<OrderDetail> details;

  StockTransferHistoryDetailsData({
    required this.id,
    required this.date,
    required this.orderNo,
    required this.type,
    required this.remarks,
    required this.quantity,
    required this.details,
    required this.business,
    required this.fromStore,
    required this.toStore,
  });

  factory StockTransferHistoryDetailsData.fromJson(Map<String, dynamic> json) => _$StockTransferHistoryDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$StockTransferHistoryDetailsDataToJson(this);
}

@JsonSerializable()
class Business {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String logo;
  final String address;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.logo,
    required this.address,
    required this.photoUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
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

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class OrderDetail {
  final int id;
  @JsonKey(name: 'details_id')
  final int detailsId;
  final String name;
  final int quantity;
  @JsonKey(name: 'costing_price')
  final double costingPrice;
  final double total;
  @JsonKey(name: 'sn_no')
  final List<SnNo>? snNo;

  OrderDetail({
    required this.id,
    required this.detailsId,
    required this.name,
    required this.quantity,
    required this.costingPrice,
    required this.total,
    this.snNo,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}


class SnNo {
  SnNo({
    required this.id,
    required this.serialNo,
  });
  late final int id;
  late final String serialNo;

  SnNo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    serialNo = json['serial_no'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['serial_no'] = serialNo;
    return _data;
  }
}
