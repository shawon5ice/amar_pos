import 'package:amar_pos/core/core.dart';

class StockReportListResponseModel {
  StockReportListResponseModel({
    required this.success,
    required this.stockReportResponse,
    required this.totalStock,
    required this.totalValue,
  });
  late final bool success;
  late final StockReportResponse stockReportResponse;
  late final int totalStock;
  late final int totalValue;

  StockReportListResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    stockReportResponse = StockReportResponse.fromJson(json['data']);
    totalStock = json['total_stock'];
    totalValue = json['total_value'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = stockReportResponse.toJson();
    _data['total_stock'] = totalStock;
    _data['total_value'] = totalValue;
    return _data;
  }
}

class StockReportResponse {
  StockReportResponse({
    required this.stockReportList,
    required this.meta,
  });
  late final List<StockReport> stockReportList;
  late final Meta meta;

  StockReportResponse.fromJson(Map<String, dynamic> json){
    stockReportList = List.from(json['data']).map((e)=>StockReport.fromJson(e)).toList();
    meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = stockReportList.map((e)=>e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class StockReport {
  StockReport({
    required this.id,
    required this.business,
    required this.sku,
    required this.name,
    required this.slug,
    required this.image,
    required this.thumbnailImage,
    required this.category,
    required this.brand,
    required this.unit,
    required this.warranty,
    required this.mfgDate,
    required this.expiredDate,
    required this.costingPrice,
    required this.wholesalePrice,
    required this.mrpPrice,
    required this.vat,
    required this.alertQuantity,
    required this.stock,
    required this.totalCosting,
    this.remarks,
    required this.status,
  });
  late final int id;
  late final String business;
  late final String sku;
  late final String name;
  late final String slug;
  late final String image;
  late final String thumbnailImage;
  late final Category? category;
  late final Brand? brand;
  late final Unit? unit;
  late final Warranty? warranty;
  late final String mfgDate;
  late final String expiredDate;
  late final int costingPrice;
  late final int wholesalePrice;
  late final int mrpPrice;
  late final int vat;
  late final int alertQuantity;
  late final int stock;
  late final int totalCosting;
  late final String? remarks;
  late final int status;

  StockReport.fromJson(Map<String, dynamic> json){
    id = json['id'];
    business = json['business'];
    sku = json['sku'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    category = json['category'] is Map<String, dynamic> ? Category.fromJson(json['category']) : null;
    brand = json['brand'] is Map<String, dynamic> ? Brand.fromJson(json['brand']) : null;
    unit = json['unit'] is Map<String, dynamic> ? Unit.fromJson(json['unit']) : null;
    warranty = json['warranty'] is Map<String, dynamic> ? Warranty.fromJson(json['warranty']) : null;
    mfgDate = json['mfg_date'];
    expiredDate = json['expired_date'];
    costingPrice = json['costing_price'];
    wholesalePrice = json['wholesale_price'];
    mrpPrice = json['mrp_price'];
    vat = json['vat'];
    alertQuantity = json['alert_quantity'];
    stock = json['stock'];
    totalCosting = json['total_costing'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['sku'] = sku;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['image'] = image;
    _data['thumbnail_image'] = thumbnailImage;
    _data['category'] = category?.toJson();
    _data['brand'] = brand?.toJson();
    _data['unit'] = unit?.toJson();
    _data['warranty'] = warranty?.toJson();
    _data['mfg_date'] = mfgDate;
    _data['expired_date'] = expiredDate;
    _data['costing_price'] = costingPrice;
    _data['wholesale_price'] = wholesalePrice;
    _data['mrp_price'] = mrpPrice;
    _data['vat'] = vat;
    _data['alert_quantity'] = alertQuantity;
    _data['stock'] = stock;
    _data['total_costing'] = totalCosting;
    _data['remarks'] = remarks;
    _data['status'] = status;
    return _data;
  }
}