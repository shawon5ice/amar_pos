import 'return_payment_methods.dart';

class ReturnPaymentMethodTracker {
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;
  num? paidAmount;

  ReturnPaymentMethodTracker({this.paymentMethod, this.paymentOption, this.paidAmount});

  factory ReturnPaymentMethodTracker.fromJson(Map<String, dynamic> json) {
    return ReturnPaymentMethodTracker(
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
