import 'billing_payment_methods.dart';

class PaymentMethodTracker {
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;
  num? paidAmount;

  PaymentMethodTracker({this.paymentMethod, this.paymentOption, this.paidAmount});

  factory PaymentMethodTracker.fromJson(Map<String, dynamic> json) {
    return PaymentMethodTracker(
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
      'paymentMethod': paymentMethod?.toJson(),
      'paymentOption': paymentOption?.toJson(),
      'paidAmount': paidAmount,
    };
  }
}
