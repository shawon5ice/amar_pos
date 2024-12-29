class BillingPaymentMethods {
  final bool success;
  final List<PaymentMethod> data;

  BillingPaymentMethods({required this.success, required this.data});

  factory BillingPaymentMethods.fromJson(Map<String, dynamic> json) {
    return BillingPaymentMethods(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => PaymentMethod.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((method) => method.toJson()).toList(),
    };
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final List<PaymentOption> paymentOptions;

  PaymentMethod({required this.id, required this.name, required this.paymentOptions});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as int,
      name: json['name'] as String,
      paymentOptions: (json['details'] as List)
          .map((item) => PaymentOption.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': paymentOptions.map((detail) => detail.toJson()).toList(),
    };
  }
}

class PaymentOption {
  final int id;
  final String name;

  PaymentOption({required this.id, required this.name});

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
