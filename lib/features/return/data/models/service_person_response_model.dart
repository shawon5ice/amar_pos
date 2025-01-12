class ServicePersonResponseModel {
  final bool success;
  final List<ServiceStuffInfo> serviceStuffList;

  ServicePersonResponseModel({
    required this.success,
    required this.serviceStuffList,
  });

  factory ServicePersonResponseModel.fromJson(Map<String, dynamic> json) {
    return ServicePersonResponseModel(
      success: json['success'],
      serviceStuffList: (json['data'] as List<dynamic>)
          .map((item) => ServiceStuffInfo.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': serviceStuffList.map((item) => item.toJson()).toList(),
    };
  }
}

class ServiceStuffInfo {
  final int id;
  final String name;
  final String photoUrl;

  ServiceStuffInfo({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory ServiceStuffInfo.fromJson(Map<String, dynamic> json) {
    return ServiceStuffInfo(
      id: json['id'],
      name: json['name'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
    };
  }
}
