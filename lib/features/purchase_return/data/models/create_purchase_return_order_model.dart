class CreatePurchaseReturnOrderModel {
  int purchaseType;
  int supplierId;
  List<PurchaseReturnProductModel> products;
  double amount;
  double expense;
  double discount;
  double payable;
  List<Payment> payments;

  CreatePurchaseReturnOrderModel({
    required this.purchaseType,
    required this.supplierId,
    required this.products,
    required this.amount,
    required this.expense,
    required this.discount,
    required this.payable,
    required this.payments,
  });

  CreatePurchaseReturnOrderModel.defaultConstructor()
      : purchaseType = 1,
        supplierId = 0,
        products = [],
        amount = 0.0,
        expense = 0.0,
        discount = 0.0,
        payable = 0.0,
        payments = [];

  factory CreatePurchaseReturnOrderModel.fromJson(Map<String, dynamic> json) {
    return CreatePurchaseReturnOrderModel(
      purchaseType: json['purchase_type'],
      supplierId: json['supplier_id'],
      products: (json['product'] as List)
          .map((productJson) => PurchaseReturnProductModel.fromJson(productJson))
          .toList(),
      amount: json['amount'].toDouble(),
      expense: json['expense'].toDouble(),
      discount: json['discount'].toDouble(),
      payable: json['payable'].toDouble(),
      payments: (json['payment'] as List)
          .map((paymentJson) => Payment.fromJson(paymentJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_type': purchaseType,
      'supplier_id' : supplierId,
      'product': products.map((product) => product.toJson()).toList(),
      'amount': amount,
      'expense': expense,
      'discount': discount,
      'payable': payable,
      'payment': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class PurchaseReturnProductModel {
  int id;
  double unitPrice;
  int quantity;
  num vat;
  num? discount;
  List<String> serialNo;

  PurchaseReturnProductModel({
    required this.id,
    required this.unitPrice,
    required this.quantity,
    required this.vat,
    required this.serialNo,
    this.discount,
  });

  factory PurchaseReturnProductModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnProductModel(
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
