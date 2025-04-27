class CreateExchangeRequestModel {
  int saleType;
  String name;
  String phone;
  String address;
  List<ProductModel> returnProducts;
  List<ProductModel> exchangeProducts;
  double returnAmount;
  double exchangeAmount;
  double discount;
  double payable;
  List<Payment> payments;
  int? serviceBy;
  int? customerId;

  CreateExchangeRequestModel({
    required this.saleType,
    required this.name,
    required this.phone,
    required this.address,
    required this.returnProducts,
    required this.exchangeProducts,
    required this.returnAmount,
    required this.exchangeAmount,
    required this.discount,
    required this.payable,
    required this.payments,
    required this.serviceBy,
    this.customerId,
  });

  CreateExchangeRequestModel.defaultConstructor()
      : saleType = 0,
        name = '',
        phone = '',
        address = '',
        returnProducts = [],
        exchangeProducts = [],
        returnAmount = 0.0,
        exchangeAmount = 0.0,
        discount = 0.0,
        payable = 0.0,
        serviceBy = 0,
        customerId = 0,
        payments = [];

  factory CreateExchangeRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateExchangeRequestModel(
      saleType: json['sale_type'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      returnProducts: (json['product'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
      exchangeProducts: (json['product'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
      returnAmount: json['return_amount'].toDouble(),
      exchangeAmount: json['exchange_amount'].toDouble(),
      discount: json['discount'].toDouble(),
      payable: json['payable'].toDouble(),
      serviceBy: json['service_by'],
      customerId: json['customer_id'],
      payments: (json['payment'] as List)
          .map((paymentJson) => Payment.fromJson(paymentJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sale_type': saleType,
      'name': name,
      'phone': phone,
      'address': address,
      'return_product': returnProducts.map((product) => product.toJson()).toList(),
      'exchange_product': exchangeProducts.map((product) => product.toJson()).toList(),
      'return_amount': returnAmount,
      'exchange_amount': exchangeAmount,
      'discount': discount,
      'payable': payable,
      'service_by': serviceBy,
      'customer_id': customerId,
      'payment': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class ProductModel {
  int id;
  double unitPrice;
  int quantity;
  num vat;
  num? discount;
  List<String> serialNo;

  ProductModel({
    required this.id,
    required this.unitPrice,
    required this.quantity,
    required this.vat,
    required this.serialNo,
    this.discount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      unitPrice: json['unit_price'].toDouble(),
      quantity: json['quantity'],
      vat: json['vat'] ?? 0,
      serialNo: json['serial_no'],
      discount: json['discount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_price': unitPrice,
      'quantity': quantity,
      'vat': vat,
      'discount': discount,
      'serial_no': serialNo.isEmpty ? null : serialNo,
    };
  }
}

class Payment {
  int methodId;
  int? bankId;
  double paid;

  Payment({
    required this.methodId,
    required this.paid,
    this.bankId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      methodId: json['method_id'],
      paid: json['paid'].toDouble(),
      bankId: json['bank_id'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method_id': methodId,
      'paid': paid,
      'bank_id': bankId,
    };
  }
}
