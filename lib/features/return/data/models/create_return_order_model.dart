class CreateReturnOrderModel {
  int saleType;
  String name;
  String phone;
  String address;
  List<ReturnProductModel> products;
  double returnAmount;
  double deduction;
  double amount;
  double vat;
  List<Payment> payments;
  int serviceBy;
  int? customerId;

  CreateReturnOrderModel({
    required this.saleType,
    required this.name,
    required this.phone,
    required this.address,
    required this.products,
    required this.returnAmount,
    required this.deduction,
    required this.vat,
    required this.amount,
    required this.payments,
    required this.serviceBy,
    this.customerId,
  });

  CreateReturnOrderModel.defaultConstructor()
      : saleType = 0,
        name = '',
        phone = '',
        address = '',
        products = [],
        returnAmount = 0.0,
        deduction = 0.0,
        vat = 0.0,
        amount = 0.0,
        serviceBy = 0,
        customerId = 0,
        payments = [];

  factory CreateReturnOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateReturnOrderModel(
      saleType: json['sale_type'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      products: (json['product'] as List)
          .map((productJson) => ReturnProductModel.fromJson(productJson))
          .toList(),
      returnAmount: json['return_amount'].toDouble(),
      deduction: json['deduction'].toDouble(),
      vat: json['vat'].toDouble(),
      amount: json['amount'].toDouble(),
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
      'return_amount': returnAmount,
      'deduction': deduction,
      'amount': amount,
      'vat': vat,
      'service_by': serviceBy,
      'customer_id': customerId,
      'payment': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class ReturnProductModel {
  int id;
  double unitPrice;
  int quantity;
  num vat;
  num? discount;
  List<String> serialNo;

  ReturnProductModel({
    required this.id,
    required this.unitPrice,
    required this.quantity,
    required this.vat,
    required this.serialNo,
    this.discount,
  });

  factory ReturnProductModel.fromJson(Map<String, dynamic> json) {
    return ReturnProductModel(
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
      'serial_no': serialNo,
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
