// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_payment_invoice_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierPaymentInvoiceDetailsResponseModel
    _$SupplierPaymentInvoiceDetailsResponseModelFromJson(
            Map<String, dynamic> json) =>
        SupplierPaymentInvoiceDetailsResponseModel(
          success: json['success'] as bool,
          data: SupplierPaymentInvoiceDetailsData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$SupplierPaymentInvoiceDetailsResponseModelToJson(
        SupplierPaymentInvoiceDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SupplierPaymentInvoiceDetailsData _$SupplierPaymentInvoiceDetailsDataFromJson(
        Map<String, dynamic> json) =>
    SupplierPaymentInvoiceDetailsData(
      id: (json['id'] as num).toInt(),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      slNo: json['sl_no'] as String,
      date: json['date'] as String,
      remarks: json['remarks'] as String,
      creator: Creator.fromJson(json['creator'] as Map<String, dynamic>),
      previousDue: (json['previous_due'] as num).toDouble(),
      details: (json['details'] as List<dynamic>)
          .map((e) => Detail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupplierPaymentInvoiceDetailsDataToJson(
        SupplierPaymentInvoiceDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business': instance.business,
      'store': instance.store,
      'supplier': instance.supplier,
      'sl_no': instance.slNo,
      'date': instance.date,
      'remarks': instance.remarks,
      'creator': instance.creator,
      'previous_due': instance.previousDue,
      'details': instance.details,
    };

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      id: (json['id'] as num).toInt(),
      business: json['business'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      openingBalance: (json['opening_balance'] as num).toDouble(),
      due: (json['due'] as num).toDouble(),
      photo: json['photo'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'id': instance.id,
      'business': instance.business,
      'name': instance.name,
      'code': instance.code,
      'phone': instance.phone,
      'address': instance.address,
      'opening_balance': instance.openingBalance,
      'due': instance.due,
      'photo': instance.photo,
      'status': instance.status,
    };

Creator _$CreatorFromJson(Map<String, dynamic> json) => Creator(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: PaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      root: (json['root'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
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
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      phone: json['phone'] as String?,
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
