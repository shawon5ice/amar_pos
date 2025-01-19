import 'package:amar_pos/core/core.dart';

class ExchangePaymentMethodTracker {
  final int id;
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;
  num? paidAmount;

  ExchangePaymentMethodTracker({required this.id, this.paymentMethod, this.paymentOption, this.paidAmount});

  factory ExchangePaymentMethodTracker.fromJson(Map<String, dynamic> json) {
    return ExchangePaymentMethodTracker(
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
