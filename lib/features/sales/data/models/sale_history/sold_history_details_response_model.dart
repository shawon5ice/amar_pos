import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'sold_history_details_response_model.g.dart';

@JsonSerializable()
class SoldHistoryDetailsResponseModel {
  final bool success;
  final SoldHistoryDetailsData data;

  SoldHistoryDetailsResponseModel({required this.success, required this.data});

  factory SoldHistoryDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$SoldHistoryDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SoldHistoryDetailsResponseModelToJson(this);
}

@JsonSerializable()
class SoldHistoryDetailsData {
  final int id;
  @JsonKey(name: 'date_time')
  final String dateTime;
  @JsonKey(name: 'order_no')
  final String orderNo;
  @JsonKey(name: 'sale_type')
  final String saleType;
  final Customer customer;
  @JsonKey(name: 'sold_by')
  final String soldBy;
  @JsonKey(name: 'service_by')
  final ServiceBy? serviceBy;
  @JsonKey(name: 'sub_total')
  final double subTotal;
  final double expense;
  final double vat;
  final double payable;
  final Business business;
  @JsonKey(name: 'change_amount')
  final double changeAmount;
  final Store store;
  @JsonKey(name: 'order_details')
  final List<OrderDetail> details;
  @JsonKey(name: 'payment_details')
  final List<PaymentDetail> paymentDetails;
  final double discount;

  SoldHistoryDetailsData({
    required this.id,
    required this.dateTime,
    required this.orderNo,
    required this.saleType,
    required this.customer,
    required this.vat,
    required this.store,
    required this.serviceBy,
    required this.soldBy,
    required this.subTotal,
    required this.changeAmount,
    required this.expense,
    required this.payable,
    required this.business,
    required this.details,
    required this.paymentDetails,
    required this.discount,
  });

  factory SoldHistoryDetailsData.fromJson(Map<String, dynamic> json) => _$SoldHistoryDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$SoldHistoryDetailsDataToJson(this);
}


@JsonSerializable()
class Store {
  final int id;
  final String name;
  final String phone;
  final String address;

  Store({required this.id, required this.name, required this.phone, required this.address});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class ServiceBy {
  final int id;
  final String name;
  final String phone;
  final String email;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  ServiceBy({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.phone,});

  factory ServiceBy.fromJson(Map<String, dynamic> json) => _$ServiceByFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceByToJson(this);
}


@JsonSerializable()
class Customer {
  final int id;
  final String name;
  final String phone;
  final String address;

  Customer({required this.id, required this.name, required this.phone, required this.address});

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
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
class OrderDetail {
  final int id;
  @JsonKey(name: 'details_id')
  final int detailsId;
  final String name;
  final String warranty;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @JsonKey(name: 'wh_price')
  final double wholeSalePrice;
  @JsonKey(name: 'rp_price')
  final double retailSalePrice;
  final double vat;
  @JsonKey(name: 'vat_percent')
  final double vatPercent;
  @JsonKey(name: 'sn_no', defaultValue: [])
  final List<SnNo>? snNo;

  OrderDetail({
    required this.id,
    required this.detailsId,
    required this.retailSalePrice,
    required this.wholeSalePrice,
    required this.totalPrice,
    required this.vat,
    required this.vatPercent,
    required this.warranty,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.snNo,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable()
class PaymentDetail {
  final int id;
  @JsonKey(name: 'order_payment_id')
  final int orderPaymentId;
  final String name;
  final double amount;
  final List<BankDetail> details;
  final BankDetail? bank;

  PaymentDetail({
    required this.id,
    required this.orderPaymentId,
    required this.name,
    required this.amount,
    required this.details,
    this.bank,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => _$PaymentDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentDetailToJson(this);
}

@JsonSerializable()
class BankDetail {
  final int id;
  final String name;

  BankDetail({required this.id, required this.name});

  factory BankDetail.fromJson(Map<String, dynamic> json) => _$BankDetailFromJson(json);
  Map<String, dynamic> toJson() => _$BankDetailToJson(this);
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
