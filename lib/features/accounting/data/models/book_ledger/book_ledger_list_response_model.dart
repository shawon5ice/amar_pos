import 'package:json_annotation/json_annotation.dart';

part 'book_ledger_list_response_model.g.dart';

@JsonSerializable()
class BookLedgerListResponseModel {
  final bool success;
  @DataConverter()
  final List<DataWrapper>? data;

  BookLedgerListResponseModel({required this.success, required this.data,});

  factory BookLedgerListResponseModel.fromJson(Map<String, dynamic> json) => _$BookLedgerListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookLedgerListResponseModelToJson(this);
}

@JsonSerializable()
class DataWrapper {
  @JsonKey(name: 'data', )
  final BookLedgerList? data;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;
  @JsonKey()
  final String type;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? balance;

  DataWrapper({
    required this.data,
    required this.debit,
    required this.credit,
    required this.type,
    required this.balance,
  });


  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);
}



@JsonSerializable()
class BookLedgerList {
  @JsonKey(name: 'data', defaultValue: [])
  final List<LedgerData> data;
  @JsonKey(defaultValue: 0)
  final int? total;
  @JsonKey(defaultValue: 0, name: 'last_page')
  final int? lastPage;

  BookLedgerList({
    required this.data,
    this.total,
    this.lastPage
  });

  factory BookLedgerList.fromJson(Map<String, dynamic> json) => _$BookLedgerListFromJson(json);
  Map<String, dynamic> toJson() => _$BookLedgerListToJson(this);
}

@JsonSerializable()
class LedgerData {
  final String date;
  @JsonKey(name: 'sl_no')
  final String slNo;
  @JsonKey(name: 'account_name')
  final String? accountName;
  @JsonKey(name: 'full_narration')
  final String? fullNarration;
  final num? balance;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? debit;
  final String? type;
  @JsonKey(defaultValue: 0,fromJson: dynamicNumberFromJson, toJson: dynamicNumberToJson)
  final num? credit;


  LedgerData({
    required this.date,
    required this.slNo,
    required this.accountName,
    required this.fullNarration,
    required this.balance,
    required this.type,
    required this.debit,
    required this.credit,
  });

  factory LedgerData.fromJson(Map<String, dynamic> json) => _$LedgerDataFromJson(json);
  Map<String, dynamic> toJson() => _$LedgerDataToJson(this);
}

class DataConverter implements JsonConverter<DataWrapper?, dynamic> {
  const DataConverter();

  @override
  DataWrapper? fromJson(dynamic json) {
    if (json is List) {
      return null;
    } else if (json is Map<String, dynamic>) {
      return DataWrapper.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(DataWrapper? object) => object?.toJson();
}

num? dynamicNumberFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String && value.isEmpty) return null; // or 0.0 if needed
  return num.tryParse(value.toString());
}

 dynamic dynamicNumberToJson(num? value) => value ?? "";