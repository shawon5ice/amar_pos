// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_order_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeOrderDetailsResponseModel _$ExchangeOrderDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeOrderDetailsResponseModel(
      success: json['success'] as bool,
      data: ExchangeHistoryDetailsData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExchangeOrderDetailsResponseModelToJson(
        ExchangeOrderDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

ExchangeHistoryDetailsData _$ExchangeHistoryDetailsDataFromJson(
        Map<String, dynamic> json) =>
    ExchangeHistoryDetailsData(
      id: (json['id'] as num).toInt(),
      dateTime: json['date_time'] as String,
      orderNo: json['order_no'] as String,
      saleType: json['sale_type'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      returnTotal: json['return_total'] as num,
      exchangeTotal: json['exchange_total'] as num,
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      serviceBy: const ServiceByConverter().fromJson(json['service_by']),
      soldBy: json['sold_by'] as String,
      changeAmount: (json['change_amount'] as num).toDouble(),
      payable: json['payable'] as num,
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      returnDetails: (json['return_details'] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      exchangeDetails: (json['exchange_details'] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentDetails: (json['payment_details'] as List<dynamic>)
          .map((e) => PaymentDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$ExchangeHistoryDetailsDataToJson(
        ExchangeHistoryDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_time': instance.dateTime,
      'order_no': instance.orderNo,
      'sale_type': instance.saleType,
      'customer': instance.customer,
      'sold_by': instance.soldBy,
      'service_by': const ServiceByConverter().toJson(instance.serviceBy),
      'payable': instance.payable,
      'business': instance.business,
      'change_amount': instance.changeAmount,
      'store': instance.store,
      'return_total': instance.returnTotal,
      'return_details': instance.returnDetails,
      'exchange_total': instance.exchangeTotal,
      'exchange_details': instance.exchangeDetails,
      'payment_details': instance.paymentDetails,
      'discount': instance.discount,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

ServiceBy _$ServiceByFromJson(Map<String, dynamic> json) => ServiceBy(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$ServiceByToJson(ServiceBy instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'photo_url': instance.photoUrl,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
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
      detailsId: (json['details_id'] as num).toInt(),
      retailSalePrice: (json['rp_price'] as num).toDouble(),
      wholeSalePrice: (json['wh_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      vatPercent: (json['vat_percent'] as num).toDouble(),
      warranty: json['warranty'] as String? ?? 'N/A',
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      snNo: (json['sn_no'] as List<dynamic>?)
              ?.map((e) => SnNo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'details_id': instance.detailsId,
      'name': instance.name,
      'warranty': instance.warranty,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'wh_price': instance.wholeSalePrice,
      'rp_price': instance.retailSalePrice,
      'vat': instance.vat,
      'vat_percent': instance.vatPercent,
      'sn_no': instance.snNo,
    };

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      id: (json['id'] as num).toInt(),
      orderPaymentId: (json['order_payment_id'] as num).toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      details: (json['details'] as List<dynamic>)
          .map((e) => BankDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      bank: json['bank'] == null
          ? null
          : BankDetail.fromJson(json['bank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
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
      name: json['name'] as String,
    );

Map<String, dynamic> _$BankDetailToJson(BankDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
