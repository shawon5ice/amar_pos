import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dashboard_response_model.g.dart'; 

@JsonSerializable()
class DashboardResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final DashboardResponseData dashboardResponseData;

  DashboardResponseModel({
    required this.success,
    required this.dashboardResponseData,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseModelToJson(this);
}

@JsonSerializable()
class DashboardResponseData {
  final List<DashBoardProduct> products; // Fixed type to match the intended model.
  final num cashIn;
  final num cashOut;
  final num balance;
  final num retailSale;
  final num wholeSale;
  final num expense;
  final num collection;

  DashboardResponseData({
    required this.products,
    required this.expense,
    required this.balance,
    required this.wholeSale,
    required this.retailSale,
    required this.cashOut,
    required this.cashIn,
    required this.collection,
  });

  factory DashboardResponseData.fromJson(Map<String, dynamic> json) => _$DashboardResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseDataToJson(this);
}


@JsonSerializable()
class DashBoardProduct {
  final int id;
  final String name;
  final String sku;
  @JsonKey(name: 'alert_quantity')
  final num alertQuantity;
  final int stock;

  DashBoardProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.alertQuantity,
    required this.stock,
  });

  factory DashBoardProduct.fromJson(Map<String, dynamic> json) =>
      _$DashBoardProductFromJson(json);

  Map<String, dynamic> toJson() => _$DashBoardProductToJson(this);
}