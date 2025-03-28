class CreateSaleOrderModel {
  int saleType;
  String name;
  String phone;
  String address;
  List<SaleProductModel> products;
  double amount;
  double expense;
  double discount;
  double vat;
  double payable;
  List<Payment> payments;
  int serviceBy;
  int? customerId;

  CreateSaleOrderModel({
    required this.saleType,
    required this.name,
    required this.phone,
    required this.address,
    required this.products,
    required this.amount,
    required this.expense,
    required this.discount,
    required this.vat,
    required this.payable,
    required this.payments,
    required this.serviceBy,
    this.customerId,
  });

  CreateSaleOrderModel.defaultConstructor()
      : saleType = 0,
        name = '',
        phone = '',
        address = '',
        products = [],
        amount = 0.0,
        expense = 0.0,
        discount = 0.0,
        vat = 0.0,
        payable = 0.0,
        serviceBy = 0,
        customerId = 0,
        payments = [];

  factory CreateSaleOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateSaleOrderModel(
      saleType: json['sale_type'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      products: (json['product'] as List)
          .map((productJson) => SaleProductModel.fromJson(productJson))
          .toList(),
      amount: json['amount'].toDouble(),
      expense: json['expense'].toDouble(),
      discount: json['discount'].toDouble(),
      vat: json['vat'].toDouble(),
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
      'product': products.map((product) => product.toJson()).toList(),
      'amount': amount,
      'expense': expense,
      'vat': vat,
      'discount': discount,
      'payable': payable,
      'service_by': serviceBy,
      'customer_id': customerId,
      'payment': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class SaleProductModel {
  int id;
  num unitPrice;
  int quantity;
  num vat;
  num? discount;
  List<String> serialNo;

  SaleProductModel({
    required this.id,
    required this.unitPrice,
    required this.quantity,
    required this.vat,
    required this.serialNo,
    this.discount,
  });

  factory SaleProductModel.fromJson(Map<String, dynamic> json) {
    return SaleProductModel(
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
