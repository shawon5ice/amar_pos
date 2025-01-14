import 'return_payment_methods.dart';

class ReturnPaymentMethodTracker {
  final int id;
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;
  num? paidAmount;

  ReturnPaymentMethodTracker({required this.id, this.paymentMethod, this.paymentOption, this.paidAmount});

  factory ReturnPaymentMethodTracker.fromJson(Map<String, dynamic> json) {
    return ReturnPaymentMethodTracker(
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
