// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_return_history_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseReturnHistoryDetailsResponseModel
    _$PurchaseReturnHistoryDetailsResponseModelFromJson(
            Map<String, dynamic> json) =>
        PurchaseReturnHistoryDetailsResponseModel(
          success: json['success'] as bool,
          data: PurchaseReturnHistoryDetailsData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$PurchaseReturnHistoryDetailsResponseModelToJson(
        PurchaseReturnHistoryDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

PurchaseReturnHistoryDetailsData _$PurchaseReturnHistoryDetailsDataFromJson(
        Map<String, dynamic> json) =>
    PurchaseReturnHistoryDetailsData(
      id: (json['id'] as num).toInt(),
      dateTime: json['date_time'] as String,
      orderNo: json['order_no'] as String,
      purchaseType: json['purchase_type'] as String,
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      createdBy: json['created_by'] as String,
      subTotal: json['sub_total'] as num,
      expense: json['expense'] as num,
      payable: json['payable'] as num,
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      details: (json['details'] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentDetails: (json['payment_details'] as List<dynamic>)
          .map((e) => PaymentDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      dueAmount: json['due_amount'] as num,
      deduction: json['deduction'] as num,
    );

Map<String, dynamic> _$PurchaseReturnHistoryDetailsDataToJson(
        PurchaseReturnHistoryDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_time': instance.dateTime,
      'order_no': instance.orderNo,
      'purchase_type': instance.purchaseType,
      'supplier': instance.supplier,
      'created_by': instance.createdBy,
      'sub_total': instance.subTotal,
      'expense': instance.expense,
      'payable': instance.payable,
      'business': instance.business,
      'details': instance.details,
      'payment_details': instance.paymentDetails,
      'due_amount': instance.dueAmount,
      'deduction': instance.deduction,
    };

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      logo: json['logo'] as String,
      address: json['address'] as String,
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'logo': instance.logo,
      'address': instance.address,
      'photo_url': instance.photoUrl,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      id: (json['id'] as num).toInt(),
      lineId: (json['line_id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unit_price'] as num,
      total: json['total'] as num,
      snNo: (json['sn_no'] as List<dynamic>?)
          ?.map((e) => SnNo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'line_id': instance.lineId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total': instance.total,
      'sn_no': instance.snNo,
    };

PaymentDetail _$PaymentDetailFromJson(Map<String, dynamic> json) =>
    PaymentDetail(
      id: (json['id'] as num).toInt(),
      orderPaymentId: (json['order_payment_id'] as num).toInt(),
      name: json['name'] as String,
      amount: json['amount'] as num,
      details: (json['details'] as List<dynamic>)
          .map((e) => BankDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      bank: json['bank'] == null
          ? null
          : BankDetail.fromJson(json['bank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentDetailToJson(PaymentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_payment_id': instance.orderPaymentId,
      'name': instance.name,
      'amount': instance.amount,
      'details': instance.details,
      'bank': instance.bank,
    };

BankDetail _$BankDetailFromJson(Map<String, dynamic> json) => BankDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$BankDetailToJson(BankDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
