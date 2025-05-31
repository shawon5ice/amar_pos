class ChartOfAccountOpeningHistoryListResponseModel {
  final bool success;
  final ChartOfAccountOpeningHistoryData? data;

  ChartOfAccountOpeningHistoryListResponseModel({
    required this.success,
    required this.data,
  });

  factory ChartOfAccountOpeningHistoryListResponseModel.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountOpeningHistoryListResponseModel(
      success: json['success'] ?? false,
      data:json['data'] is Map? ChartOfAccountOpeningHistoryData.fromJson(json['data']): null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
  };
}

class ChartOfAccountOpeningHistoryData {
  final List<ChartOfAccountOpeningEntry> data;
  final PaginationMeta meta;

  ChartOfAccountOpeningHistoryData({
    required this.data,
    required this.meta,
  });

  factory ChartOfAccountOpeningHistoryData.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountOpeningHistoryData(
      data: List<ChartOfAccountOpeningEntry>.from(
        json['data'].map((x) => ChartOfAccountOpeningEntry.fromJson(x)),
      ),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((x) => x.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class ChartOfAccountOpeningEntry {
  final int id;
  final Business? business;
  final String slNo;
  final Account? account;
  final String openingDate;
  final num amount;
  final int accountType;
  final String remarks;

  ChartOfAccountOpeningEntry({
    required this.id,
    this.business,
    required this.slNo,
    this.account,
    required this.openingDate,
    required this.amount,
    required this.accountType,
    required this.remarks,
  });

  factory ChartOfAccountOpeningEntry.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountOpeningEntry(
      id: json['id'],
      business: json['business'] is Map ? Business.fromJson(json['business']) : null,
      slNo: json['sl_no'],
      account: json['account'] is Map ?  Account.fromJson(json['account']) : null,
      openingDate: json['opening_date'],
      amount: json['amount'],
      accountType: json['account_type'],
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business': business?.toJson(),
    'sl_no': slNo,
    'account': account?.toJson(),
    'opening_date': openingDate,
    'amount': amount,
    'account_type': accountType,
    'remarks': remarks,
  };
}

class Business {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String logo;
  final String address;
  final String photoUrl;

  Business({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.logo,
    required this.address,
    required this.photoUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      address: json['address'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'logo': logo,
    'address': address,
    'photo_url': photoUrl,
  };
}

class Account {
  final int id;
  final int? businessId;
  final int? storeId;
  final String name;
  final String? code;
  final String? remarks;
  final int root;
  final int type;
  final int status;
  final dynamic createdBy;
  final dynamic updatedBy;
  final String? createdAt;
  final String? updatedAt;

  Account({
    required this.id,
    this.businessId,
    this.storeId,
    required this.name,
    this.code,
    this.remarks,
    required this.root,
    required this.type,
    required this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      businessId: json['business_id'],
      storeId: json['store_id'],
      name: json['name'],
      code: json['code'],
      remarks: json['remarks'],
      root: json['root'],
      type: json['type'],
      status: json['status'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_id': businessId,
    'store_id': storeId,
    'name': name,
    'code': code,
    'remarks': remarks,
    'root': root,
    'type': type,
    'status': status,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class PaginationMeta {
  final int lastPage;
  final int total;

  PaginationMeta({
    required this.lastPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      lastPage: json['last_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() => {
    'last_page': lastPage,
    'total': total,
  };
}
