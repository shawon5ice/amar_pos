// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponseModel _$DashboardResponseModelFromJson(
        Map<String, dynamic> json) =>
    DashboardResponseModel(
      success: json['success'] as bool,
      dashboardResponseData:
          DashboardResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseModelToJson(
        DashboardResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.dashboardResponseData,
    };

DashboardResponseData _$DashboardResponseDataFromJson(
        Map<String, dynamic> json) =>
    DashboardResponseData(
      products: (json['products'] as List<dynamic>)
          .map((e) => DashBoardProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      expense: json['expense'] as num,
      balance: json['balance'] as num,
      wholeSale: json['wholesale'] as num,
      retailSale: json['retailSale'] as num,
      cashOut: json['cashOut'] as num,
      cashIn: json['cashIn'] as num,
      collection: json['collection'] as num,
    );

Map<String, dynamic> _$DashboardResponseDataToJson(
        DashboardResponseData instance) =>
    <String, dynamic>{
      'products': instance.products,
      'cashIn': instance.cashIn,
      'cashOut': instance.cashOut,
      'balance': instance.balance,
      'retailSale': instance.retailSale,
      'wholesale': instance.wholeSale,
      'expense': instance.expense,
      'collection': instance.collection,
    };

DashBoardProduct _$DashBoardProductFromJson(Map<String, dynamic> json) =>
    DashBoardProduct(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sku: json['sku'] as String,
      alertQuantity: json['alert_quantity'] as num,
      stock: (json['stock'] as num).toInt(),
    );

Map<String, dynamic> _$DashBoardProductToJson(DashBoardProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'alert_quantity': instance.alertQuantity,
      'stock': instance.stock,
    };
