class JournalListResponseModel {
  final bool success;
  final JournalListData? data;

  JournalListResponseModel({
    required this.success,
    required this.data,
  });

  factory JournalListResponseModel.fromJson(Map<String, dynamic> json) {
    return JournalListResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? JournalListData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
  };
}

class JournalListData {
  final List<JournalEntryData> data;
  final PaginationMeta meta;

  JournalListData({
    required this.data,
    required this.meta,
  });

  factory JournalListData.fromJson(Map<String, dynamic> json) {
    return JournalListData(
      data: List<JournalEntryData>.from(json['data'].map((x) => JournalEntryData.fromJson(x))),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((x) => x.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class JournalEntryData {
  final int id;
  final String date;
  final String slNo;
  final String account;
  final String voucherType;
  final String? sourceNo;
  final num amount;
  final String? remarks;
  final String createdBy;
  final int isAutoJournal;

  JournalEntryData({
    required this.id,
    required this.date,
    required this.slNo,
    required this.account,
    required this.voucherType,
    this.sourceNo,
    required this.amount,
    this.remarks,
    required this.createdBy,
    required this.isAutoJournal,
  });

  factory JournalEntryData.fromJson(Map<String, dynamic> json) {
    return JournalEntryData(
      id: json['id'],
      date: json['date'],
      slNo: json['sl_no'],
      account: json['account'],
      voucherType: json['voucher_type'],
      sourceNo: json['source_no'],
      amount: json['amount'],
      remarks: json['remarks'],
      createdBy: json['created_by'],
      isAutoJournal: json['is_auto_journal'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'sl_no': slNo,
    'account': account,
    'voucher_type': voucherType,
    'source_no': sourceNo,
    'amount': amount,
    'remarks': remarks,
    'created_by': createdBy,
    'is_auto_journal': isAutoJournal,
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
