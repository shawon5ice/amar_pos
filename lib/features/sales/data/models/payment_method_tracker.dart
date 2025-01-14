import 'billing_payment_methods.dart';

class PaymentMethodTracker {
  final int id;
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;
  num? paidAmount;

  PaymentMethodTracker({required this.id, this.paymentMethod, this.paymentOption, this.paidAmount});

  factory PaymentMethodTracker.fromJson(Map<String, dynamic> json) {
    return PaymentMethodTracker(
      id: json['id'],
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      paymentOption: json['paymentOption'] != null
          ? PaymentOption.fromJson(json['paymentOption'])
          : null,
      paidAmount: json['paidAmount'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentMethod': paymentMethod?.toJson(),
      'paymentOption': paymentOption?.toJson(),
      'paidAmount': paidAmount,
    };
  }
}
