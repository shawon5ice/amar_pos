import 'package:json_annotation/json_annotation.dart';


part 'service_person_response_model.g.dart';

@JsonSerializable()
class ServicePersonResponseModel {
  final bool success;
  @JsonKey(name: 'data')
  final List<ServiceStuffInfo> serviceStuffList;

  ServicePersonResponseModel({
    required this.success,
    required this.serviceStuffList,
  });

  factory ServicePersonResponseModel.fromJson(Map<String, dynamic> json) => _$ServicePersonResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServicePersonResponseModelToJson(this);

}

@JsonSerializable()
class ServiceStuffInfo {
  final int id;
  final String name;
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  ServiceStuffInfo({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory ServiceStuffInfo.fromJson(Map<String, dynamic> json) => _$ServiceStuffInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceStuffInfoToJson(this);

}
