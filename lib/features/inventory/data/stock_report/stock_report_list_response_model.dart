import 'package:json_annotation/json_annotation.dart';

part 'stock_report_list_response_model.g.dart';

@JsonSerializable()
class StockReportListResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final StockReportResponse stockReportResponse;
  @JsonKey(name: 'total_stock')
  final int totalStock;
  @JsonKey(name: 'total_value')
  final num totalValue;

  StockReportListResponseModel({
    required this.success,
    required this.stockReportResponse,
    required this.totalStock,
    required this.totalValue,
  });

  factory StockReportListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StockReportListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportListResponseModelToJson(this);
}

@JsonSerializable()
class StockReportResponse {
  @JsonKey(name: 'data')
  final List<StockReport> stockReportList;
  final Meta meta;

  StockReportResponse({
    required this.stockReportList,
    required this.meta,
  });

  factory StockReportResponse.fromJson(Map<String, dynamic> json) =>
      _$StockReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportResponseToJson(this);
}

@JsonSerializable()
class StockReport {
  final int id;
  final String business;
  final String sku;
  final String name;
  final String? slug;
  final String image;
  @JsonKey(name: 'thumbnail_image')
  final String? thumbnailImage;
  final String? category;
  final String? brand;
  final String? unit;
  final String? warranty;
  @JsonKey(name: 'mfg_date')
  final String? mfgDate;
  @JsonKey(name: 'expired_date')
  final String? expiredDate;
  @JsonKey(name: 'costing_price')
  final num costingPrice;
  @JsonKey(name: 'wholesale_price')
  final num wholesalePrice;
  @JsonKey(name: 'mrp_price')
  final num mrpPrice;
  final int stock;
  @JsonKey(name: 'total_costing')
  final num totalCosting;
  final String? remarks;

  StockReport({
    required this.id,
    required this.business,
    required this.sku,
    required this.name,
    this.slug,
    required this.image,
    this.thumbnailImage,
    this.category,
    this.brand,
    this.unit,
    this.warranty,
    this.mfgDate,
    this.expiredDate,
    required this.costingPrice,
    required this.wholesalePrice,
    required this.mrpPrice,
    required this.stock,
    required this.totalCosting,
    this.remarks,
  });

  factory StockReport.fromJson(Map<String, dynamic> json) =>
      _$StockReportFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}

@JsonSerializable()
class Unit {
  final int id;
  final String name;

  Unit({required this.id, required this.name});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

@JsonSerializable()
class Warranty {
  final String type;
  final int duration;

  Warranty({required this.type, required this.duration});

  factory Warranty.fromJson(Map<String, dynamic> json) =>
      _$WarrantyFromJson(json);

  Map<String, dynamic> toJson() => _$WarrantyToJson(this);
}
