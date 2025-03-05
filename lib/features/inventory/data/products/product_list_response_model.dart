class ProductsListResponseModel {
  ProductsListResponseModel({
    required this.success,
    required this.data,
  });

  late final bool success;
  late final Data data;

  ProductsListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    data = json['data'] is Map<String, dynamic> ? Data.fromJson(json['data']) : Data.empty();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.productList,
    required this.meta,
  });

  late final List<ProductInfo> productList;
  late final Meta meta;

  Data.fromJson(Map<String, dynamic> json) {
    productList = json['data'] != null
        ? List.from(json['data']).map((e) => ProductInfo.fromJson(e)).toList()
        : [];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : Meta.empty();
  }

  Data.empty()
      : productList = [],
        meta = Meta.empty();

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = productList.map((e) => e.toJson()).toList();
    _data['meta'] = meta.toJson();
    return _data;
  }
}

class ProductInfo {
  ProductInfo({
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
  late final num costingPrice;
  late final num wholesalePrice;
  late final num mrpPrice;
  late final num vat;
  late final int isVatApplicable;
  late final num alertQuantity;
  late final num stock;
  late final num totalCosting;
  late final String? remarks;
  late final int status;

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    business = json['business'] ?? '';
    sku = json['sku'] ?? '';
    name = json['name'] ?? '';
    isVatApplicable = json['is_vat_applicable'] ?? 0;
    slug = json['slug'] ?? '';
    image = json['image'] ?? '';
    thumbnailImage = json['thumbnail_image'] ?? '';
    category =  json['category'] is Map<String, dynamic>? Category.fromJson(json['category']) : null;
    brand =  json['brand'] is Map<String, dynamic> ? Brand.fromJson(json['brand']): null;
    unit =  json['unit'] is Map<String, dynamic> ? Unit.fromJson(json['unit']) : null;
    // Handle warranty field
    warranty = json['warranty'] is Map<String, dynamic>
        ? Warranty.fromJson(json['warranty'])
        : null;
    mfgDate = json['mfg_date'] ?? '';
    expiredDate = json['expired_date'] ?? '';
    costingPrice = json['costing_price'] ?? 0;
    wholesalePrice = json['wholesale_price'] ?? 0;
    mrpPrice = json['mrp_price'] ?? 0;
    vat = json['vat'] ?? 0;
    alertQuantity = json['alert_quantity'] ?? 0;
    stock = json['stock'] ?? 0;
    totalCosting = json['total_costing'] ?? 0;
    remarks = json['remarks'];
    status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['business'] = business;
    _data['sku'] = sku;
    _data['name'] = name;
    _data['is_vat_applicable'] = isVatApplicable;
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

class Category {
  Category({
    required this.id,
    required this.name,
  });

  late final int id;
  late final String name;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Category.empty() : id = 0, name = '';

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Brand {
  Brand({
    this.id,
    required this.name,
  });

  late final int? id;
  late final String name;

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
  }

  Brand.empty() : id = null, name = '';

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Unit {
  Unit({
    required this.id,
    required this.name,
  });

  late final int id;
  late final String name;

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Unit.empty() : id = 0, name = '';

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Warranty {
  Warranty({
    required this.id,
    required this.name,
    required this.type,
    required this.count,
  });

  late final int id;
  late final String? name;
  late final int? type;
  late final int? count;

  Warranty.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['count'] = count;
    return _data;
  }
}

class Meta {
  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  late final int currentPage;
  late final int lastPage;
  late final int perPage;
  late final int total;

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'] ?? 0;
    lastPage = json['last_page'] ?? 0;
    perPage = json['per_page'] ?? 0;
    total = json['total'] ?? 0;
  }

  Meta.empty()
      : currentPage = 0,
        lastPage = 0,
        perPage = 0,
        total = 0;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current_page'] = currentPage;
    _data['last_page'] = lastPage;
    _data['per_page'] = perPage;
    _data['total'] = total;
    return _data;
  }
}
