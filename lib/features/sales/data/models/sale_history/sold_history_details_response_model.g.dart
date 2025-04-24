// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_history_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoldHistoryDetailsResponseModel _$SoldHistoryDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    SoldHistoryDetailsResponseModel(
      success: json['success'] as bool,
      data:
          SoldHistoryDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SoldHistoryDetailsResponseModelToJson(
        SoldHistoryDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SoldHistoryDetailsData _$SoldHistoryDetailsDataFromJson(
        Map<String, dynamic> json) =>
    SoldHistoryDetailsData(
      id: (json['id'] as num).toInt(),
      dateTime: json['date_time'] as String,
      orderNo: json['order_no'] as String,
      saleType: json['sale_type'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      vat: (json['vat'] as num).toDouble(),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      serviceBy: json['service_by'] == null
          ? null
          : ServiceBy.fromJson(json['service_by'] as Map<String, dynamic>),
      soldBy: json['sold_by'] as String,
      subTotal: (json['sub_total'] as num).toDouble(),
      changeAmount: (json['change_amount'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      payable: (json['payable'] as num).toDouble(),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      details: (json['order_details'] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentDetails: (json['payment_details'] as List<dynamic>)
          .map((e) => PaymentDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$SoldHistoryDetailsDataToJson(
        SoldHistoryDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_time': instance.dateTime,
      'order_no': instance.orderNo,
      'sale_type': instance.saleType,
      'customer': instance.customer,
      'sold_by': instance.soldBy,
      'service_by': instance.serviceBy,
      'sub_total': instance.subTotal,
      'expense': instance.expense,
      'vat': instance.vat,
      'payable': instance.payable,
      'business': instance.business,
      'change_amount': instance.changeAmount,
      'store': instance.store,
      'order_details': instance.details,
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
      address: json['address'] as String? ?? 'N/a',
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

PaymentDetail _$PaymentDetailFromJson(Map<String, dynamic> json) =>
    PaymentDetail(
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
      name: json['name'] as String,
    );

Map<String, dynamic> _$BankDetailToJson(BankDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
