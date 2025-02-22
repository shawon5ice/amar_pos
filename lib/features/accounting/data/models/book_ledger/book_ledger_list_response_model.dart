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
  @JsonKey(toJson: _debitToJson, fromJson: _debitFromJson)
  final num? debit;
  @JsonKey(toJson: _debitToJson, fromJson: _debitFromJson)
  final num? credit;
  @JsonKey()
  final String type;
  @JsonKey()
  final num balance;

  DataWrapper({
    required this.data,
    required this.debit,
    required this.credit,
    required this.type,
    required this.balance,
  });


  factory DataWrapper.fromJson(Map<String, dynamic> json) => _$DataWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$DataWrapperToJson(this);

  static num? _debitFromJson(dynamic value) {
    if (value is num) return value;
    if (value is String && value.isEmpty) return null; // or 0.0 if needed
    return num.tryParse(value.toString());
  }

  /// Custom toJson function
  static dynamic _debitToJson(num? value) => value ?? "";
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
  @JsonKey(defaultValue: 0)
  final dynamic debit;
  final String? type;
  @JsonKey(defaultValue: 0)
  final dynamic credit;


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

//
// class BookLedgerListResponseModel {
//   bool? success;
//   List<Data>? data;
//
//   BookLedgerListResponseModel({this.success, this.data});
//
//   BookLedgerListResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['success'] = success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   Data1? data1;
//   double? debit;
//   int? credit;
//   String? type;
//   double? balance;
//
//   Data({this.data1, this.debit, this.credit, this.type, this.balance});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     data1 = json['data'] != null ? Data1.fromJson(json['data']) : null;
//     debit = json['debit'];
//     credit = json['credit'];
//     type = json['type'];
//     balance = json['balance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (data1 != null) {
//       data['data'] = data1!.toJson();
//     }
//     data['debit'] = debit;
//     data['credit'] = credit;
//     data['type'] = type;
//     data['balance'] = balance;
//     return data;
//   }
// }
//
// class Data1 {
//   int? currentPage;
//   List<Data2>? data2;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   Null? nextPageUrl;
//   String? path;
//   int? perPage;
//   Null? prevPageUrl;
//   int? to;
//   int? total;
//
//   Data1(
//       {this.currentPage,
//         this.data2,
//         this.firstPageUrl,
//         this.from,
//         this.lastPage,
//         this.lastPageUrl,
//         this.links,
//         this.nextPageUrl,
//         this.path,
//         this.perPage,
//         this.prevPageUrl,
//         this.to,
//         this.total});
//
//   Data1.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data2 = <Data2>[];
//       json['data2'].forEach((v) {
//         data2!.add(Data2.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['current_page'] = currentPage;
//     if (data2 != null) {
//       data['data2'] = data2!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = firstPageUrl;
//     data['from'] = from;
//     data['last_page'] = lastPage;
//     data['last_page_url'] = lastPageUrl;
//     if (links != null) {
//       data['links'] = links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = nextPageUrl;
//     data['path'] = path;
//     data['per_page'] = perPage;
//     data['prev_page_url'] = prevPageUrl;
//     data['to'] = to;
//     data['total'] = total;
//     return data;
//   }
// }
//
// class Data2 {
//   String? date;
//   String? slNo;
//   String? accountName;
//   String? fullNarration;
//   String? debit;
//   String? credit;
//   String? type;
//   double? balance;
//
//   Data2(
//       {this.date,
//         this.slNo,
//         this.accountName,
//         this.fullNarration,
//         this.debit,
//         this.credit,
//         this.type,
//         this.balance});
//
//   Data2.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     slNo = json['sl_no'];
//     accountName = json['account_name'];
//     fullNarration = json['full_narration'];
//     debit = json['debit'];
//     credit = json['credit'];
//     type = json['type'];
//     balance = json['balance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['date'] = date;
//     data['sl_no'] = slNo;
//     data['account_name'] = accountName;
//     data['full_narration'] = fullNarration;
//     data['debit'] = debit;
//     data['credit'] = credit;
//     data['type'] = type;
//     data['balance'] = balance;
//     return data;
//   }
// }
//
// class Links {
//   String? url;
//   String? label;
//   bool? active;
//
//   Links({this.url, this.label, this.active});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['url'] = url;
//     data['label'] = label;
//     data['active'] = active;
//     return data;
//   }
// }
