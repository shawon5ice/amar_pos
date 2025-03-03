import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'purchase_return_history_details_response_model.g.dart';

@JsonSerializable()
class PurchaseReturnHistoryDetailsResponseModel {
  final bool success;
  final PurchaseReturnHistoryDetailsData data;

  PurchaseReturnHistoryDetailsResponseModel({required this.success, required this.data});

  factory PurchaseReturnHistoryDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$PurchaseReturnHistoryDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseReturnHistoryDetailsResponseModelToJson(this);
}

@JsonSerializable()
class PurchaseReturnHistoryDetailsData {
  final int id;
  @JsonKey(name: 'date_time')
  final String dateTime;
  @JsonKey(name: 'order_no')
  final String orderNo;
  @JsonKey(name: 'purchase_type')
  final String purchaseType;
  final Supplier supplier;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'sub_total')
  final num subTotal;
  final num expense;
  final num payable;
  final Business business;
  final List<OrderDetail> details;
  @JsonKey(name: 'payment_details')
  final List<PaymentDetail> paymentDetails;
  @JsonKey(name: 'due_amount')
  final num dueAmount;
  final num deduction;

  PurchaseReturnHistoryDetailsData({
    required this.id,
    required this.dateTime,
    required this.orderNo,
    required this.purchaseType,
    required this.supplier,
    required this.createdBy,
    required this.subTotal,
    required this.expense,
    required this.payable,
    required this.business,
    required this.details,
    required this.paymentDetails,
    required this.dueAmount,
    required this.deduction,
  });

  factory PurchaseReturnHistoryDetailsData.fromJson(Map<String, dynamic> json) => _$PurchaseReturnHistoryDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseReturnHistoryDetailsDataToJson(this);
}

@JsonSerializable()
class Supplier {
  final int id;
  final String name;
  final String phone;
  final String address;

  Supplier({required this.id, required this.name, required this.phone, required this.address});

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
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
  @JsonKey(name: 'line_id')
  final int lineId;
  final String name;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final num unitPrice;
  final num total;
  @JsonKey(name: 'sn_no')
  final List<SnNo>? snNo;

  OrderDetail({
    required this.id,
    required this.lineId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
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
  final num amount;
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
  final String? name;

  BankDetail({required this.id, this.name});

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
