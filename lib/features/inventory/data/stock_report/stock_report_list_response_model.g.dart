// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_report_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockReportListResponseModel _$StockReportListResponseModelFromJson(
        Map<String, dynamic> json) =>
    StockReportListResponseModel(
      success: json['success'] as bool,
      stockReportResponse: const DataConverter().fromJson(json['data']),
      totalStock: (json['total_stock'] as num).toInt(),
      totalValue: json['total_value'] as num,
    );

Map<String, dynamic> _$StockReportListResponseModelToJson(
        StockReportListResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': const DataConverter().toJson(instance.stockReportResponse),
      'total_stock': instance.totalStock,
      'total_value': instance.totalValue,
    };

StockReportResponse _$StockReportResponseFromJson(Map<String, dynamic> json) =>
    StockReportResponse(
      stockReportList: (json['data'] as List<dynamic>)
          .map((e) => StockReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockReportResponseToJson(
        StockReportResponse instance) =>
    <String, dynamic>{
      'data': instance.stockReportList,
      'meta': instance.meta,
    };

StockReport _$StockReportFromJson(Map<String, dynamic> json) => StockReport(
      id: (json['id'] as num).toInt(),
      business: json['business'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      image: json['image'] as String,
      thumbnailImage: json['thumbnail_image'] as String?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      unit: json['unit'] as String?,
      warranty: json['warranty'] as String?,
      mfgDate: json['mfg_date'] as String?,
      expiredDate: json['expired_date'] as String?,
      costingPrice: json['costing_price'] as num,
      wholesalePrice: json['wholesale_price'] as num,
      mrpPrice: json['mrp_price'] as num,
      stock: (json['stock'] as num).toInt(),
      totalCosting: json['total_costing'] as num,
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$StockReportToJson(StockReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business': instance.business,
      'sku': instance.sku,
      'name': instance.name,
      'slug': instance.slug,
      'image': instance.image,
      'thumbnail_image': instance.thumbnailImage,
      'category': instance.category,
      'brand': instance.brand,
      'unit': instance.unit,
      'warranty': instance.warranty,
      'mfg_date': instance.mfgDate,
      'expired_date': instance.expiredDate,
      'costing_price': instance.costingPrice,
      'wholesale_price': instance.wholesalePrice,
      'mrp_price': instance.mrpPrice,
      'stock': instance.stock,
      'total_costing': instance.totalCosting,
      'remarks': instance.remarks,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'total': instance.total,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Warranty _$WarrantyFromJson(Map<String, dynamic> json) => Warranty(
      type: json['type'] as String,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$WarrantyToJson(Warranty instance) => <String, dynamic>{
      'type': instance.type,
      'duration': instance.duration,
    };
