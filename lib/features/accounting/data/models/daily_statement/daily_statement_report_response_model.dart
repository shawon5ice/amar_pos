import 'package:json_annotation/json_annotation.dart';

part 'daily_statement_report_response_model.g.dart';


@JsonSerializable()
class DailyStatementReportResponseModel {
  final bool success;
  @DataConverter()
  final DailyStatementData data;

  DailyStatementReportResponseModel({
    required this.success,
    required this.data,
  });

  factory DailyStatementReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DailyStatementReportResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatementReportResponseModelToJson(this);
}

@JsonSerializable()
class DailyStatementData {
  final List<DailyStatementItem> data;
  final Meta meta;

  DailyStatementData({
    required this.data,
    required this.meta,
  });

  factory DailyStatementData.fromJson(Map<String, dynamic> json) =>
      _$DailyStatementDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatementDataToJson(this);
}

@JsonSerializable()
class DailyStatementItem {
  final String date;
  final String order_no;
  final String transaction;
  final num total;

  DailyStatementItem({
    required this.date,
    required this.order_no,
    required this.transaction,
    required this.total,
  });

  factory DailyStatementItem.fromJson(Map<String, dynamic> json) =>
      _$DailyStatementItemFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatementItemToJson(this);
}

@JsonSerializable()
class Meta {
  final int last_page;
  final int total;

  Meta({
    required this.last_page,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);

  Meta.empty():
        last_page = 0,
        total = 0;
}



class DataConverter implements JsonConverter<DailyStatementData, dynamic> {
  const DataConverter();

  @override
  DailyStatementData fromJson(dynamic json) {
    if (json is List) {
      return DailyStatementData(data: [],meta: Meta.empty());
    } else if (json is Map<String, dynamic>) {
      return DailyStatementData.fromJson(json);
    } else {
      throw Exception('Unexpected type for data: ${json.runtimeType}');
    }
  }

  @override
  dynamic toJson(DailyStatementData object) => object.toJson();
}