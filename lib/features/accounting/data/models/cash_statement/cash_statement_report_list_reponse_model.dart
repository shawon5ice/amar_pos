class CashStatementReportListResponseModel {
  final bool success;
  final List<CashStatementWrapper> data;

  CashStatementReportListResponseModel({
    required this.success,
    required this.data,
  });

  factory CashStatementReportListResponseModel.fromJson(Map<String, dynamic> json) {
    return CashStatementReportListResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((e) => CashStatementWrapper.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class CashStatementWrapper {
  final CashStatementData data;
  final num debit;
  final num credit;
  final String type;
  final num balance;

  CashStatementWrapper({
    required this.data,
    required this.debit,
    required this.credit,
    required this.type,
    required this.balance,
  });

  factory CashStatementWrapper.fromJson(Map<String, dynamic> json) {
    return CashStatementWrapper(
      data: CashStatementData.fromJson(json['data']),
      debit: json['debit'] ?? 0,
      credit: json['credit'] ?? 0,
      type: json['type'] ?? '',
      balance: json['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.toJson(),
    'debit': debit,
    'credit': credit,
    'type': type,
    'balance': balance,
  };
}

class CashStatementData {
  final int currentPage;
  final List<CashStatementEntry> data;
  final int from;
  final int lastPage;
  final String path;
  final int perPage;
  final int to;
  final int total;

  CashStatementData({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory CashStatementData.fromJson(Map<String, dynamic> json) {
    return CashStatementData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List)
          .map((e) => CashStatementEntry.fromJson(e))
          .toList(),
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': data.map((e) => e.toJson()).toList(),
    'from': from,
    'last_page': lastPage,
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

class CashStatementEntry {
  final String date;
  final String slNo;
  final String refNo;
  final String accountName;
  final String fullNarration;
  final num debit;
  final num credit;
  final String type;
  final num balance;

  CashStatementEntry({
    required this.date,
    required this.slNo,
    required this.refNo,
    required this.accountName,
    required this.fullNarration,
    required this.debit,
    required this.credit,
    required this.type,
    required this.balance,
  });

  factory CashStatementEntry.fromJson(Map<String, dynamic> json) {
    return CashStatementEntry(
      date: json['date'] ?? '',
      slNo: json['sl_no'] ?? '',
      refNo: json['ref_no'] ?? '',
      accountName: json['account_name'] ?? '',
      fullNarration: json['full_narration'] ?? '',
      debit: json['debit'] == ""? 0:  json['debit'] ?? 0,
      credit: json['credit'] == ""? 0: json['credit'] ?? 0,
      type: json['type'] ?? '',
      balance: json['balance'] == ""? 0:  json['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'sl_no': slNo,
    'ref_no': refNo,
    'account_name': accountName,
    'full_narration': fullNarration,
    'debit': debit,
    'credit': credit,
    'type': type,
    'balance': balance,
  };
}
