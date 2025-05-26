import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_payment_invoice_details_response_model.g.dart';

@JsonSerializable()
class SupplierPaymentInvoiceDetailsResponseModel {
  final bool success;
  final SupplierPaymentInvoiceDetailsData data;

  SupplierPaymentInvoiceDetailsResponseModel({required this.success, required this.data});

  factory SupplierPaymentInvoiceDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$SupplierPaymentInvoiceDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierPaymentInvoiceDetailsResponseModelToJson(this);
}

@JsonSerializable()
class SupplierPaymentInvoiceDetailsData {
  final int id;
  final Business business;
  final Store store;
  final Supplier supplier;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final String date;
  final String remarks;
  final Creator creator;
  @JsonKey(name: 'previous_due')
  final double previousDue;
  final List<Detail> details;


  SupplierPaymentInvoiceDetailsData({
    required this.id,
    required this.business,
    required this.store,
    required this.supplier,
    required this.slNo,
    required this.date,
    required this.remarks,
    required this.creator,
    required this.previousDue,
    required this.details,
  });

  factory SupplierPaymentInvoiceDetailsData.fromJson(Map<String, dynamic> json) => _$SupplierPaymentInvoiceDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierPaymentInvoiceDetailsDataToJson(this);
}

@JsonSerializable()
class Supplier {
  final int id;
  final String business;
  final String name;
  final String code;
  final String phone;
  final String address;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  final double due;
  final String photo;
  final int status;

  Supplier({
    required this.id,
    required this.business,
    required this.name,
    required this.code,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.due,
    required this.photo,
    required this.status,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}

@JsonSerializable()
class Creator {
  final int id;
  final String name;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  Creator({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);
  Map<String, dynamic> toJson() => _$CreatorToJson(this);
}


@JsonSerializable()
class Detail {
  final int id;
  final double amount;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  Detail({
    required this.id,
    required this.amount,
    required this.paymentMethod,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String name;
  final int root;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.root,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}


// Re-using existing models from your provided code
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

  Store({required this.id, required this.name, required this.phone, required this.address});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class ServiceBy {
  final int id;
  final String name;
  String? phone;
  String? email;
  @JsonKey(name: 'photo_url')
  String? photoUrl;

  ServiceBy({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.phone,});

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
class OrderDetail {
  final int id;
  @JsonKey(name: 'details_id')
  final int detailsId;
  final String name;
  @JsonKey(defaultValue: 'N/A')
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


class ServiceByConverter implements JsonConverter<ServiceBy?, dynamic> {
  const ServiceByConverter();

  @override
  ServiceBy? fromJson(dynamic json) {
    if (json == null || (json is List && json.isEmpty)) {
      return null;
    } else if (json is Map<String, dynamic>) {
      return ServiceBy.fromJson(json);
    } else {
      throw Exception("Unexpected format for ServiceBy: $json");
    }
  }

  @override
  dynamic toJson(ServiceBy? object) {
    return object?.toJson();
  }
}