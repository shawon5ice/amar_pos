// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_voucher_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseVoucherResponseModel _$ExpenseVoucherResponseModelFromJson(
        Map<String, dynamic> json) =>
    ExpenseVoucherResponseModel(
      success: json['success'] as bool,
      data: const DataConverter().fromJson(json['data']),
    );

Map<String, dynamic> _$ExpenseVoucherResponseModelToJson(
        ExpenseVoucherResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.data),
    };

DataWrapper _$DataWrapperFromJson(Map<String, dynamic> json) => DataWrapper(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataWrapperToJson(DataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      slNo: json['sl_no'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      paymentMethod: ChartOfAccountPaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      accountType: (json['account_type'] as num).toInt(),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'sl_no': instance.slNo,
      'category': instance.category,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'account_type': instance.accountType,
      'remarks': instance.remarks,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      businessId: (json['business_id'] as num?)?.toInt(),
      storeId: (json['store_id'] as num?)?.toInt(),
      name: json['name'] as String,
      code: json['code'] as String?,
      remarks: json['remarks'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'store_id': instance.storeId,
      'name': instance.name,
      'code': instance.code,
      'remarks': instance.remarks,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      businessId: (json['business_id'] as num?)?.toInt(),
      storeId: (json['store_id'] as num?)?.toInt(),
      name: json['name'] as String,
      code: json['code'] as String?,
      remarks: json['remarks'] as String?,
      root: (json['root'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'store_id': instance.storeId,
      'name': instance.name,
      'code': instance.code,
      'remarks': instance.remarks,
      'root': instance.root,
      'type': instance.type,
      'status': instance.status,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'last_page': instance.lastPage,
      'total': instance.total,
    };
