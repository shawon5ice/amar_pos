import 'package:json_annotation/json_annotation.dart';

part 'daily_statement_report_response_model.g.dart';

@JsonSerializable()
class DailyStatementReportResponseModel {
  final bool success;
  final List<DailyStatementData> data;

  DailyStatementReportResponseModel({
    required this.success,
    required this.data,
  });

  factory DailyStatementReportResponseModel.fromJson(Map<String, dynamic> json) => _$DailyStatementReportResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStatementReportResponseModelToJson(this);
}

@JsonSerializable()
class DailyStatementData {
  @DataConverter()
  final StatementData data;
  final double debit;
  final double credit;
  final double balance;

  DailyStatementData({
    required this.data,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory DailyStatementData.fromJson(Map<String, dynamic> json) => _$DailyStatementDataFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStatementDataToJson(this);
}

@JsonSerializable()
class StatementData {
  final List<TransactionData> data;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  StatementData({
    required this.data,
    this.lastPage = 0,
    this.total = 0,
  });

  factory StatementData.fromJson(Map<String, dynamic> json) => _$StatementDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatementDataToJson(this);
}

@JsonSerializable()
class TransactionData {
  @JsonKey(name: 'account_type')
  final int accountType;
  @JsonKey(name: 'sl_no')
  final String slNo;
  final double amount;
  final String date;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  final String? purpose;

  TransactionData({
    required this.accountType,
    required this.slNo,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.purpose,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) => _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

class DataConverter implements JsonConverter<StatementData, dynamic> {
  const DataConverter();

  @override
  StatementData fromJson(dynamic json) {
    if (json is List) {
      return StatementData(data: []);
    } else if (json is Map<String, dynamic>) {
      return StatementData.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(StatementData object) => object.toJson();
}